#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"

function get-man-pages-versions() {
  (
    cd-into-man-pages-dir &&
      git pull &>/dev/null &&
      git --no-pager tag --list
  );
}

get-man-pages-versions;