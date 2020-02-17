#!/bin/bash

ME=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")")
DIR=$(dirname "${ME}")

if [ -n "$ZSH_VERSION" ]; then
  echo "Using zsh ${ZSH_VERSION}"
elif [ -n "$BASH_VERSION" ]; then
  echo "Using bash ${BASH_VERSION}"
fi

function sourceDirectory {
  for f in ${1}/*; do
    if [ "$f" != "$ME" ]
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
