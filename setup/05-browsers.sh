#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

info "Installing Brave"

if [ -x "$(command -v brave-browser)" ]
then
  info "Brave Browser seems already installed, skip."
else
  sudo apt install -y curl gnupg-agent
  curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
  source /etc/os-release
  echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list
  sudo apt update -y
  sudo apt install -y brave-browser brave-keyring
fi

debug "Checking Brave Browser version"
brave-browser --version

info "Installing Google Chrome"

if [ -x "$(command -v google-chrome)" ]
then
  info "Google Chrome seems already installed, skip."
else
  sudo rm -f /tmp/google-chrome-stable_current_amd64.deb
  sudo apt install -y curl gnupg-agent
  curl -L -o /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
  sudo apt -f install
  sudo rm /tmp/google-chrome-stable_current_amd64.deb
fi

debug "Checking Google Chrome version"
google-chrome --version
