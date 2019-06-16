#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

info "Installing Atom"

if [ -x "$(command -v atom)" ]
then
  info "Atom seems already installed, skip."
else
  sudo apt install -y curl gnupg-agent software-properties-common apt-transport-https wget
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
  sudo apt install -y curl gnupg-agent software-properties-common apt-transport-https wget
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
  sudo install -o root -g root -m 644 /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo rm /tmp/microsoft.gpp
  sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
  sudo apt update -y
  sudo apt install -y code
fi

debug "Checking VSCode version"
code --version

info "Installing Intellij IDEA"

# To get the latest version we scan through the updates.xml to find the current release version.
sudo apt install -y curl libxml2-utils
builds=$(curl -s https://www.jetbrains.com/updates/updates.xml | xmllint --xpath "//product[@name='IntelliJ IDEA']/channel[@id='IC-IU-RELEASE-licensing-RELEASE']" - )
latestNumber=$(echo $builds | xmllint --xpath "//build/@number" - | sed 's/number=\"\([[:digit:]]*\.[[:digit:]]*\)\"/\1/g' | tr " " "\n" | sort -bnr | head -1)
latestVersion=$(echo $builds | xmllint --xpath "string(//build[@number=$latestNumber]/@version)" -)
file="ideaIU-$latestVersion.tar.gz"
download_url="https://download.jetbrains.com/idea/${file}"

debug "Downloading Intellij IDEA (from: ${download_url})"
curl -L -o /tmp/${file} ${download_url}

debug "Intalling Intellij IDEA"
idea_dir=`tar -tzf /tmp/${file} | head -1 | cut -f1 -d"/"`

sudo rm -f /opt/${file}
sudo rm -rf /opt/${idea_dir}
sudo mv /tmp/${file} /opt/${file}
sudo tar xvfz /opt/${file} -C /opt
sudo rm -f /opt/idea
sudo ln -s /opt/${idea_dir} /opt/idea
sudo rm -f /opt/${file}
