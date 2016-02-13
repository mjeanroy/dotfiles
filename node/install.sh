#!/bin/bash

dir="$( cd "$( dirname "$0" )" && pwd )"

echo ""                       >> ~/.bashrc
echo "# NodeJS Configuration" >> ~/.bashrc
echo "source $dir/.node"      >> ~/.bashrc
