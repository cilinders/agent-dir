#!/bin/bash

if [ $# == 2 ]
then
  DATA_SOURCE=$1
  if [ -f $DATA_SOURCE ]
  then
    IFS=$'\n' read -d '' -r -a LINES < $DATA_SOURCE
    printf "%s\n" "${LINES[$2]}"
  else
    echo "No dummy data given/file does not exist."
  fi
fi
