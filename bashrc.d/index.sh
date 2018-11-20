#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ME=`basename "${BASH_SOURCE[0]}"`

function sourceDirectory {
  for f in ${1}/*; do
    if [ "$( basename $f)" != "$ME" ]
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
