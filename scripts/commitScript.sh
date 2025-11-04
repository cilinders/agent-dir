#!/bin/bash

if [[ $# == 0 ]] || [[ $# -gt 4 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  commitScript -gi <configFile.conf> <issueFile.txt>   :  Generates commit from issuefile using llm.\n"
  printf "  commitScript -gic <configFile.conf>                  :  Generates commit from issuefile and codeblocks using llm.\n"
  printf "  commitScript -fs <configFile.conf>                   :  Formats structure for use with actionScript from commitFile.\n"
  printf "  commitScript -fp <configFile.txt> <file_path>        :  Returns files codeblock from commit using llm.\n"
  printf "  commitScript -fpa <configFile.txt>                   :  Formats all codeblocks from commit for use actionScript.\n"
elif [[ $1 == "-gi" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    source $2
    $G_SCRIPT $G_SCRIPT_TAG $G_LLM_CONF $G_MODEL_CONF $3 > $TEMP_COMMIT_FILE
  else
    printf "ConfigFile or issueFile not found.\n"
  fi
elif [[ $1 == "-gict" ]]
then
  if [[ -f $2 ]]
  then
    source $2
    touch TEMP_commit.txt
    if [[ -f $MESSAGE_HISTORY ]]
    then
      IFS=$'\n' read -d '' -r -a LINE_ARRAY < $MESSAGE_HISTORY
      #HISTORY_FORMATTED_STRING=""
      printf "[" > data/temp_test.txt
      for ((i = 1; i < ${#LINE_ARRAY[@]}; i+=2)); do
        #printf "%s\n" "$i"
        CONTENT_USER=$(printf "%s" "${LINE_ARRAY[$(($i-1))]}" | jq -sR .)
        CONTENT_USER=${CONTENT_USER//\\/\\\\}
        CONTENT_USER=${CONTENT_USER//'"'/'\"'}
        CONTENT_ASSISTANT=$(printf "%s" "${LINE_ARRAY[$i]}" | jq -sR .)
        CONTENT_ASSISTANT=${CONTENT_ASSISTANT//\\/\\\\}
        CONTENT_ASSISTANT=${CONTENT_ASSISTANT//'"'/'\"'}
        if [[ "$i" == $(( ${#LINE_ARRAY[@]}-1 )) ]]
        then
          #HISTORY_FORMATTED_STRING+='{"role":"user","content":'"$CONTENT_USER"'},'
          #HISTORY_FORMATTED_STRING+='{"role":"assistant","content":'"$CONTENT_ASSISTANT"'}'
          printf '{"role":"user","content":'"$CONTENT_USER"'},' >> data/temp_test.txt
          printf '{"role":"assistant","content":'"$CONTENT_ASSISTANT"'}' >> data/temp_test.txt
        else
          #HISTORY_FORMATTED_STRING+='{"role":"user","content":'"$CONTENT_USER"'},'
          #HISTORY_FORMATTED_STRING+='{"role":"assistant","content":'"$CONTENT_ASSISTANT"'},'
          printf '{"role":"user","content":'"$CONTENT_USER"'},' >> data/temp_test.txt
          printf '{"role":"assistant","content":'"$CONTENT_ASSISTANT"'},' >> data/temp_test.txt
        fi
      done
      printf ',{"role":"user","content":"Explain what we made and create a design doc for it."}]' >> data/temp_test.txt
      #printf "#!/bin/bash\n\n" > data/temp_test.txt
      #STRING_WITH="DATA_INSIDE_TEST='"
      #STRING_WITH+="$HISTORY_FORMATTED_STRING"
      #STRING_WITH+="'"
      #printf "%s\n" "$STRING_WITH" >> data/temp_test.txt
      printf "%s\n" "$(cat data/temp_test.txt | jq -sR .)"
      printf "ollo\n"
      ./ollamaScript.sh -pvc conf/ollamaConfig_ollama3-1.conf model/conf/test.conf "Explain what we made and create a design doc for it."
    else
      printf "History file not found.\n"
    fi
  else
    printf "Config file not found.\n"
  fi
elif [[ $1 == "-gic" ]]
then
  #TODO: maak hiervan -> ?ask per element?
  #                      ~Issue Name:
  #                      ~Description:
  #                      ~Structure:
  #                      ~Code Changes:
  #                      ~Tests:
  #                      ~Commit Message:
  if [[ -f $2 ]]
  then
    source $2
    touch TEMP_commit.txt
    #TODO: create HISTORY tasks done chat history file for G_SCRIPT to use
    HISTORY_LINES=""
    if [[ -f $MESSAGE_HISTORY ]]
    then
      while IFS='' read -e -r LINE; do
        #printf "%s\n" "$LINE"
        HISTORY_LINES+="$LINE\n"
      done < $MESSAGE_HISTORY
    fi
    #TODO: split on full string not if its inside IFS
    HISTORY_FORMATTED_STRING=""
    delimiter='TASK:'
    s=$HISTORY_LINES$delimiter
    declare -a HISTORY_ARR=();
    while [[ $s ]]; do
      HISTORY_ARR+=( "${s%%"$delimiter"*}" );
      s=${s#*"$delimiter"}
    done;
    printf "[" > data/temp_test.txt
    for ((i = 0; i < ${#HISTORY_ARR[@]}; ++i)); do
    #for LINE in "${HISTORY_ARR[@]}"; do
      delimiter='SOLUTION:'
      s=${HISTORY_ARR[$i]}$delimiter
      #s=$LINE$delimiter
      declare -a HISTORY_ARR_ELL=();
      while [[ $s ]]; do
        HISTORY_ARR_ELL+=( "${s%%"$delimiter"*}" );
        s=${s#*"$delimiter"}
      done;
      if ! [[ ${#HISTORY_ARR_ELL[0]} -eq 0 ]]
      then
        #TODO: MAYBE jq RIGHT TRACK
        #CONTENT_USER=$(printf "%s" "${HISTORY_ARR_ELL[0]}" | sed -e 's/./\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
        #CONTENT_ASSISTANT=$(printf "%s" "${HISTORY_ARR_ELL[1]}" | sed -e 's/./\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
        CONTENT_USER=$(printf "%s" "${HISTORY_ARR_ELL[0]}" | jq -sR .)
        CONTENT_USER=${CONTENT_USER//\\/\\\\}
        CONTENT_USER=${CONTENT_USER//'"'/'\"'}
        CONTENT_ASSISTANT=$(printf "%s" "${HISTORY_ARR_ELL[1]}" | jq -sR .)
        CONTENT_ASSISTANT=${CONTENT_ASSISTANT//\\/\\\\}
        CONTENT_ASSISTANT=${CONTENT_ASSISTANT//'"'/'\"'}
        #printf "%s\n" "$CONTENT_ASSISTANT"
        if [[ "$i" == $(( ${#HISTORY_ARR[@]}-1 )) ]]
        then
          #HISTORY_FORMATTED_STRING+='{"role":"user","content":'"$CONTENT_USER"'},'
          #HISTORY_FORMATTED_STRING+='{"role":"assistant","content":'"$CONTENT_ASSISTANT"'}'
          printf '{"role":"user","content":'"$CONTENT_USER"'},' >> data/temp_test.txt
          printf '{"role":"assistant","content":'"$CONTENT_ASSISTANT"'}' >> data/temp_test.txt
        else
          #HISTORY_FORMATTED_STRING+='{"role":"user","content":'"$CONTENT_USER"'},'
          #HISTORY_FORMATTED_STRING+='{"role":"assistant","content":'"$CONTENT_ASSISTANT"'},'
          printf '{"role":"user","content":'"$CONTENT_USER"'},' >> data/temp_test.txt
          printf '{"role":"assistant","content":'"$CONTENT_ASSISTANT"'},' >> data/temp_test.txt
        fi
      fi
    done
    printf ',{"role":"user","content":"Explain what we made and create a design doc for it."}]' >> data/temp_test.txt
    #printf "#!/bin/bash\n\n" > data/temp_test.txt
    #STRING_WITH="DATA_INSIDE_TEST='"
    #STRING_WITH+="$HISTORY_FORMATTED_STRING"
    #STRING_WITH+="'"
    #printf "%s\n" "$HISTORY_FORMATTED_STRING" > data/temp_test.txt
    #printf "%s\n" "$STRING_WITH" >> data/temp_test.txt
    #TODO: make the HISTORY_FORMATTED_STRING go into the -pvc
    ./ollamaScript.sh -pvc conf/ollamaConfig_ollama3-1.conf model/conf/test.conf "Explain what we made"
    #TODO: G_SCRIPT ISSUE_NAME with HISTORY > print to file
    #TODO: G_SCRIPT DESCRIPTION with HISTORY > print to file
    #TODO: G_SCRIPT STRUCTURE with HISTORY > print to file
    #TODO: G_SCRIPT CODE_CHANGE per FILE from STRUCTURE with HISTORY > print all to file
    #TODO: G_SCRIPT TESTS per FILE from STRUCTURE with HISTORY > print all to file
    #TODO: G_SCRIPT COMMIT_MESSAGE with HISTORY > print to file
  else
    printf "Config file not found.\n"
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
#      printf "create,structure,%s\n" "$STRUCTURE" > $TEMP_FORMAT_FILE
      printf "%s\n" "$STRUCTURE" > $TEMP_FORMAT_FILE
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
    #IFS='' read -d '' -r STRUCTURE < $FILE_PATHS
    #printf "%s\n" "$STRUCTURE"
    declare -a FILES=()
    IFS=' ' read -r -a STR_ARR <<< $STRUCTURE
    declare -a STRUCTURE_PATH=()
    NESTED=0
    for ((i = 0; i < ${#STR_ARR[@]}; ++i))
    do
      if [[ "${STR_ARR[$i]}" == "{" ]]
      then
        ((NESTED++))
        LAST_INDEX=$i
        ((LAST_INDEX--))
        STRUCTURE_PATH+=("${STR_ARR[$LAST_INDEX]}")
      elif [[ "${STR_ARR[$i]}" == "}" ]]
      then
        ((NESTED--))
        unset STRUCTURE_PATH[-1]
      elif [[ "${STR_ARR[$i]}" =~ "." ]]
      then
        CURRENT_PATH=""
        for p in "${STRUCTURE_PATH[@]}"
        do
          CURRENT_PATH+="$p/"
        done
        #printf "%s%s\n" "$CURRENT_PATH" "${STR_ARR[$i]}"
        FILES+=("$CURRENT_PATH${STR_ARR[$i]}")
      fi
    done
    printf "" > $TEMP_CODE_FORMATTED
    for f in "${FILES[@]}"
    do
      printf "%s\n" "$f"
      if ! [[ $f == "." ]]
      then
        #TODO validate commit contains codeblocks for given file
        
        #if [[  ]]
        FORMATTED_CODE=$(./commitScript.sh -fp $FS_CONF $f)
        printf "%s\n" "$FORMATTED_CODE"
        printf "%s -> %s\n" "$f" "$FORMATTED_CODE" >> $TEMP_CODE_FORMATTED
      fi
    done
  else
    printf "Config file not found.\n"
  fi
fi
