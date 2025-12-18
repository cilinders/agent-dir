#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]; then
  printf "Usage:\n"
  printf "  mistralScript -p <config.conf> <modelConfig.conf>   : Prompt mistral llm.\n"
  printf "  mistralScript -se [-l num_ntx]                      : Serves mistral llm using ollama.\n"
elif [[ $1 == "-p" ]]; then
  if [[ -f $2 ]]; then # && [[ -f $3 ]]; then
    source $2
    read -e -rp "Prompt: " PROMPT
    PROMPT=${PROMPT//\\/\\\\}
    PROMPT=${PROMPT//'"'/'\"'}
    printf "sending %s\n" "${PROMPT@Q}"
    RESPONSE=$(curl http://localhost:11434/v1/chat/completions \
                       -X POST \
                       -d '{"messages":[{"role":"user","content":"'"$PROMPT"'"}],"model":"'"$MODEL"'"}' \
              )
    printf "%s\n" "$RESPONSE"
  else
    printf "Config or model file not found.\n"
  fi
elif [[ $1 == "-pr" ]]; then
  if [[ -f $2 ]]; then #&& [[ -f $3 ]]; then
    source $2
    read -e -rp "Prompt: " PROMPT
    PROMPT=${PROMPT//\\/\\\\}
    PROMPT=${PROMPT//'"'/'\"'}
    printf "sending %s\n" "${PROMPT@Q}"
    RESPONSE=$(curl https://api.mistral.ai/v1/chat/completions \
                -X POST \
                -H "Content-Type: application/json" \
                -H "Accept: application/json" \
                -H "Authorization: Bearer $KEY" \
                -d '{"messages":[{"role":"user","content":"'"$PROMPT"'"}],"model":"devstral-latest"}' | jq -r '.choices[0] .message .content')
    printf "%s\n" "$RESPONSE"
  else
    printf "Config or model file not found.\n"
  fi
elif [[ $1 == "-se" ]] || [[ $1 == "-serve" ]]; then
  if [[ $2 == "-l" ]]; then
    if [[ $# == 3 ]]; then
      OLLAMA_CONTEXT_LENGTH=$3
      printf "%s\n" "$OLLAMA_CONTEXT_LENGTH"
      OLLAMA_CONTEXT_LENGTH=$3 ollama serve
    else
      OLLAMA_CONTEXT_LENGTH=32768
      printf "%s\n" "$OLLAMA_CONTEXT_LENGTH"
      OLLAMA_CONTEXT_LENGTH=32768 ollama serve
    fi
  else
    ollama serve
  fi
elif [[ $1 == "-st" ]] || [[ $1 == "-stop" ]]; then
  sudo systemctl disable ollama.service
  sudo systemctl disable ollama
  sudo systemctl stop ollama.service
  sudo systemctl stop ollama
  sudo pkill ollama.service
  sudo pkill ollama
  printf "%s\n" "$(sudo systemctl status ollama.service -n 0)"
  printf "%s\n" "$(sudo systemctl status ollama -n 0)"
else
  printf "Something went wrong.\n   Type -h|-help for help.\n"
fi
