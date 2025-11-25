#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  projectScript.sh -id|-initDir <configFile>  :  Setup for project directory config file using llm.\n"
elif [[ $1 == "-id" ]] || [[ $1 == "-initDir" ]]
then
  if [[ -f $2 ]]
  then
    #PROJECT_CONFIG
    #G_SCRIPT G_SCRIPT_TAG G_LLM_CONF G_MODEL_CONF
    #DESIGN_PROMPT_FILE
    #DESIGN_FILE
    source $2
    DESIGN_PROMPT=""
    while IFS='' read -e -r line; do
      DESIGN_PROMPT+="$line\n"
    done < "$DESIGN_PROMPT_FILE"
    #printf "%s\n" "$DESIGN_PROMPT"
    DESIGN_TEXT=""
    while IFS='' read -e -r line; do
      DESIGN_TEXT+="$line\n"
    done < "$DESIGN_FILE"
    #printf "%s\n" "$DESIGN_TEXT"
    PROMPT='[{"role":"user","content":"$DESIGN_PROMPT"},{"role":"user","content":"$DESIGN_TEXT"},{"role":"user","content":"Create an appropriate name for the software product, return the name WITHOUT additional commentary."}]'
    RESPONSE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF "$PROMPT")
    RESPONSE=${RESPONSE//' '/'_'}
    RESPONSE=$(echo "$RESPONSE" | tr '[:upper:]' '[:lower:]')
    printf "%s\n" "$RESPONSE"
    printf 'PROJECT_DIR="%s/src"\n' "$RESPONSE"
    printf 'PROJECT_DIR="%s/src"\n' "$RESPONSE" >> $PROJECT_CONFIG
  else
    printf "Config file not found.\n"
  fi
fi
