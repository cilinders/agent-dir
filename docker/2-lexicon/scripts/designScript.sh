#!/bin/bash

if [[ $# == 0 ]] || [[ $# -gt 4 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  designScript.sh -p <configFile.conf>:                  Generates a designFile from a given prompt.\n"
  printf "  designScript.sh -f <configFile.conf> <promptFile.txt>: Generates a designFile from a given promptfile.\n"
elif [[ $1 == "-p" ]]
then
  if [[ -f $2 ]]
  then
    #TODO: source llmscript, tag, llmconfig, modelconfig, designfile
    source $2
    if [[ -f $DESIGN_FILE ]]
    then
      read -rp "Prompt: " PROMPT
      PROMPT=${PROMPT//\\/\\\\}
      PROMPT=${PROMPT//'"'/'\"'}
      printf "sending: %s\n" "$PROMPT"
      RESPONSE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF "$PROMPT") # > $DESIGN_FILE
      printf "%s\n" "$RESPONSE"
      printf "%s\n" "$RESPONES" > $DESIGN_FILE
      #for \r to \n
      sed 's/\r$//' $DESIGN_FILE > $DESIGN_FILE
      #./ollamaScript.sh -pv conf/ollamaConfig.conf model/conf/designFormat.conf "Mayonaise spoonfulls eaten application"
    else
      printf "DesignFile not found.\n"
    fi
  else
    printf "ConfigFile not found.\n"
  fi
elif [[ $1 == "-f" ]]
then
  if [[ -f $2 ]]
  then
    if [[ -f $3 ]]
    then
      source $2
      PROMPT=""
      while IFS='' read -e -r line; do
        PROMPT+="$line\n"
      done < "$3"
      PROMPT=$(echo "$PROMPT" | tr -d '\r')
      PROMPT=${PROMPT//\\/\\\\}
      PROMPT=${PROMPT//'"'/'\"'}
      printf "sending: %s\n" "$PROMPT"
      $G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF "$PROMPT" > $DESIGN_FILE
    else
      printf "PromptFile not found.\n"
    fi
  else
    printf "ConfigFile not found.\n"
  fi
fi
