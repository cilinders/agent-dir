#!/bin/bash

if [ $# == 0 ] || [ $1 == "-h" ]
then
  echo "Usage: "
  echo "  sshScript -git|-g   : Setup for ssh-agent for use with git."
elif [ $1 == "-git" ] || [ $1 == "-g" ]
then
  echo "Starting ssh-agent."
  eval $(ssh-agent -s)
  echo "Adding pub key."
  ssh-add ~/.ssh/id_ed25519-02-09-2025
  echo "Testing key."
  ssh -T git@github.com
  bash -i
fi
