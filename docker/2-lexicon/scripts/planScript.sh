#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage:\n"
  printf "  planScript.sh -plan|-p <configFile.conf>      :  Generates a plan for resolving issue using llm.\n"
  printf "  planScript.sh -testPlan|-tp <configFile.conf> :  Test the plan stated in plan file using llm.\n"
elif [[ $1 == "-plan" ]] || [[ $1 == "-p" ]]
then
  if [[ -f $2 ]]
  then
    #$ISSUE_FILE
    source $2
    if [[ -f $ISSUE_FILE ]]
    then
      PROMPT=""
      while IFS='' read -e -r LINE; do
        PROMPT+="$LINE\n"
      done < $ISSUE_FILE
      printf "%s\n" "$PROMPT"
      RESPONSE=$($G_SCRIPT $G_TAG $G_LLM_CONF $G_MODEL_CONF "Issue: $PROMPT\nReturn the coding tasks WITHOUT additional commentary.")
      printf "%s\n" "$RESPONSE"
      printf "" > $PLAN_FILE
      IFS=$'\n'
      for LINE in ${RESPONSE[@]}; do
        printf "%s\n" "$LINE" >> $PLAN_FILE
      done
    else
      printf "Issue file not found.\n"
    fi
  else
    printf "Config file not found.\n"
  fi
elif [[ $1 == "-testPlan" ]] || [[ $1 == "-tp" ]]
then
  if [[ -f $2 ]]
  then
    source $2
    #TODO: before: divide into smaller problems to solve
    #TODO: instead: feed into commit script....
    if [[ -f $PLAN_FILE ]]
    then
      printf "" > $TEMP_RESOLVED_FILE
      printf "" > $MESSAGE_HISTORY
      IFS=$'\n' read -d '' -r -a LINES < $PLAN_FILE
      for LINE in "${LINES[@]}"; do
        printf "TASK:\n %s\n" "$LINE" >> $TEMP_RESOLVED_FILE
        RESPONSE=$($G_SCRIPT $G_TAG $G_LLM_CONF $G_MODEL_CONF "$LINE")
        printf "SOLUTION:\n %s\n" "$RESPONSE" >> $TEMP_RESOLVED_FILE
      done
    else
      printf "Plan file not found.\n"
    fi
  else
    printf "Config file not found.\n"
  fi
fi
