#!/bin/bash

if [ $# == 0 ] || [ $# -gt 3 ] || [ $1 == "-h" ] || [ $1 == "-help" ]
then
  printf "Usage: \n"
  printf "  ollamaScript -prompt|-p <configFile.conf> <message>: Writes a given message to llm using the configFile.\n"
  printf "  ollamaScript -start|-s:                                     Starts ollama service.\n"
  printf "  ollamaScript -stop|-st:                                    Stops ollama service.\n"
elif [ $1 == "-prompt" ] || [ $1 == "-p" ]
then
  RUNNING=$(pgrep ollama)
  if [[ $RUNNING != "" ]]
  then
    if [ -f $2 ]
    then
      #TODO: fix special chars
      source $2
      RESPONSE=$(curl -sS -d '{"stream":false,"model":"'$OLLAMA_MODEL'","PROMPT":"'"$3"'"}' \
                   -X POST http://localhost:11434/api/generate | jq -r '.response')
      printf "$RESPONSE\n"
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
elif [ $1 == "-stop" ] || [ $1 == "-st" ]
then
  sudo kill $(pgrep ollama)
fi
