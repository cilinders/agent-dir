#!/bin/bash

if [ $# == 0 ] || [ $# -gt 5 ] || [ $1 == "-h" ] || [ $1 == "-help" ]
then
  printf "Usage: \n"
  printf "  ollamaScript -prompt|-p <configFile.conf> <modelConfig.conf>:      Writes a given message to llm using the configFile.\n"
  printf "  ollamaScript -promptFile|-pf <configFile.conf> <modelConfig.conf>\n"
  printf "                                       <promptFile.file>:            Writes a given message from file to llm using the configFile.\n"
  printf "  ollamaScript -promptName|-pn <configFile.conf>:                    Writes a given message to given llm using the configFile.\n"
  printf "  ollamaScript -start|-s:                                            Starts ollama service.\n"
  printf "  ollamaScript -serve|-se:                                           Starts ollama service with info in current shell.\n"
  printf "  ollamaScript -stop|-st:                                            Stops ollama service.\n"
elif [ $1 == "-promptFile" ] || [ $1 == "-pf" ]
then
  RUNNING=$(pgrep ollama)
  if [[ $RUNNING != "" ]]
  then
    if [[ -f $2 ]] || [[ -f $3 ]] || [[ -f $4 ]]
    then
      source $2
      source $3
      PROMPT=""
      while IFS='' read -e -r line; do
#        printf "%s\n" "$line"
        PROMPT+="$line\n"
      done < "$4"
      PROMPT=$(echo "$PROMPT" | tr -d '\r')
      PROMPT=${PROMPT//\\/\\\\}
      PROMPT=${PROMPT//'"'/'\"'}
      SYSTEM=${SYSTEM//\\/\\\\}
      SYSYEM=${SYSTEM//'"'/'\"'}
#      printf "sending %s\n" "$PROMPT"
      RESPONSE=$(curl -sS -d '{"stream":false,"model":"'$OLLAMA_MODEL'","temperature":"'"$TEMPERATURE"'","system":"'"$SYSTEM"'","PROMPT":"'"$PROMPT"'"}' \
                    -X POST http://localhost:11434/api/generate | jq -r '.response')
      printf '%s\n' "$RESPONSE"
    else
      printf "ConfigFile not found.\n"
    fi
  else
    printf "Ollama service is not running.\n Use -s to start service.\n"
  fi
elif [ $1 == "-prompt" ] || [ $1 == "-p" ]
then
  RUNNING=$(pgrep ollama)
  if [[ $RUNNING != "" ]]
  then
    if [[ -f $2 ]] || [[ -f $3 ]]
    then
      source $2
      source $3
      read -e -rp "Prompt: " PROMPT
      PROMPT=${PROMPT//\\/\\\\}
      PROMPT=${PROMPT//'"'/'\"'}
      SYSTEM=${SYSTEM//\\/\\\\}
      SYSYEM=${SYSTEM//'"'/'\"'}
      printf 'sending %s\n' "${PROMPT@Q}"
      RESPONSE=$(curl -sS -d '{"stream":false,"model":"'$OLLAMA_MODEL'","temperature":"'"$TEMPERATURE"'","system":"'"$SYSTEM"'","PROMPT":"'"$PROMPT"'"}' \
                    -X POST http://localhost:11434/api/generate | jq -r '.response')
      printf '%s\n' "$RESPONSE"
    else
      printf "ConfigFile not found.\n"
    fi
  else
    printf "Ollama service is not running.\n Use -s to start service.\n"
  fi
elif [ $1 == "-promptName" ] || [ $1 == "-pn" ]
then
  RUNNING=$(pgrep ollama)
  if [[ $RUNNING != "" ]]
  then
    if [ -f $3 ]
    then
      source $3
      read -rp "Prompt: " PROMPT
      PROMPT=${PROMPT//\\/\\\\}
      PROMPT=${PROMPT//'"'/'\"'}
      printf 'sending %s\n' "${PROMPT@Q}"
      RESPONSE=$(curl -sS -d '{"stream":false,"model":"'$2'","PROMPT":"'"$PROMPT"'"}' \
                    -X POST http://localhost:11434/api/generate | jq -r '.response')
      printf '%s\n' "$RESPONSE"
    else
      printf "ConfigFile not found."
    fi
  else
    printf "Ollama service is not running.\n Use -s to start service.\n"
  fi
elif [ $1 == "-start" ] || [ $1 == "-s" ]
then
  ollama serve &>/dev/null &
  printf "Started\n"
elif [ $1 == "-serve" ] || [ $1 == "-se" ]
then
  ollama serve
elif [ $1 == "-stop" ] || [ $1 == "-st" ]
then
  sudo kill $(pgrep ollama)
fi
