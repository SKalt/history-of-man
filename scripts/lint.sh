#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"
shellcheck -x "$SCRIPTS_DIR"/*.sh