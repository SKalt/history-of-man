#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"

function prettify-file() { # TODO: move to parallel
  local file="${1:?file is required}"
  prettier --write "$file" 2>&1;
}
export -f prettify-file;


function prettify-version() {
  VERSION="${1:?version argument is required}"
  HM_LOG_FILE="$LOG_DIR/prettier.$VERSION.log"
  log-info "prettifying $VERSION";
  (
    parallel \
      --jobs 50% \
      --bar prettify-file {} ::: "$DIST_DIR/$VERSION"/**/*.html
  ) | tee /dev/stderr | log-debug
}

function main() {
  versions=()
  for version in "$DIST_DIR"/man-pages-*; do
    versions+=("${version##*/}");
  done
  for version in "${versions[@]:16}"; do
    prettify-version "$version"
  done
}

main