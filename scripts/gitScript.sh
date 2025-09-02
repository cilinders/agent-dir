#!/bin/bash

if [ $# == 0 ]
then
  echo "Usage: "
  echo "  gitScript -lazy|-lz  : commits and pushes all changes for lazy eod"
elif [ $1 == "-lazy" ] || [ $1 == "-lz" ]
then
  if [ $# == 1 ]
  then
    EOD_TIME="$(date +%Y-%m-%d--%H-%M-%S)"
    echo "commit and pushing to LAZY$EOD_TIME"
    git switch -c LAZY$EOD_TIME
    git add --all
    git commit -m "lazy commit $EOD_TIME"
    sh ./sshScript.sh -g
    git push -u origin LAZY$EOD_TIME
    echo "lazydog"
  fi
fi
