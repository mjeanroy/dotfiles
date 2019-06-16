#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/common.sh

info "Installing OpenJDK11"
sudo apt install -y openjdk-11-jdk openjdk-11-source

info "Installing OpenJDK8"
sudo apt install -y openjdk-8-jdk openjdk-8-source

info "Checking for installed java & javac version"

debug "Checking java"
java -version

debug "Checking javac"
javac -version
