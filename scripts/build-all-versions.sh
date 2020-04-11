#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"
declare -a ALL_VERSIONS;

function main() {
  for version in $("$REPO_ROOT"/scripts/get-versions.sh); do
    ALL_VERSIONS+=("$version");
  done
  local max="${#ALL_VERSIONS[@]}";
  local version=
  for ((i = 0 ; i < "$max" ; i++)); do
    version="${ALL_VERSIONS[$i]}"
    log-info "processing version $i / $max: $version"
    "$REPO_ROOT"/scripts/build-version.sh "$version"
  done
}

main