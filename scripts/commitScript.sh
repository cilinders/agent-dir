#!/bin/bash

if [[ $# == 0 ]] || [[ $# -gt 4 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  commitScript -gi <configFile.conf> <issueFile.txt>:  Generates commit from issuefile using llm.\n"
  printf "  commitScript -fs <configFile.conf>:                  Formats structure for use with actionScript from commitFile.\n"
elif [[ $1 == "-gi" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    source $2
    $G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $3 > $TEMP_COMMIT_FILE
  else
    printf "ConfigFile or issueFile not found.\n"
  fi
elif [[ $1 == "-fs" ]]
then
  if [[ -f $2 ]]
  then
    source $2
    if [[ -f $TEMP_COMMIT_FILE ]] || [[ -f $TEMP_FORMAT_FILE ]]
      then
        STRUCTURE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $TEMP_COMMIT_FILE)
        printf "create,structure,%s\n" "$STRUCTURE" > $TEMP_FORMAT_FILE
    else
      printf "tempCommitFile or tempFormatFile not found.\n"
    fi
  else
    printf "ConfigFile not found.\n"
  fi
fi
