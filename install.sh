#!/bin/bash

HOME="$( cd ~ && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function debug {
  echo "[debug] $1"
}

debug "Home directory: ${HOME}"
debug "Current working directory: ${DIR}"
debug "Install bashrc.d directory"

if [ -L "${HOME}/.bashrc.d" ]; then
  debug "Remove old bashrc.d symbolic link"
  rm ${HOME}/.bashrc.d
fi

debug "Creating new bashrc.d symbolic link"
ln -s ${DIR}/bashrc.d ${HOME}/.bashrc.d

debug "Adding sourcing of bashrc.d directory to default bashrc file"
echo "" >> ${HOME}/.bashrc
echo "# Source set of custom bashrc files" >> ${HOME}/.bashrc
echo "source ${DIR}/bashrc.d/index.sh" >> ${HOME}/.bashrc
echo "" >> ${HOME}/.bashrc

debug "Installing gitconfig file"

if [ -L "${HOME}/.gitconfig" ]; then
  debug "Remove old gitconfig"
  rm ${HOME}/.gitconfig
fi

debug "Creation new symbolic link to gitconfig"
ln -s ${DIR}/git/gitconfig ${HOME}/.gitconfig
