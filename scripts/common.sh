#!/usr/bin/env bash

HM_LOG_FILE="${HM_LOG_FILE:-/dev/stdout}"
HM_LOG_LEVEL="${HM_LOG_LEVEL:-INFO}"

function translate-log-level(){
  case $1 in
    INFO) echo "1";;
    DEBUG) echo "2";;
    *) echo "-1";;
  esac
}

function decorated-log() {
  local LEVEL="${1:?logger level must be set}"; shift;
}

function args-or-stdin() { if [ -z "$*" ]; then cat -; else echo "$*"; fi }

function logger() {
  local LEVEL="${1:?logger level must be set}"; shift;
  LOG_LEVEL="$(translate-log-level "$HM_LOG_LEVEL")";
  if [ "$(translate-log-level "$LEVEL")" -ge "$LOG_LEVEL" ]; then
    echo "[ $LEVEL ] $(args-or-stdin "$@")" >> "$HM_LOG_FILE";
  fi
}

function log-info() { logger "INFO" "$*"; }
function log-debug() { logger "DEBUG" "$*"; }

SCRIPTS_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"; export SCRIPTS_DIR;
REPO_ROOT="$(realpath "$SCRIPTS_DIR/..")"; export REPO_ROOT;
MAN_PAGES_REPO_DIR="$REPO_ROOT/external/man-pages"; export MAN_PAGES_REPO_DIR;
DIST_DIR="$REPO_ROOT/dist"
LOG_DIR="$REPO_ROOT/logs"

function get-htdir-path() {
  local version="${1:?version argument is required}"
  echo "$REPO_ROOT/history"
}

function get-log-file-path() { 
  local version="${1:?version argument is required}"
  echo "$REPO_ROOT/logs/$version.log"  
}

function version-already-exists() { [ -d "$HTDIR" ]; }