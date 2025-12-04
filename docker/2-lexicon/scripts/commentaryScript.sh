#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]; then
  printf "Usage:\n"
  printf "  commentaryScript -r <parseCommentaryConfig.conf> :  Generates new issues from commentary written in resolved coding tasks using llm.\n"
elif [[ $1 == "-r" ]]; then
  if [[ -f $2 ]]; then
    #RESOLVED_PLAN
    #G_*
    source $2
    declare -a LINE_ARRAY=()
    INDEX=0
    IFS=''
    while read LINE; do
      LINE_ARRAY[$INDEX]="$LINE"
      ((++INDEX))
      #printf "%s\n" "$LINE"
    done < $RESOLVED_PLAN
    TASK=""
    for LINE in "${LINE_ARRAY[@]}"; do
      if [[ "$LINE" =~ "TASK:" ]]; then
        if ! [[ "$TASK" == "" ]]; then
          #TODO: ask llm need action?
          printf "sending: %s\n" "$TASK"
          TASK=""
        fi
      else
        TASK+="$LINE"
      fi
    done
  else
    printf "Config file not found.\n"
  fi
fi
