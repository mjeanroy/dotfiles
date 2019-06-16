#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

info "Installing Atom"

if [ -x "$(command -v atom)" ]
then
  info "Atom seems already installed, skip."
else
  wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
  sudo apt update -y
  sudo apt install -y atom
fi

debug "Checking atom version"
atom --version

info "Installing VSCode"
if [ -x "$(command -v code)" ]
then
  info "VSCode seems already installed, skip."
else
  sudo apt install -y fonts-liberation libappindicator3-1 libdbusmenu-glib4 libdbusmenu-gtk3-4 libindicator3-7 libxss1 libu2f-udev
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update -y
  sudo apt install -y code
fi

debug "Checking VSCode version"
code --version
