#!/usr/bin/env bash
# shellcheck source=scripts/common.sh
. "${BASH_SOURCE[0]%/*}/common.sh"
potential_git_lock=.git/modules/external/man-pages/index.lock;
if [ -e $potential_git_lock ]; then rm -rf $potential_git_lock; fi 
sudo rm -rf "$REPO_ROOT/external/man-pages" && git submodule update