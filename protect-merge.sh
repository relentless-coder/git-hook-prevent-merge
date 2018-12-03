#!/usr/bin/env bash

set -e

branchArgs=$1
path=$2

targetDir=$path/.git/hooks

echo $branchArgs

function setup_template() {
  mkdir -p .hooks_config && touch .hooks_config/prepare_commit_msg_template
  cat prepare_commit_msg_template > .hooks_config/prepare_commit_msg_template
  sed -i '' "s/#replace_me_with_branches/FORBIDDEN_BRANCHES=[\"$branchArgs\"]/" .hooks_config/prepare_commit_msg_template
}

function copy_hook() {
  cp .hooks_config/prepare_commit_msg_template $targetDir/prepare-commit-msg
  chmod +x $targetDir/prepare-commit-msg
}

function clean_up() {
  rm -r .hooks_config
}

setup_template

copy_hook

clean_up
