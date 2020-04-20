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
export MAN_PAGES_REPO_DIR="$REPO_ROOT/external/man-pages";
export LOG_DIR="$REPO_ROOT/logs"
export HISTORY_SUBREPO_DIR="$REPO_ROOT/history"
# TODO: use a global constant instead of this function

function get-log-file-path() { 
  local version="${1:?version argument is required}"
  echo "$LOG_DIR/$version.log"  
}

function cd-or-log-failure() {
  cd "$1" && return 0;
  log-info "cd'ing into $1 failed";
  return 1;
}
function cd-into-history-dir() { cd-or-log-failure "$HISTORY_SUBREPO_DIR"; }
function cd-into-man-pages-dir() { cd-or-log-failure "$MAN_PAGES_REPO_DIR"; }