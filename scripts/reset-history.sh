#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"

function select-history-tags() { cat - | grep -e '^man-pages-'; }
function get-local-tags(){ git --no-pager tag --list  | select-history-tags; }
function get-remote-history-tags(){
  git --no-pager ls-remote --tags origin | select-history-tags;
}

function delete-local-tags(){
  log-info "deleting local history tags"
  for tag in $(get-local-tags); do
    git tag -d "$tag";
  done
}

function delete-remote-tags() {
  log-info "deleting remote history tags"
  for tag in $(get-remote-history-tags); do
    git push --delete "$tag";
  done
}

function exterminate-history-tags(){
  delete-remote-tags &&
    delete-local-tags &&
    (cd-into-history-dir && delete-local-tags;);
}

function get-first-commit(){
  local ref="${1:?ref is required}";
  git rev-list --max-parents=0 "$ref" --;
  # -- needed to differentiate refs from similarly-named files
  # example error: "ambiguous argument 'history': both revision and filename"
}

function exterminate-history() {
  (
    set -euo pipefail;
    exterminate-history-tags;
    cd-into-history-dir;
    git reset --hard "$(get-first-commit 'history')";
    git push -f origin 'history';
    git gc;
  )
}

exterminate-history