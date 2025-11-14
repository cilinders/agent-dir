#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]]
then
  printf "Usage: \n"
  printf "  contextScript -c <configFile>            :  Creates a context file for llm message content.\n"
  printf "  contextScript -C <configFile> <message>  :  Creates a context file with message for llm message content.\n"
elif [[ $1 == "-c" ]]
then
  if [[ -f $2 ]]
  then
    #PROJECT_DIR
    #CONTEXT_FILE
    source $2
    declare -a PROJECT_PATHS_RAW=()
    declare -a PROJECT_FILES=()
    PROJECT_PATHS_RAW+=($(ls -R $PROJECT_DIR))
    DIR_PATH=""
    for LINE in ${PROJECT_PATHS_RAW[@]}; do
      if [[ "$LINE" =~ ":" ]]
      then
        DIR_PATH="$LINE"
        DIR_PATH=${LINE//':'/'/'}
        DIR_PATH=${DIR_PATH//'//'/'/'}
      elif [[ "$LINE" =~ "." ]]
      then
        PROJECT_FILES+=("$DIR_PATH$LINE")
      fi
    done
    touch $CONTEXT_FILE
    printf "" > $CONTEXT_FILE
    for ((i=0; i<${#PROJECT_FILES[@]}; ++i)); do
      printf '{"role":"user","content":"``` // '"${PROJECT_FILES[$i]}"'\\n' >> $CONTEXT_FILE
      IFS=$'\n'
      FILE_LINES=$(cat "${PROJECT_FILES[$i]}")
      for LINE in ${FILE_LINES[@]}; do
        printf '%s\\n' "$LINE" >> $CONTEXT_FILE
      done
      printf '```"}' >> $CONTEXT_FILE
      if [[ "$i" -lt "${#PROJECT_FILES[@]}-1" ]]
      then
        printf ',' >> $CONTEXT_FILE
      fi
    done
    printf "%s\n" "$(cat $CONTEXT_FILE)"
  else
    printf "Config file not found.\n"
  fi
elif [[ $1 == "-C" ]]
then
  if [[ -f $2 ]]
  then
    #PROJECT_DIR
    #CONTEXT_FILE
    source $2
    declare -a PROJECT_PATHS_RAW=()
    declare -a PROJECT_FILES=()
    PROJECT_PATHS_RAW+=($(ls -R $PROJECT_DIR))
    DIR_PATH=""
    for LINE in ${PROJECT_PATHS_RAW[@]}; do
      if [[ "$LINE" =~ ":" ]]
      then
        DIR_PATH="$LINE"
        DIR_PATH=${LINE//':'/'/'}
        DIR_PATH=${DIR_PATH//'//'/'/'}
      elif [[ "$LINE" =~ "." ]]
      then
        PROJECT_FILES+=("$DIR_PATH$LINE")
      fi
    done
    touch $CONTEXT_FILE
    printf "" > $CONTEXT_FILE
    for ((i=0; i<${#PROJECT_FILES[@]}; ++i)); do
      printf '{"role":"user","content":"``` // '"${PROJECT_FILES[$i]}"'\\n' >> $CONTEXT_FILE
      IFS=$'\n'
      FILE_LINES=$(cat "${PROJECT_FILES[$i]}")
      for LINE in ${FILE_LINES[@]}; do
        printf '%s\\n' "$LINE" >> $CONTEXT_FILE
      done
      printf '```"}' >> $CONTEXT_FILE
      if [[ "$i" -lt "${#PROJECT_FILES[@]}-1" ]]
      then
        printf ',' >> $CONTEXT_FILE
      fi
    done
    printf ',{"role":"user","content":"'"$3"'"}' >> $CONTEXT_FILE
    printf "%s\n" "$(cat $CONTEXT_FILE)"
  else
    printf "Config file not found.\n"
  fi
fi
