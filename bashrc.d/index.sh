#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
ME=`basename "$0"`

if [ -n "$ZSH_VERSION" ]; then
  DIR="$(dirname "$(readlink -f "$0")")"
  ME=`basename "$0"`
  echo "Using zsh ${ZSH_VERSION}"
elif [ -n "$BASH_VERSION" ]; then
  DIR="$(dirname "${BASH_SOURCE[0]}")"
  ME="$(basename "${BASH_SOURCE[0]}")"
  echo "Using bash ${BASH_VERSION}"
fi

function sourceDirectory {
  for f in ${1}/*; do
    fname="$( basename $f)"
    if [ "$fname" != "$ME" ]
    then
      if [ -d "$f" ]
      then
        sourceDirectory $f
      else
        source ${f}
      fi
    fi
  done
}

sourceDirectory $DIR
