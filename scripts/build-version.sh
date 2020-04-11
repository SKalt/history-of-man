#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"
set -xe
VERSION="${VERSION:?version argument is required}"
HTDIR="$REPO_ROOT/dist/$VERSION"

function trap-error() {
  echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

function build() {
  cd "$REPO_ROOT/external/man-pages" &&
    git checkout $VERSION &&
    echo "pwd=$PWD HTDIR=$HTDIR" &&
    make html &&
    cd -;
}

build