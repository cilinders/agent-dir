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
    #touch ../data/test_commentary.txt
    #printf "" > ../data/test_commentary.txt
    for LINE in "${LINE_ARRAY[@]}"; do
      if [[ "$LINE" =~ "TASK:" ]]; then
        if ! [[ "$TASK" == "" ]]; then
          #TODO: ask llm need action?
          printf "%s\n\n" "$TASK"
          printf "%s\n\n" "$TASK" > ../data/test_commentary.txt
          RESPONSE=$($G_SCRIPT $G_SCRIPT_TAG $G_MODEL_CONF ../data/test_commentary.txt)
          #TODO: print llm issue generation to the issues file.
          TASK=""
        fi
      else
        TASK+="$LINE\n"
      fi
    done
  else
    printf "Config file not found.\n"
  fi
fi
