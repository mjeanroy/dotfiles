#!/bin/bash

dir="$( cd "$( dirname "$0" )" && pwd )"

echo ""                      >> ~/.bashrc
echo "# Maven Configuration" >> ~/.bashrc
echo "source $dir/.mvn"      >> ~/.bashrc
