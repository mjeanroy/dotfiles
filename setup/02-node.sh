#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

DEFAULT_NVM_VERSION=0.34.0
DEFAULT_NODE_VERSION=10.16.0

info "Installing NVM"
read -e -i "$DEFAULT_NVM_VERSION" -p "Choose nvm version: " nvm_version

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${nvm_version}/install.sh | bash

debug "Checking NVM installation"
source ~/.bashrc
source ~/.nvm/nvm.sh
nvm --version

info "Installing NodeJS"
read -e -i "$DEFAULT_NODE_VERSION" -p "Choose nodejs version: " node_version
nvm install $node_version
nvm use $node_version
nvm alias default $node_version
