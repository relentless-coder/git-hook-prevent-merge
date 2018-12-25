#!/usr/bin/env bash

set -e

branches=""
targetDir=""
validBranches=""
OS=`uname`

function usage() {
  printf -- "\033[0mUsage: bash $0 < -b > < -d >\n\n
  -b    single branch or a list of branch separated by comma\n
  -d    absolute path to the project folder" 1>&2; exit 1;
}

function collect_args() {
  printf "\033[39m Collecting arguments\n\n"
  while getopts ":b:d:" opt; do
    case "${opt}" in
      b)
        branches=$OPTARG
        ;;
      d)
        if [ -d "$OPTARG" ]; then
          if [ "${OPTARG: -1}" == "/" ]; then
            targetDir=$(echo "${OPTARG::${#OPTARG}-1}")
          else
            targetDir=$OPTARG
          fi
        else
          echo "Directory: $OPTARG not found" 1>&2
          exit 1
        fi
        ;;
      \?)
        echo "Invalid option: $OPTARG" 1>&2
        exit 1
        ;;
      :)
        echo "Invalid argument: $OPTARG requires an argument" 1>&2
        exit 1
        ;;
    esac
  done
  shift $((OPTIND -1))
}

function validate_args() {
  printf "\033[39m Validating arguments\n\n"
  if [ -z "${branches}" ] || [ -z "${targetDir}" ]; then
    printf "\033[31m No branches or targetDir found. Exiting..\n\n"
    usage
  fi
}

function validate_branches() {
  printf "\033[39m Validating branches\n\n"
  for branch in $(echo $branches | sed "s/,/ /g"); do
    if [ -e "$targetDir/.git/refs/heads/$branch" ]; then
      validBranches+="${branch},"
    else
      echo "\033[31m Branch $branch doesn't exist" 1>&2; exit 1;
    fi
  done
  validBranches=$(echo "${validBranches::${#validBranches}-1}")
}

function setup_template() {
  printf "\033[39m Setting up prepare-commit-msg hook\n\n"
  mkdir -p .hooks_config && touch .hooks_config/prepare_commit_msg_template
  cat prepare_commit_msg_template > .hooks_config/prepare_commit_msg_template
  if [[ "$OS" == 'Darwin' ]]
  then
    sed -i '' "s/#provided_branches/PROVIDED_BRANCHES=\"$validBranches\"/" .hooks_config/prepare_commit_msg_template
  else
    sed -i "s/#provided_branches/PROVIDED_BRANCHES=\"$validBranches\"/" .hooks_config/prepare_commit_msg_template
  fi
}

function copy_hook() {
  printf "\033[39m Copying hook to $targetDir\n\n"
  cp .hooks_config/prepare_commit_msg_template $targetDir/.git/hooks/prepare-commit-msg
  chmod +x $targetDir/.git/hooks/prepare-commit-msg
}

function clean_up() {
  printf "\033[39m Cleaning up\n\n"
  rm -r .hooks_config
  printf -- '\033[32m Success!!'
  exit 0
}

printf "\033[32m\n
           -----------------------------------------------\n
           Welcome to git-hook-prevent-merge. Let's begin.\n
           -----------------------------------------------\n\n"

collect_args "$@"

validate_args

validate_branches

setup_template

copy_hook

clean_up
