#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"
VERSION=
HM_LOG_FILE=
HTOPTS="-h -r -p"
export HTDIR=

function build-file() {
  local file="${1:?file is required}"
  local dest="${2:?destination is required}"
  man2html -h -r -p -D "$file" "$file" | sed -e '1,2d' > "$dest";
}
export -f build-file;

function parallel-build-all-files() {
  input_files=();
  output_files=();
 
  for output_dir in "$MAN_PAGES_REPO_DIR"/man*/; do
    mkdir -p "${output_dir/$MAN_PAGES_REPO_DIR/$HTDIR}";
  done
  
  for f in "$MAN_PAGES_REPO_DIR"/man*/*; do
    input_files+=("$f");
    local output_file="${f/$MAN_PAGES_REPO_DIR/$HTDIR}"
    output_files+=("${output_file%*.}.html");
  done

  (
    parallel --jobs 100% --bar \
    build-file {} \
      ::: "${input_files[@]}" \
      :::+ "${output_files[@]}" 2>&1;
  ) | tee /dev/stderr | log-debug
}

function set-man-pages-version() {
  local ref="${1:?ref is required}";
  (cd "$MAN_PAGES_REPO_DIR" && git checkout --force "$ref") 2>&1 | log-debug
}

function tag-build() {
  local version="${1:?version is required}"
  local version_date="${2:?date is required}"
  log-info "tagging build $version"
  (
    cd "$HTDIR" && git add -A . &&
      git commit -m "$version ~ $version_date" &&
      git tag "$version"
  ) | tee /dev/stderr | log-debug
}

function get-version-date(){
  local version="${1:?version is required}"
  (
    cd "$MAN_PAGES_REPO_DIR" && git show -s --format=%ci | awk '{ print $1 }'
  )
}

function build-version() {
  log-debug "build-version man2html opts: HTDIR='$HTDIR'"
  local version_date="$(get-version-date "$VERSION")"
  set-man-pages-version "$VERSION" && 
    parallel-build-all-files &&
    tag-build "$VERSION";
  result=$?
  set-man-pages-version "master";
  cd "$REPO_ROOT" || return $result;
  return $result;
}

function prettify-version() { # TODO: move to parallel
  log-debug "Prettier log:"
  (
    parallel --jobs 100% --bar prettier --write ::: "$HTDIR"/**/*.html
  ) 2>&1 | log-debug;
}


function main() {
  VERSION="${1:?version argument is required}"
  HM_LOG_FILE="$(get-log-file-path "$VERSION")"
  HTDIR="$(get-htdir-path "$VERSION")"
  log-info "building $VERSION";
  if ! (version-already-exists); then
    build-version;
  fi
}

main "$@"