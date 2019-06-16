#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

info "Updating distribution"
sudo apt update -y && sudo apt upgrade -y

info "Installing main packages"
sudo apt install -y \
  git \
  build-essential \
  curl \
  wget \
  vim \
  software-properties-common \
  zip \
  bzip2 \
  python3 \
  filezilla \
  terminator \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  keepassx

info "Checking for main utilities versions"

debug "-- Checking CURL"
curl --version

debug "-- Checking GIT"
git --version

debug "-- Checking VIM"
vim --version