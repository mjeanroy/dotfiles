#!/bin/bash

###
# Intellij Configuration
###

function git-up {
  if [[ -d "./.git" ]]; then
    git pull --rebase
  fi

  for dir in *; do
    pushd $dir
    if [[ -d "./.git" ]]; then
      git pull --rebase
    fi
    popd;
  done
}
