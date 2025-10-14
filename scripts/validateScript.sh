#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage:\n"
  printf "  validateScript -vdd <configFile.conf> <designDocument.txt> : validates design document using llm.\n"
  printf "  validateScript -vi <configFile.conf> <issueFile.txt>       : validates issuefiles using llm.\n"
  printf "  validateScript -vc <configFile.conf> <commitFile.txt>      : validates commitfiles using llm.\n"
  printf "  validateScript -vct <configFile.conf> <commitFile.txt>     : validates trees from commitfiles using llm.\n"
  printf "  validateScript -vfs\n"
elif [[ $1 == "-vdd" ]]
then
  if [[ -f $2 ]]
  then
    if [[ -f $3 ]]
    then
      source $2
      touch TEMP_designDocument.txt
      printf "Is the following document a valid design document for a software product?\n" > TEMP_designDocument.txt
      IFS=$'\n' read -d '' -r -a LINES < $3
      for LINE in "${LINES[@]}"; do
        printf "%s\n" "$LINE" >> TEMP_designDocument.txt
      done
      #./ollamaScript.sh -pf conf/ollamaConfig_ollama3-1.conf model/conf/validateDesignDoc.conf TEMP_designDocument.txt
      RESPONSE=$($G_VALIDATE_SCRIPT $G_TAGS $G_VALIDATE_CONF $G_MODEL_CONF TEMP_designDocument.txt)
      printf "%s\n" "$RESPONSE"
      rm TEMP_designDocument.txt
    else
      printf "DesignDocument not found.\n"
    fi
  else
    printf "ConfigFile not found.\n"
  fi
elif [[ $1 == "-vi" ]]
then
  if [[ -f $2 ]]
  then
    if [[ -f $3 ]]
    then
      source $2
      touch TEMP_issueFile.txt
      printf "Is the following document a valid list of issues for a software product?\n" > TEMP_issueFile.txt
      IFS=$'\n' read -d '' -r -a LINES < $3
      for LINE in "${LINES[@]}"; do
        printf "%s\n" "$LINE" >> TEMP_issueFile.txt
      done
      #./ollamaScript.sh -pf conf/ollamaConfig_ollama3-1.conf model/conf/validateIssueFile.conf TEMP_issueFile.txt
      RESPONSE=$($G_VALIDATE_SCRIPT $G_TAGS $G_VALIDATE_CONF $G_MODEL_CONF TEMP_issueFile.txt)
      printf "%s\n" "$RESPONSE"
      rm TEMP_issueFile.txt
    else
      printf "Issue file not found.\n"
    fi
  else
    printf "ConfigFile not found.\n"
  fi
elif [[ $1 == "-vc" ]]
then
  if [[ -f $2 ]]
  then
    if [[ -f $3 ]]
    then
      source $2
      touch TEMP_commitFile.txt
      printf "Is the following document a valid commit for a issue for a software product?\n" > TEMP_commitFile.txt
      IFS=$'\n' read -d '' -r -a LINES < $3
      for LINE in "${LINES[@]}"; do
        printf "%s\n" "$LINE" >> TEMP_commitFile.txt
      done
      #./ollamaScript.sh -pf conf/ollamaConfig_ollama3-1.conf model/conf/validateCommitRaw.conf TEMP_commitFile.txt
      RESPONSE=$($G_VALIDATE_SCRIPT $G_TAGS $G_VALIDATE_CONF $G_MODEL_CONF TEMP_commitFile.txt)
      printf "%s\n" "$RESPONSE"
      rm TEMP_commitFile.txt
    else
      printf "Commit file not found.\n"
    fi
  else
    printf "ConfigFile not found.\n"
  fi
elif [[ $1 == "-vct" ]]
then
  if [[ -f $2 ]]
  then
    if [[ -f $3 ]]
    then
      source $2
      touch TEMP_commitFile.txt
      printf "Is the tree structure in de following document valid for a commit for a software product?\n" > TEMP_commitFile.txt
      IFS=$'\n' read -d '' -r -a LINES < $3
      for LINE in "${LINES[@]}"; do
        printf "%s\n" "$LINE" >> TEMP_commitFile.txt
      done
      #./ollamaScript.sh -pf conf/ollamaConfig_ollama3-1.conf model/conf/validateCommitTree.conf TEMP_commitFile.txt
      RESPONSE=$($G_VALIDATE_SCRIPT $G_TAGS $G_VALIDATE_CONF $G_MODEL_CONF TEMP_commitFile.txt)
      printf "%s\n" "$RESPONSE"
      rm TEMP_commitFile.txt
    else
      printf "Commit file not found.\n"
    fi
  else
    printf "ConfigFile not found.\n"
  fi
fi
