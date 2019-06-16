#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

info "Installing Google Chrome"

if [ -x "$(command -v google-chrome)" ]
then
  info "Google Chrome seems already installed, skip."
else
  sudo rm -f /tmp/google-chrome-stable_current_amd64.deb
  sudo apt install -y fonts-liberation libappindicator3-1 libdbusmenu-glib4 libdbusmenu-gtk3-4 libindicator3-7 libxss1 libu2f-udev
  curl -o /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
  sudo rm /tmp/google-chrome-stable_current_amd64.deb
fi

debug "Checking Google Chrome version"
google-chrome --version

info "Installing Brave"

if [ -x "$(command -v brave-browser)" ]
then
  info "Brave Browser seems already installed, skip."
else
  sudo apt install -y fonts-liberation libappindicator3-1 libdbusmenu-glib4 libdbusmenu-gtk3-4 libindicator3-7 libxss1 libu2f-udev
  curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
  sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com `lsb_release -sc` main" >> /etc/apt/sources.list.d/brave.list'
  sudo apt update -y
  sudo apt install -y brave-browser brave-keyring
fi

debug "Checking Brave Browser version"
brave-browser --version
