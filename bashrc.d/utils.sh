#!/bin/bash

###
# Intellij Configuration
###

function git-up {
  local GREEN="\033[0;32m"
  local RESET_COLORS="\033[0m"

  if [[ -d "./.git" ]]; then
    git pull --rebase
  fi

  for dir in *; do
    if [[ -d "$dir/.git" ]]; then
      echo "${GREEN}Updating $dir...${RESET_COLORS}"
      (cd $dir && git pull --rebase)
      echo ""
    fi
  done
}

function rm-node-modules {
  local GREEN="\033[0;32m"
  local YELLOW="\033[0;33m"
  local RESET_COLORS="\033[0m"

  echo "${GREEN}💥 Checking node_modules to delete...${RESET_COLORS}"
  find . -name 'node_modules' -type d -prune
  echo ""

  echo "${GREEN}🗑️  Deleting node_modules...${RESET_COLORS}"
  echo "${YELLOW}⌛ Waiting 3s, cancel it now...${RESET_COLORS}"
  sleep 3
  echo "${YELLOW}⌛ Deletion in progress...${RESET_COLORS}"
  find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +

  echo ""
  echo "${GREEN}🚀 Done!${RESET_COLORS}"
}
