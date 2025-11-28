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
    DESIGN_PROMPT=${DESIGN_PROMPT//\/\\}
    DESIGN_TEXT=${DESIGN_TEXT//\/\\}
    PROMPT='[{"role":"user","content":"'"$DESIGN_PROMPT"'"},{"role":"assistant","content":"'"$DESIGN_TEXT"'"},{"role":"user","content":"Create an appropriate name for the software product, return the name WITHOUT additional commentary."}]'
    #PROMPT=${PROMPT//'"'/'\"'}
    printf "%s\n" "$PROMPT"
    RESPONSE=""
    while [[ "${#RESPONSE}" -gt 25 ]] || [[ "${#RESPONSE}" == 0 ]] || [[ "$RESPONSE" == "null" ]]; do
      printf "%s\n" "${#RESPONSE}"
      RESPONSE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF "$PROMPT")
      printf "%s\n" "$RESPONSE"
      RESPONSE=${RESPONSE//' '/'_'}
      RESPONSE=$(echo "$RESPONSE" | tr '[:upper:]' '[:lower:]')
      RESPONSE=${RESPONSE//[^-a-z_]/''}
      #printf "%s\n" "$RESPONSE"
      #if ! [[ "$RESPONSE" == "null" ]]; then
        sleep 5s
      #fi
    done
    printf 'PROJECT_DIR="%s/src"\n' "$RESPONSE"
    printf 'PROJECT_DIR="%s/src"\n' "$RESPONSE" >> $PROJECT_CONFIG
    source $PROJECT_CONFIG
    printf "%s\n" "$PROJECT_DIR"
  else
    printf "Config file not found.\n"
  fi
fi
