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

BASHRC=${HOME}/.bashrc

if [ ! -f ${BASHRC} ]; then
  BASHRC=${HOME}/.bash_profile
fi

debug "Adding sourcing of bashrc.d directory to default bashrc file"
debug "Default bashrc is: ${BASHRC}"
echo "" >> ${BASHRC}
echo "# Source set of custom bashrc files" >> ${BASHRC}
echo "source ${DIR}/bashrc.d/index.sh" >> ${BASHRC}
echo "" >> ${BASHRC}

debug "Installing homerc file"
${DIR}/homerc/index.sh
