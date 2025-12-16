#!/bin/bash

if [ $# == 0 ] || [ $# -gt 5 ] || [ $1 == "-h" ] || [ $1 == "-help" ]
then
  printf "Usage: \n"
  printf "  ollamaScript -prompt|-p <configFile.conf> <modelConfig.conf>:      Writes a given message to llm using the configFile.\n"
  printf "  ollamaScript -promptFile|-pf <configFile.conf> <modelConfig.conf>\n"
  printf "                                       <promptFile.file>:            Writes a given message from file to llm using the configFile.\n"
  printf "  ollamaScript -promptVar|-pv <configFile.conf> <modelConfig>\n"
  printf "                              <prompt>                               Writes a given var message to llm using the configFile.\n"
  printf "  ollamaScript -promptVarChat|-pvc <configFile.conf> <modelConfig>\n"
  printf "                              <prompt>                               Writes a given var message to llm chat using configFile.\n"
  printf "  ollamaScript -promptName|-pn <configFile.conf>:                    Writes a given message to given llm using the configFile.\n"
  printf "  ollamaScript -start|-s:                                            Starts ollama service.\n"
  printf "  ollamaScript -serve|-se:                                           Starts ollama service with info in current shell.\n"
  printf "  ollamaScript -serveVerbose|-seb:                                   Starts ollama servive with verbose info in current shell.\n"
  printf "  ollamaScript -stop|-st:                                            Stops ollama service.\n"
  printf "  ollamaScript -dockerPull|-dP <modelName>:                          Pulls model for Docker container.\n"
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
        #printf "%s\n" "$line"
        PROMPT+="$line\n"
      done < "$4"
      PROMPT=$(echo "$PROMPT" | tr -d '\r')
      PROMPT=$(echo "$PROMPT" | tr -d '\t')
#      printf "%s\n" "$PROMPT"
      PROMPT=${PROMPT//\\/\\\\}
      PROMPT=${PROMPT//'"'/'\"'}
#      printf "%s\n" "$PROMPT"
      SYSTEM=${SYSTEM//\\/\\\\}
      SYSYEM=${SYSTEM//'"'/'\"'}
#      printf "sending %s\n" "${PROMPT@Q}"
      RESPONSE=$(curl -sS -d '{"keep_alive":0,"stream":false,"model":"'$OLLAMA_MODEL'","temperature":"'"$TEMPERATURE"'","system":"'"$SYSTEM"'","PROMPT":"'"$PROMPT"'"}' \
                    -X POST http://localhost:11434/api/generate | jq -r '.response')
      printf '%s\n' "$RESPONSE"
    else
      printf "ConfigFile not found.\n"
    fi
  else
    printf "Ollama service is not running.\n Use -s to start service.\n"
  fi
elif [[ $1 == "-promptVar" ]] || [[ $1 == "-pv" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    source $2
    source $3
    PROMPT="$4"
    PROMPT=${PROMPT//\\/\\\\}
    PROMPT=${PROMPT//'"'/'\"'}
    RESPONSE=$(curl -sS -d '{"keep_alive":0,"stream":false,"model":"'$OLLAMA_MODEL'","temperature":"'"$TEMPERATURE"'","system":"'"$SYSTEM"'","PROMPT":"'"$PROMPT"'"}' \
                  -X POST http://localhost:11434/api/generate | jq -r '.response')
    printf "%s\n" "$RESPONSE"
  else
    printf "ConfigFile or modelConfigFile not found.\n"
  fi
elif [[ $1 == "-promptVarChat" ]] || [[ $1 == "-pvc" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    #TODO: add chat history -> $MESSAGE_HISTORY -> {"role":"user","content":"blahblahblah"},{"role":"assistant":"blahblahbla"},{..}..
    source $2
    source $3
    #TODO: FORMAT better, it does some iffy stuff
      # MESSAGE is catted from random temp_test.txt instead of using a normal given history etc.
                                      #either from planscript or action/runnerscript
    PROMPT="$4"
    #PROMPT=${PROMPT//\\/\\\\}
    #PROMPT=${PROMPT//'"'/'\"'}
    if [[ "${PROMPT:0:2}" == "[{" ]]; then
      #PROMPT=${PROMPT//\\/\\\\}
      #PROMPT=${PROMPT//'"'/'\"'}
      # TODO: test print
      #printf "%s\n" "${PROMPT@Q}" > testPROMPT.txt
      RESPONSE=$(curl -sS -d '{"keep_alive":0,"stream":false,"model":"'$OLLAMA_MODEL'","temperature":'"$TEMPERATURE"',"system":"'"$SYSTEM"'","MESSAGES":'"$PROMPT"'}' -X POST http://localhost:11434/api/chat | jq -r '.message.content')
      printf "%s\n" "$RESPONSE"
    else
      #MESSAGE="$DATA_INSIDE_TEST"',{"role":"user","content":"'"$PROMPT"'"}'
      MESSAGE=$(cat ../data/temp_test.txt) # | jq -sR .)
      #printf "%s\n\n" "$MESSAGE"
      #MESSAGE=${MESSAGE//\\/\\\\}
      #MESSAGE=${MESSAGE//'"'/'\"'}
      MESSAGE="$MESSAGE"',{"role":"user","content":"'"$PROMPT"'"}]'
      #printf "%s" "$MESSAGE" > ../data/temp_test_message.txt
      #RESPONSE=$(curl -sS -d '{"stream":false,"model":"'$OLLAMA_MODEL'","temperature":'"$TEMPERATURE"',"system":"'"$SYSTEM"'","MESSAGES":['"$MESSAGE"']}' -X POST http://localhost:11434/v1/chat/completions) #| jq -r '.message.content')
      RESPONSE=$(curl -sS -d '{"keep_alive":0,"stream":false,"model":"'$OLLAMA_MODEL'","temperature":'"$TEMPERATURE"',"system":"'"$SYSTEM"'","MESSAGES":'"$MESSAGE"'}' -X POST http://localhost:11434/api/chat | jq -r '.message.content')
      printf "%s\n" "$RESPONSE"
    fi
  else
    printf "Config or model file not found.\n"
  fi
elif [[ $1 == "-prompt" ]] || [[ $1 == "-p" ]]
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
      RESPONSE=$(curl -sS -d '{"keep_alive":0,"stream":false,"model":"'$OLLAMA_MODEL'","temperature":"'"$TEMPERATURE"'","system":"'"$SYSTEM"'","PROMPT":"'"$PROMPT"'"}' \
                    -X POST http://localhost:11434/api/generate | jq -r '.response')
      printf '%s\n' "$RESPONSE"
    else
      printf "ConfigFile not found.\n"
    fi
  else
    printf "Ollama service is not running.\n Use -s to start service.\n"
  fi
elif [[ $1 == "-promptFileJson" ]] || [[ $1 == "-pfj" ]]
then
  RUNNING=$(pgrep ollama)
  if [[ $RUNNING != "" ]]
  then
    if [[ -f $3 ]]
    then
      source $2
      source $3
      PROMPT=""
      while IFS='' read -e -r line; do
        PROMPT+="$line\n"
      done < "$4"
      PROMPT=$(echo "$PROMPT" | tr -d '\r')
      PROMPT=$(echo "$PROMPT" | tr -d '\t')
      PROMPT=${PROMPT//\\/\\\\}
      PROMPT=${PROMPT//'"'/'\"'}
      SYSTEM=${SYSTEM//\\/\\\\}
      SYSTEM=${SYSTEM//'"'/'\"'}
      RESPONSE=$(curl -X POST http://localhost:11434/api/generate -H "Content-Type: application/json" -d '{' \
        '"model":"'$OLLAMA_MODEL'",' \
        '"stream":false,' \
        '"temperature":"'"$TEMPERATURE"'",' \
        '"system:"'"$SYSTEM"'",' \
        '"prompt":"'"$PROMPT"'"' \
        '"format": "json" }' | jq -r '.response')
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
      RESPONSE=$(curl -sS -d '{"keep_alive":0,"stream":false,"model":"'$2'","PROMPT":"'"$PROMPT"'"}' \
                    -X POST http://localhost:11434/api/generate | jq -r '.response')
      printf '%s\n' "$RESPONSE"
    else
      printf "ConfigFile not found.\n"
    fi
  else
    printf "Ollama service is not running.\n Use -s to start service.\n"
  fi
elif [[ $1 == "-start" ]] || [[ $1 == "-s" ]]
then
  ollama serve &>/dev/null &
  printf "Started\n"
elif [[ $1 == "-serve" ]] || [[ $1 == "-se" ]]
then
  if [[ $2 == "-l" ]]
  then
    OLLAMA_CONTEXT_LENGTH=32768 ollama serve
  else
    ollama serve
  fi
elif [[ $1 == "-serveVerbose" ]] || [[ $1 == "-seb" ]]
then
  OLLAMA_DEBUG=1 ollama serve
elif [[ $1 == "-stop" ]] || [[ $1 == "-st" ]]
then
  sudo kill $(pgrep ollama)
elif [[ $1 == "-dockerPull" ]] || [[ $1 == "-dP" ]]; then
  if [[ $3 == "-l" ]]; then
    OLLAMA_CONTEXT_LENGTH=32768 ollama serve &
  else
    ollama serve &
  fi
  ollama list
  ollama pull $2
fi
