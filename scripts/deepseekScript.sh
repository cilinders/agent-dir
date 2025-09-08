#!/bin/bash

if [ $# == 0 ] || [ $# -gt 2 ]
then
  printf "Usage:\n"
  printf "  deepseekScript config.conf message: sends querry to model API.\n"
else
  if [ -f $1 ]
  then
    source $1
    if [ -f $KEY_PATH ]
    then
      KEY=$(cat $KEY_PATH)
      RESPONSE=$(curl $API_URL \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $KEY" \
        -d '{
               "model": "'"$MODEL"'",
               "messages": [
                  {"role": "user", "content": "'"$2"'"}
                ],
                "stream": false
            }' | jq -r '.choices[0].message.content')
      printf "$RESPONSE\n"
    else
      printf "Key file not found.\n"
    fi
  else
    printf "Config file not found.\n"
  fi
fi
