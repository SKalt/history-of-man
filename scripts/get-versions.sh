#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"

function main() {
  (
    cd "$MAN_PAGES_REPO_DIR" || log-debug "unable to cd into $MAN_PAGES_REPO_DIR";
    git --no-pager tag --list
  );
}

main;