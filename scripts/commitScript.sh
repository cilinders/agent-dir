#!/bin/bash

if [[ $# == 0 ]] || [[ $# -gt 4 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  commitScript -gi <configFile.conf> <issueFile.txt>:  Generates commit from issuefile using llm.\n"
  printf "  commitScript -fs <configFile.conf>:                  Formats structure for use with actionScript from commitFile.\n"
  printf "  commitScript -fc <configFile.conf>:                  placeholder.\n"
elif [[ $1 == "-gi" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    source $2
    $G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $3 > $TEMP_COMMIT_FILE
  else
    printf "ConfigFile or issueFile not found.\n"
  fi
elif [[ $1 == "-fs" ]]
then
  if [[ -f $2 ]]
  then
    source $2
    if [[ -f $TEMP_COMMIT_FILE ]] || [[ -f $TEMP_FORMAT_FILE ]]
    then
      #TODO: nu is het bruikbaar met fileStructure.conf(naam moet nog goed) maar modelconfig moet beter
      #TODO: ./commitScript.sh -fs conf/fileStructure.conf
      STRUCTURE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $TEMP_COMMIT_FILE)
      STRUCTURE=$(echo "$STRUCTURE" | tr -d '\r')
      STRUCTURE=$(echo "$STRUCTURE" | tr -d '\t')
      STRUCTURE=$(echo "$STRUCTURE" | tr -d '\n')
#      printf "create,structure,%s\n" "$STRUCTURE"
      printf "create,structure,%s\n" "$STRUCTURE" > $TEMP_FORMAT_FILE
    else
      printf "tempCommitFile or tempFormatFile not found.\n"
    fi
  else
    printf "ConfigFile not found.\n"
  fi
#TODO: :)))) werkt in eerste tests
elif [[ $1 == "-fp" ]]
then
  if [[ -f $2 ]]
  then
    source $2
    if [[ -f $TEMP_COMMIT_FILE ]] || [[ -f $TEMP_FORMAT_FILE ]]
    then
      touch temp_STRUCT.txt
      printf "Find the codeblock for the following file: %s\n\n" "$3" > temp_STRUCT.txt
      IFS=$'\n' read -d '' -r -a LINES < $TEMP_COMMIT_FILE
      for LINE in "${LINES[@]}"; do
        printf "%s\n" "$LINE" >> temp_STRUCT.txt
      done
      STRUCTURE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF temp_STRUCT.txt)
      printf "%s\n" "$STRUCTURE"
    fi
  fi
elif [[ $1 == "-fc" ]]
then
  if [[ -f $2 ]]
  then
    source $2
    if [[ -f $TEMP_COMMIT_FILE ]] || [[ -f $TEMP_FORMAT_FILE ]]
    then
      STRUCTURE=$($G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $TEMP_COMMIT_FILE)
      printf "%s\n" "$STRUCTURE"
      STRUCTURE=${STRUCTURE//'```json'/''}
      STRUCTURE=${STRUCTURE//'```'/''}
      STRUCTURE1=$(printf "%s" "$STRUCTURE" | awk -F 'file_path": "' '{print $1}')
      STRUCTURE2=$(printf "%s" "$STRUCTURE" | awk -F 'file_path": "' '{print $2}')
      STRUCTURE3=$(printf "%s" "$STRUCTURE2" | awk -F '",' '{print $1}')
      STRUCTURE4=$(printf "%s" "$STRUCTURE" | awk -F 'code": "' '{print $2}')
      STRUCTURE5=$(printf "%s" "$STRUCTURE4" | awk -F '"\r}' '{print $1}')
      printf "%s\n" "$STRUCTURE5" > $TEMP_FORMAT_FILE
      printf "%s\n" "$STRUCTURE3" >> $TEMP_FORMAT_FILE
      FORMAT_STRING=""
      touch temp_format_file.txt
      while IFS= read -r line; do
        if [[ "$line" != "" ]]
        then
          printf "%s\r" "$line" >> temp_format_file.txt
        fi
      done < $TEMP_FORMAT_FILE
      mv temp_format_file.txt $TEMP_FORMAT_FILE
      IFS=$'\r' read -d '' -r -a file_array < $TEMP_FORMAT_FILE
      printf "len %s\n" "${#file_array[@]}"
      MAX=$((${#file_array[@]}/2))
      printf "max %s\n" "$MAX"
      for ((i = 0; i < $MAX; i++)); do
        printf "%s\n" "${file_array[$i]}"
        DOUBLE=$(($MAX + $i))
        printf "%s\n" "${file_array[$DOUBLE]}"
      done
    else
      printf "tempCommitFile or tempFormatFile not found.\n"
    fi
  fi
fi
