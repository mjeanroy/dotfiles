#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ME=`basename "${BASH_SOURCE[0]}"`

for f in ${DIR}/*; do
  if [ "$( basename $f)" != "$ME" ]
  then
    source ${f}
  fi
done
