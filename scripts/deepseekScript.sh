#!/bin/bash

if [ $# == 0 ] || [ $# -gt 2 ]
then
  printf "Usage:\n"
  printf "  deepseekScript config.conf message: sends querry to deepseek.\n"
else
  if [ -f $1 ] 
  then
    source $1
    if [ -f $KEY_PATH ]
    then
      KEY=$(cat $KEY_PATH)
      curl https://api.deepseek.com/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $KEY" \
        -d '{
               "model": "deepseek-chat",
               "messages": [
                  {"role": "system", "content": "You are a helpful assistant."},
                  {"role": "system", "content": "Hello!, this message is send from inside a Bash script"}
                ],
                "stream": false
            }'
    else
      printf "Key file not found.\n"
    fi
  else
    printf "Config file not found.\n"
  fi
fi
