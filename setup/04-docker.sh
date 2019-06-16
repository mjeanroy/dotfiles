#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

info "Installing docker"

debug "Removing previous docker installation (if any)"
sudo apt-get remove docker docker-engine docker.io containerd runc

debug "Installing docker mandatory dependencies"
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

debug "Adding Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

debug "Adding docker repository"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

debug "Installing docker"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

info "Checking for docker version"
docker --version

info "Installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.24.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

info "Checking docker-compose version"
docker-compose --version
