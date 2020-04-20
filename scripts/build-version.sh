#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"

function extract-copyright-lines() {
  local file="${1:?file is required}"
  grep -ie '^\.\\" copyright' "$file" | sed 's/^.\\" //';
}
declare -f extract-copyright-lines

function extract-license-text() {
  local file="${1:?file is required}"
  awk '/%%%LICENSE_START\(/,/%%%LICENSE_END/' "$file"  | sed 's/^.\\" //';
}
declare -f extract-license-text

function escape-html-content() {
  cat - | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g;'
}
declare -f esacape-html-content

function html-comment-license() {
  local file="${1:?file is required}"
  echo '<!--';
  extract-copyright-lines "$file" | escape-html-content;
  extract-license-text    "$file" | escape-html-content;
  echo "-->";
}
declare -f html-comment-license;

function build-file() {
  local file="${1:?file is required}"
  local dest="${2:?destination is required}"
  (
    html-comment-license "$file";
    man2html -h -r -p -D "$file" "$file" | sed -e '1,2d';
  ) > "$dest"
}
export -f build-file;

function get-changed-file-names() {
  local filter="${1:?filter is required}"
  local prev_ref="${1:?prev ref is required}";
  local next_ref="${2:?next ref is required}";
  (
    cd-into-man-pages-dir     &&
    git --no-pager diff        \
      --name-only              \
      --diff-filter="$filter"  \
      "$prev_ref".."$next_ref" \
      -- man?
  )
}

function get-modified-file-names() {
  local prev_ref="${1:?prev ref is required}";
  local next_ref="${2:?next ref is required}";
  get-changed-file-names "M" "$prev_ref" "$next_ref"
}

function get-moved-file-names(){
  local prev_ref="${1:?prev ref is required}";
  local next_ref="${2:?next ref is required}";
  get-changed-file-names "R" "$prev_ref" "$next_ref" | awk '{ print $2 $3 }'
}

function prep-moved-files() {
  local prev_ref="${1:?prev ref is required}";
  local next_ref="${2:?next ref is required}";
  (
    set -euo pipefail;
    cd-into-history-dir;
    get-moved-file-names "$prev_ref" "$next_ref" | while read -r to_move; do
      local src=''; local dest=''
      src="$(echo "$to_move" | awk '{print $1}')"
      dest="$(echo "$to_move" | awk '{print $2}')"
      # $to_move is two words which MUST expand for git mv to function
      git mv "$src" "$dest";
    done
  )
}

function get-deleted-files(){
  local prev_ref="${1:?prev ref is required}"
  local next_ref="${2:?prev ref is required}"
  get-changed-file-names "D"
}

function prep-deleted-files(){
  local prev_ref="${1:?prev ref is required}";
  local next_ref="${2:?next ref is required}";
  (
    cd "$HISTORY_SUBREPO_DIR" && get-deleted-files "$prev_ref" "$next_ref" | xargs git rm -rf 
  )
}

function get-all-file-names() { ( cd-into-man-pages-dir && echo ./man?/*; ); }

function parallel-build-files() {
  (
    parallel --jobs 100% --bar \
      build-file "$MAN_PAGES_REPO_DIR"/{} "$HISTORY_SUBREPO_DIR"/{}.html \
      ::: "$@" 2>&1;
  ) | tee /dev/stderr | log-debug
}

function get-all-man-page-directories() {
  (cd-into-man-pages-dir && echo ./man?*/;)
}

function ensure-all-man-page-directories-present() {
  (
    cd-into-history-dir || exit 1;
    for output_dir in $(get-all-man-page-directories); do
      mkdir -p "$output_dir";
    done
  )
}

function get-file-names-to-rebuild() {
  local prev_ref="${1:?prev ref is required}";
  local next_ref="${2:?next ref is required}";
  get-modified-file-names "$prev_ref" "$next_ref";
  get-moved-file-names "$prev_ref" "$next_ref" | awk '{ print $2 }';
}

function parallel-build-all-files() {
  local prev_ref="${1:?prev ref is required}";
  local next_ref="${2:?next ref is required}";
  # shellcheck disable=2046
  parallel-build-files $(get-file-names-to-rebuild "$prev_ref" "$next_ref")
}

function build-first-version(){
  # shellcheck disable=2046
  parallel-build-files $(get-all-file-names)
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
    set -euo pipefail;
    cd-into-history-dir;
    git add -A . &&
      git config user.name 'anon' &&
      git config user.email 'anon@mous.org' &&
      git commit -m "$version ~ $version_date" &&
      git tag "$version" &&
      git prune &&
      git gc
  ) | tee /dev/stderr | log-debug
}

function get-version-date(){
  local version="${1:?version is required}"
  (
    cd "$MAN_PAGES_REPO_DIR" &&
    git log -1 --format=%ci "$version" | awk '{ print $1 }'
  )
}

function clean-build-dir() {
  ( cd "$HISTORY_SUBREPO_DIR" && rm -rf ./*; ) | tee /dev/stderr | log-debug
}


function build-version() {
  local prev_version='';
  local version='';
  local version_date='';

  case "$#" in
    1) version="${1:?version argument is required}";;
    2) prev_version="$1"; version="${2:?version argument is required}";;
    *) log-info "expected 1-2 args, got $#" && return 1;
  esac

  HM_LOG_FILE="$(get-log-file-path "$version")"
  log-info "building $version";

  version_date="$(get-version-date "$version")"
  set-man-pages-version "$version";

  # assertion: on a full rebuild, the history dir will be clean and the 
  # history branch will have only an empty commit
  ensure-all-man-page-directories-present;

  if [ -n "$prev_version" ]; then
    parallel-build-all-files "$prev_version" "$version"
  else
    build-first-version "$version"
  fi

  tag-build "$version" "$version_date";
  # result=$?
  # # set-man-pages-version "master";
  # cd "$REPO_ROOT" || return $result;
  # return $result;
}

build-version "$@"