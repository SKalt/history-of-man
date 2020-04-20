#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
source "${BASH_SOURCE[0]%/*}/common.sh"

function main() {
  local versions=();
  for version in $("$REPO_ROOT"/scripts/get-versions.sh); do
    versions+=("$version");
  done
  local max="${#versions[@]}";
  local version="${versions[0]}"
  log-info "processing version 1 / $max: $version"
  "$REPO_ROOT"/scripts/build-version.sh "$version"

  local prev_version="$version"
  for ((i = 1 ; i < "$max" ; i++)); do
    version="${ALL_VERSIONS[$i]}"
    log-info "processing version $i / $max: $version"
    "$REPO_ROOT"/scripts/build-version.sh "$prev_version" "$version"
  done
}

main