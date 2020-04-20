#!/usr/bin/env bash
# shellcheck disable=SC2119
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"

function get-first-commit(){
  local ref="${1:?ref is required}"
  git rev-list --max-parents=0 "$ref" --
  # -- needed to differentiate refs from similarly-named files
  # fatal: ambiguous argument 'history': both revision and filename
  # Use '--' to separate paths from revisions
}

function create-empty-branch() {
  local branch_name="${1:?branch name is required}"
  if (git --no-pager branch | grep -q ""); then
    # TODO: reset branch
    return
  fi
  log-info "creating an empty branch '$branch_name':"
  (
    cd "$REPO_ROOT" &&
      git checkout --orphan "$branch_name" &&
      git reset &&
      touch .gitkeep &&
      git add .gitkeep &&
      git commit -m "empty commit" &&
      git push --set-upstream origin "$branch_name" &&
      git checkout --force master
  ) | tee /dev/stderr | log-debug
}

function create-history-submodule {
  local branch_name="${1:?branch name is required}"
  local dir_name="${2:?directory name is required}"
  log-info "creating a submodule of this repo  @ '$branch_name' in '$dir_name'"
  (
    cd "$REPO_ROOT" &&
      git submodule add -b "$branch_name" -- ./ "$dir_name" &&
      git add .gitmodules "$dir_name"
  ) | tee /dev/stderr | log-debug
}

function main() {
  local branch_name="${1:?branch name is required}"
  local dir_name="${2:?directory name is required}"
  set-log-file "submodule";
  create-empty-branch "$branch_name" &&
    create-history-submodule "$branch_name" "$dir_name"
}

main "history" "history"