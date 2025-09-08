#!/bin/bash

#TODO: rewrite the scripts to just do 1 thing: 1 in 1 out. let agentScript run forever or something.

if [ $# == 0 ] | [ $# -gt 1 ]
then
  echo "Usage: "
  echo "  agentScript <configfile.conf> : Awakes the agent according to the config."
else
  if [ -f $1 ]
  then
  LOGFILE="logs/$(ls logs)"
    if [ -f $LOGFILE ]
    then
      source $1
      while true
      do
        ./respnd $? | tee -a $LOGFILE
        ./$CHATSCRIPT $CHATPARAMS $? | tee -a $LOGFILE
        sleep 1
      done
    else
      echo "Log file not found"
    fi
  else
    echo "Config file not found"
  fi
fi
