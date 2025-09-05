#!/bin/bash

if [ $# == 1 ]
then
  DATA_SOURCE=$1
  if [ -f $DATA_SOURCE ]
  then
    while IFS= read -r -u3 LINE
    do
      read -e -p "prompt: " PROMPT
#      printf "$PROMPT"
      printf "$LINE"
    done 3< $DATA_SOURCE
  else
    echo "No dummy data given/file does not exist."
  fi
fi
