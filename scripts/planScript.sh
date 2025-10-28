#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage:\n"
  printf "  planScript.sh -plan|-p <configFile.conf>  :  Generates a plan for resolving issue using llm.\n"
elif [[ $1 == "-plan" ]] || [[ $1 == "-p" ]]
then
  if [[ -f $2 ]]
  then
    #$ISSUE_FILE
    source $2
    if [[ -f $ISSUE_FILE ]]
    then
      PROMPT="Create a step-by-step plan for implementing a solution for the following issue: \n"
      while IFS='' read -e -r LINE; do
        PROMPT+="$LINE\n"
      done < $ISSUE_FILE
      printf "%s\n" "$PROMPT"
      RESPONSE=$($G_SCRIPT $G_TAG $G_LLM_CONF $G_MODEL_CONF "$PROMPT")
      printf "%s\n" "$RESPONSE"
    else
      printf "Issue file not found.\n"
    fi
  else
    printf "Config file not found.\n"
  fi
fi
