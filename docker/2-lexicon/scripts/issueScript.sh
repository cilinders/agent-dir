#!/bin/bash

if [[ $# == 0 ]] || [[ $# -gt 4 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  issueScript -g <configFile.conf> <designFile.txt>:     Generates issues from a given designFile using llm.\n"
  printf "  issueScript -fo <configFile.conf> <openIssueFile.txt>: Isolates a issue from the issueFile for use with llm.\n"
  printf "  issueScript -fi <configFile.conf> <rawIssueFile.txt>:  Formats a raw issue file into a issueFile.\n"
elif [[ $1 == "-g" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    #TODO: HANDLE designfile being read!!
    #TODO: splitting into 1 line does not work
    #TODO: removing \r doesnt work
    source $2
    $G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $3 > $RAW_ISSUE_FILE
  else
    printf "ConfigFile or designFile not found.\n"
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
    declare -a ISSUE_LINES=()
    INDEX=0
    IFS=''
    while read LINE; do
      ISSUE_LINES[$INDEX]="$LINE"
      ((++INDEX))
    done < $3
    #INDEX=0
    #for LINE in "${ISSUE_LINES[@]}"; do
    #  printf "%s: %s" "$INDEX" "$LINE"
    #  if [[ "$LINE" == "" ]]; then
    #    printf "yup"
    #  else
    #    printf "nope"
    #  fi
    #  printf "\n"
    #  ((++INDEX))
    #done
    INDEX=0
#    for LINE in "${ISSUE_LINES[@]}"; do
#      ((++INDEX))
#      if [[ "$LINE" == "" ]]; then
#        break
#      fi
#    done
    ISSUE=""
    printf "" > $ISSUE_FILE
    COUNT=0
    for ((i = $INDEX; i < ${#ISSUE_LINES[@]}; ++i)); do
      ((++COUNT))
      ISSUE_TEMP="${ISSUE_LINES[$i]}"
      ISSUE+="${ISSUE_TEMP//$'\n'/}"
      if [[ "${ISSUE_LINES[$i]}" == "" ]]; then
        if [[ "$COUNT" -gt 2 ]]; then
          ISSUE+=";"
          printf "%s\n" "$ISSUE" >> $ISSUE_FILE
        fi
        COUNT=0
        ISSUE=""
      else
        ISSUE+="\n"
      fi
    done
  else
    printf "Configfile or rawIssueFile not found.\n"
  fi
fi
