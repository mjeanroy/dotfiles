#!/bin/bash

HOME="$( cd ~ && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ME=`basename "${BASH_SOURCE[0]}"`

for f in ${DIR}/*; do
  fname="$( basename $f)"
  if [ "${fname}" != "$ME" ]
  then
    if [ -L "${HOME}/.${fname}" ]; then
      echo "[debug] Removing symbolic link: ${HOME}/.${fname}"
      rm ${HOME}/.${fname}
    fi

    echo "[debug] Creating new symbolic link: ${f} --> ${HOME}/.${fname}"
    ln -s $f ${HOME}/.${fname}
  fi
done
