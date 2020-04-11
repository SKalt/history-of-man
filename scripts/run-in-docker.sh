#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"

function main() {
  local script="${1:-./scripts/build-all-versions.sh}"; shift;
  docker run \
    -u "$(id -u):$(id -g)" \
    -v "$REPO_ROOT":/local \
    -it \
    -e "HM_LOG_LEVEL=DEBUG" \
    man2html "$script" "$@"
}

main "$@"