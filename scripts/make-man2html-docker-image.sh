#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"
PATH_TO_DOCKERFILE="$(realpath "$THIS_DIR/../Dockerfile")"
docker build -t man2html - < "$PATH_TO_DOCKERFILE"