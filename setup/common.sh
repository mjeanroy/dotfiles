#!/bin/bash

##
# Display information message.
##
function info {
  echo -e "\e[1m[info] $1\e[0m"
  echo
}

##
# Display information message.
##
function debug {
  echo -e "\e[37m[debug] $1\e[0m"
  echo
}
