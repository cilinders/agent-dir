#!/bin/bash

if [[ $# == 0 ]]
then
  echo "Usage: "
  echo "  gitScript -lazy|-lz  : commits and pushes all changes for lazy eod\n"
elif [[ $1 == "-lazy" ]] || [[ $1 == "-lz" ]]
then
  if [[ $# == 1 ]]
  then
    EOD_TIME="$(date +%Y-%m-%d--%H-%M-%S)"
    echo "commit and pushing to LAZY$EOD_TIME"
    git switch -c LAZY$EOD_TIME
    git add --all
    git commit -m "lazy commit $EOD_TIME"
    # sets the ssh-agent with the pub key.
    # todo: does wierd stuff because script inside script with `bash -i` nested
    sh ./sshScript.sh -g
    git push -u origin LAZY$EOD_TIME
    echo "lazydog"
  fi
elif [[ $1 == "-rpush" ]]
then
  git switch -c REMOTE_EZ
  git add --all
  git commit -m "REMOTE_EZ push"
  #sh ./sshScript.sh -g
  git push -u origin REMOTE_EZ
  printf "REMOTE_EZ push\n"
elif [[ $1 == "-rpull" ]]
then
  git stash
  git pull https://github.com/cilinders/agent-dir.git REMOTE_EZ
fi
