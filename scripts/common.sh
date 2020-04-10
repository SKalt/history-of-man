#!/usr/bin/env bash
function log-info() { echo "[ INFO ] $*"; }
_scripts_dir=
_scripts_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
export SCRIPTS_DIR="$_scripts_dir"
