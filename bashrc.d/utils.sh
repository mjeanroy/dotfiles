#!/bin/bash

###
# Intellij Configuration
###

function git-up {
  if [[ -d "./.git" ]]; then
    git pull --rebase
  fi

  for dir in *; do
    if [[ -d "$dir/.git" ]]; then
      echo "\033[0;32mUpdating $dir...\033[0m"
      (cd $dir && git pull --rebase)
      echo ""
    fi
  done
}
