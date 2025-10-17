#!/bin/bash

if [[ $# == 0 ]] || [[ $# -gt 4 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  commitScript -gi <configFile.conf> <issueFile.txt>   :  Generates commit from issuefile using llm.\n"
  printf "  commitScript -fs <configFile.conf>                   :  Formats structure for use with actionScript from commitFile.\n"
  printf "  commitScript -fp <configFile.txt> <file_path>        :  Returns files codeblock from commit using llm.\n"
  printf "  commitScript -fpa <configFile.txt> <validated_struct>:  Formats all codeblocks from commit for use actionScript.\n"
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
      #TODO: namespace bad
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
elif [[ $1 == "-fpa" ]]
then
  if [[ -f $2 ]]
  then
    source $2
    #TODO: get all file_paths from somewhere
    #FILE_PATHS=$(./commitScript.sh -fs $FS_CONF)
    # should have made temp_structure.txt=$TEMP_FORMAT_FILE
    IFS='' read -d '' -r STRUCTURE < $TEMP_FORMAT_FILE
    printf "%s\n" "$STRUCTURE"
  else
    printf "Config file not found.\n"
  fi
fi
