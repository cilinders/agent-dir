#!/bin/bash

if [[ $# == 0 ]] || [[ $# -gt 4 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  issueScript -g <configFile.conf> <designFile.txt>:     Generates issues from a given designFile using llm.\n"
  printf "  issueScript -gi <configFile.conf> <promptFile.txt>:    Generates issue from a given promptfile using llm.\n"
  printf "  issueScript -fo <configFile.conf> <openIssueFile.txt>: Isolates a issue from the issueFile for use with llm.\n"
  printf "  issueScript -fi <configFile.conf> <rawIssueFile.txt>:  Formats a raw issue file into a issueFile.\n"
elif [[ $1 == "-g" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    #TODO: printf to file loses identation, look @ ?plannerScript? for implementation
    source $2
    RESPONSE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $3) # > $RAW_ISSUE_FILE
    #printf "%s\n" "${RESPONSE@Q}"
    printf "%s\n" "$RESPONSE" > $RAW_ISSUE_FILE
    #IFS=$'\n'
    #for LINE in ${RESPONSE[@]}; do
    #  printf "%s\n" "$LINE" >> $RAW_ISSUE_FILE
    #done
  else
    printf "ConfigFile or designFile not found.\n"
  fi
elif [[ $1 == "-gi" ]]; then
  if [[ -f $2 ]] || [[ -f $3 ]]; then
    source $2
    RESPONSE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $3)
    touch $TEMP_ISSUE_FILE
    #printf "%s\n" "$RESPONSE"
    printf "" > $TEMP_ISSUE_FILE
    IFS=$'\n'
    for LINE in ${RESPONSE[@]}; do
      printf "%s\n" "$LINE"
      printf "%s\n" "$LINE" >> $TEMP_ISSUE_FILE
    done
    #TODO: before remove format and cat the issue to the global issue list
    #rm $TEMP_ISSUE_FILE
  else
    printf "Config or prompt file not found.\n"
  fi
elif [[ $1 == "-fo" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    source $2
    printf "stripping issue from $ISSUE_FILE.\n"
    IFS=$'\n' read -d '' -r -a LINES < $ISSUE_FILE
    printf "%s\n" "${LINES[0]}" > $3
    printf "" > tempIssueFile.txt
    for ((i = 1; i < ${#LINES[@]}; ++i))
    do
      printf "%s\n" "${LINES[$i]}" >> tempIssueFile.txt
    done
    mv tempIssueFile.txt $ISSUE_FILE
  else
    printf "ConfigFile or issueFile not found.\n"
  fi
elif [[ $1 == "-fi" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    source $2
    IFS=$'\n' read -d '' -r -a LINES < $3
    declare -a ISSUE_LINES=()
    #for LINE in "${LINES[@]}"
    #do
    #  if [[ "$LINE" =~ "*" ]]
    #  then
    #    ISSUE_LINES+=("$LINE")
    #  fi
    #done
    START=false
    INDEX=0
    #for LINE in "${LINES[@]}"; do
    #  if [[ "$LINE" =~ "*1" ]] && [[ "$START" == "false" ]]; then
    #    START=true
    #    ISSUE_LINES=()
    #  fi
    #  ISSUE_LINES+=("$LINE")
    #done
    while read LINE; do
      if [[ "$LINE" =~ "1" ]] && [[ "$START" == "false" ]]; then
        START=true
        ISSUE_LINES=()
        INDEX=0
      fi
      ISSUE_LINES[$INDEX]="$LINE"
      ((++INDEX))
    done < $3
    declare -a ISSUES=()
    COUNT=0
    ISSUE=""
    printf "" > $ISSUE_FILE
    for ((i = 0; i < ${#ISSUE_LINES[@]}; ++i))
    do
      ((++COUNT))
      ISSUE_TEMP="${ISSUE_LINES[$i]}"
      ISSUE+="${ISSUE_TEMP//$'\n'/}"
      #i_TEMP=$(($i+1))
      #i_TEMP=$(($i_TEMP%4))
      #if [[ $i_TEMP == 0 ]]
      if [[ "${ISSUE_LINES[$i]}" == "" ]]
      then
        COUNT=0
        ISSUE+=";"
        printf "%s\n" "$ISSUE" >> $ISSUE_FILE
        ISSUE=""
      else
        ISSUE+=","
      fi
    done
    #HACKY: add last issue which gets cut off now
    if ! [[ $COUNT -lt 2 ]]; then
      ISSUE+=";"
      printf "%s\n" "$ISSUE" >> $ISSUE_FILE
    fi
  else
    printf "Configfile or rawIssueFile not found.\n"
  fi
fi
