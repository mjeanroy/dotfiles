#!/bin/bash

dir="$( cd "$( dirname "$0" )" && pwd )"

echo "source $dir/.aliases" >> ~/.bashrc
echo "source $dir/.prompt"  >> ~/.bashrc
