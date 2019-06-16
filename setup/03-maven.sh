#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

DEFAULT_MVN_VERSION=3.6.1

info "Installing Maven"
read -e -i "$DEFAULT_MVN_VERSION" -p "Choose maven version: " mvn_version

DOWNLOAD_URL="http://apache.mirrors.ovh.net/ftp.apache.org/dist/maven/maven-3/${mvn_version}/binaries/apache-maven-${mvn_version}-bin.tar.gz"

debug "Downloading maven ${mvn_version} (from: ${DOWNLOAD_URL})"

sudo apt install -y curl
curl -L -o /tmp/apache-maven-${mvn_version}-bin.tar.gz ${DOWNLOAD_URL}

debug "Copying maven to /opt"
sudo rm -f /opt/apache-maven-${mvn_version}-bin.tar.gz
sudo rm -rf /opt/apache-maven-${mvn_version}
sudo mv /tmp/apache-maven-${mvn_version}-bin.tar.gz /opt
sudo tar xvfz /opt/apache-maven-${mvn_version}-bin.tar.gz -C /opt
sudo rm /opt/apache-maven-${mvn_version}-bin.tar.gz
sudo rm -f /opt/maven
sudo ln -s /opt/apache-maven-${mvn_version} /opt/maven

debug "Checking mvn version"
/opt/maven/bin/mvn -version
