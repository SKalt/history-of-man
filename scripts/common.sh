#!/usr/bin/env bash
set -e
HM_LOG_FILE="${HM_LOG_FILE:-/dev/stdout}"
HM_LOG_LEVEL="${HM_LOG_LEVEL:-INFO}"

function logger() {
  local LEVEL="${1:?logger level must be set}"; shift;
  if [ "$HM_LOG_LEVEL" = "$LEVEL" ]; then
    echo "[ $LEVEL ] $*" > "$HM_LOG_FILE";
  fi
}

function log-info() { logger "INFO" "$*"; }
function log-debug() { logger "DEBUG" "$*"; }

SCRIPTS_DIR=;
export SCRIPTS_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
REPO_ROOT=;
export REPO_ROOT="$(realpath "$SCRIPTS_DIR/..")"