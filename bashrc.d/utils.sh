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
      (cd $dir && git remote prune origin)
      echo ""
    fi
  done
}

function npm-i {
  local GREEN="\033[0;32m"
  local RESET_COLORS="\033[0m"

  if [ -f "./package-lock.json" ]; then
    echo "${GREEN}⌛ NPM detected, running: npm install --no-audit --no-fund${RESET_COLORS}"
    echo ""
    npm install --no-audit --no-fund
  elif [ -f "./yarn.lock" ]; then
    echo "${GREEN}⌛ YARN detected, running: yarn install${RESET_COLORS}"
    echo ""
    yarn install
  elif [ -f "./pnpm-lock.yaml" ]; then
    echo "${GREEN}⌛ PNPM detected, running: pnpm install${RESET_COLORS}"
    echo ""
    pnpm install
  elif [ -f "./package.json" ]; then
    # Fallback to pnpm by default.
    echo "${GREEN}⌛ NODE detected, running: pnpm install${RESET_COLORS}"
    echo ""
    pnpm install
  fi
}

function npm-r {
  local GREEN="\033[0;32m"
  local RESET_COLORS="\033[0m"

  if [ -f "./package-lock.json" ]; then
    echo "${GREEN}⌛ NPM detected, running: npm run $*${RESET_COLORS}"
    echo ""
    npm run "$@"
  elif [ -f "./yarn.lock" ]; then
    echo "${GREEN}⌛ YARN detected, running: yarn $*${RESET_COLORS}"
    echo ""
    yarn "$@"
  elif [ -f "./pnpm-lock.yaml" ]; then
    echo "${GREEN}⌛ PNPM detected, running: pnpm run $*${RESET_COLORS}"
    echo ""
    pnpm run "$@"
  elif [ -f "./package.json" ]; then
    # Fallback to pnpm by default
    echo "${GREEN}⌛ NODE detected, running: pnpm run $*${RESET_COLORS}"
    echo ""
    pnpm run "$@"
  fi
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

alias ni='npm-i'
alias nr='npm-r'
