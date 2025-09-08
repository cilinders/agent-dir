#!/bin/bash

#TODO: rewrite the scripts to just do 1 thing: 1 in 1 out. let agentScript run forever or something.

if [ $# == 0 ] | [ $# -gt 1 ]
then
  echo "Usage: "
  echo "  agentScript <configfile.conf> : Awakes the agent according to the config."
else
  if [ -f $1 ]
  then
    source $1
    while true
    do
      ./respnd $?
      ./$CHATSCRIPT $CHATPARAMS $?
      sleep 1
    done
  else
    echo "Config file not found"
  fi
fi
