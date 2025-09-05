#!/bin/bash

if [ $# == 1 ]
then
  LOGFILE="logs/$(ls logs)"
  echo "$LOGFILE"
  if [ -f $LOGFILE ]
  then
    echo "file found"
    $1 | tee -a $LOGFILE
  else
    echo "file not found"
  fi
fi
