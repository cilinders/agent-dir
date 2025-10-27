#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage:\n"
  printf "  validateScript -vdd <configFile.conf> <designDocument.txt> : validates design document using llm.\n"
  printf "  validateScript -vi <configFile.conf> <issueFile.txt>       : validates issuefiles using llm.\n"
  printf "  validateScript -vc <configFile.conf> <commitFile.txt>      : validates commitfiles using llm.\n"
  printf "  validateScript -vct <configFile.conf> <commitFile.txt>     : validates trees from commitfiles using llm.\n"
  printf "  validateScript -vfs <formatFile.txt>                       : validates file structure string.\n"
  printf "  validateScript -vfp <formatFile.txt>                       : validates file paths in structure string.\n"
  printf "  validateScript -vfc <formatFile.txt>                       : validates codeblocks in create string.\n"
  printf "  validateScript -vfic <commitFile.txt> <filepath>           : validates files codeblock exists in commit.\n"
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
elif [[ $1 == "-vfs" ]]
then
  if [[ -f $2 ]]
  then
    # TDOD: clean printf
    # create,structure,. {... TODO: -> . { ...
    IFS=$'\n' read -d '' -r LINE < $2
    #printf "%s\n" "${LINE[0]}"
    IFS=' ' read -r PRETEXT STR_STRING <<< ${LINE[0]}
    #printf "%s\n" "$PRETEXT"
    # .] {...
    #printf "%s\n" "$STR_STRING"
    IFS=' ' read -r -a STR_ARR <<< "$STR_STRING"
    #TODO: validate rules ->etc. after 'x.x' no '{' etc
    N_OPEN=0
    N_CLOSE=0
    E_LAST=""
    VALID="true"
    for s in ${STR_STRING[@]}; do
      #printf "%s\n" "$s"
      if [[ $s == "{" ]]
      then
        ((N_OPEN++))
        if [[ "$E_LAST" =~ "." ]]
        then
          VALID="false"
          break
        fi
      fi
      if [[ $s == "}" ]]
      then
        ((N_CLOSE++))
      fi
      E_LAST="$s"
    done
    #printf "open: %s\nclose: %s\n" "$N_OPEN" "$N_CLOSE"
    if [[ "$VALID" == "true" ]] && ! [[ "$N_OPEN" == "$N_CLOSE" ]]
    then
      VALID="false"
    fi
    printf "%s\n" "$VALID"
  else
    printf "Structure file not found.\n"
  fi
elif [[ $1 == "-vfp" ]]
then
  if [[ -f $2 ]]
  then
    # create,structure,. {...
    IFS=$'\n' read -d '' -r LINE < $2
    printf "%s\n" "${LINE[0]}"
    IFS=' ' read -r PRETEXT STR_STRING <<< ${LINE[0]}
    printf "%s\n" "$PRETEXT"
    # .] {...
    printf "%s\n" "$STR_STRING"
    IFS=' ' read -r -a COMPONENTS <<< "$STR_STRING"
    #TODO: validate paths -> ./file/to/path
    declare -a STRUCTURE_PATH=()
    #TODO: . is split from the path and manually added here
    STRUCTURE_PATH+="."
    #TODO: i0 is ignored which should be "{"
    NESTED=0
    for ((i = 1; i < ${#COMPONENTS[@]}; ++i))
    do
      #printf "$i %s" "${COMPONENTS[$i]}"
      if [[ "${COMPONENTS[$i]}" == "{" ]]
      then
        ((NESTED++))
        LAST_INDEX=$i
        ((LAST_INDEX--))
        STRUCTURE_PATH+=("${COMPONENTS[$LAST_INDEX]}")
      elif [[ "${COMPONENTS[$i]}" == "}" ]]
      then
        ((NESTED--))
        unset STRUCTURE_PATH[-1]
      elif [[ "${COMPONENTS[$i]}" =~ "." ]]
      then
        CURRENT_PATH=""
        for p in "${STRUCTURE_PATH[@]}"
        do
          CURRENT_PATH+="$p/"
        done
        printf " -> touch %s" "$CURRENT_PATH"
        printf "%s " "${COMPONENTS[$i]}"
        # TODO: just checks contains not placement or count eg file.. possible
        if ! [[ "${CURRENT_PATH:0:2}" == "./" ]]
        then
          printf "./ false"
        fi
        if [[ "$CURRENT_PATH" =~ "//" ]]
        then
          printf "// false"
        fi
        if [[ "${CURRENT_PATH:2}" =~ [^-a-zA-Z0-9_/] ]] || [[ "${COMPONENTS[$i]}" =~ [^-a-zA-Z0-9_.] ]]
        then
          printf "special false"
        fi
      else
        if ! [[ "${COMPONENTS[$i]}" =~ "}" ]]
        then
          CURRENT_PATH=""
          for p in "${STRUCTURE_PATH[@]}"
          do
            CURRENT_PATH+="$p/"
          done
          printf " -> mkdir %s" "$CURRENT_PATH"
          printf "%s " "${COMPONENTS[$i]}"
          # ./dir[/sub]^*
          if ! [[ "${CURRENT_PATH:0:2}" == "./" ]]
          then
            printf "./ false"
          fi
          if [[ "$CURRENT_PATH" =~ "//" ]]
          then
            printf "// false"
          fi
          #TODO: '-' only if its first after ^
          if [[ "${CURRENT_PATH:2}" =~ [^-a-zA-Z0-9_/] ]] || [[ "${COMPONENTS[$i]}" =~ [^-a-zA-Z0-9_/] ]]
          then
            printf "special false"
          fi
        fi
      fi
      printf " %s " "$NESTED"
      printf "\n"
    done
  else
    printf "Structure file not found.\n"
  fi
elif [[ $1 == "-vfc" ]]
then
  if [[ -f $2 ]]
  then
    # create,file, ???
    # Xfile_nameX\n???
    IFS=$'\n' read -d '' -ra LINES < $2
    touch TEMP_codeblock.txt
    declare -a CODE_LINES=()
    START_BLOCK=false
    for ((i = 1; i < ${#LINES[@]}; ++i))
    do
      if $START_BLOCK
      then
        if [[ "${LINES[$i]}" =~ "\`\`\`" ]]
        then
          break
        else
          printf "%s\n" "${LINES[$i]}"
        fi
      fi
      if ! $START_BLOCK
      then
        if [[ "${LINES[$i]}" =~ "\`\`\`" ]]
        then
          START_BLOCK=true
          #printf "start\n"
        #else
          #printf "skip\n"
        fi
      fi
    done
    #TODO: this currently takes a bad formatted block from llm
    cp TEMP_codeblock.txt $2
  else
    printf "Codeblock file not found.\n"
  fi
elif [[ $1 == "-vfic" ]]
then
  if [[ -f $2 ]] || [[ -f $3 ]]
  then
    source $2
    touch TEMP_prompt.txt
    printf "Does the following text contain the code changes for `%s`:\n" "$4" > TEMP_prompt.txt
    IFS=$'\n' read -d '' -r -a LINES < $3
    for LINE in "${LINES[@]}"; do
      printf "%s\n" "$LINE" >> TEMP_prompt.txt
    done
    #./ollamaScript.sh -pf conf/ollamaConfig_ollama3-1.conf model/conf/validateCommitFileSrc.conf TEMP_prompt.txt
    RESPONSE=$($G_VALIDATE_SCRIPT $G_TAGS $G_VALIDATE_CONF $G_MODEL_CONF TEMP_prompt.txt)
    printf "%s\n" "$RESPONSE"
    rm TEMP_prompt.txt
  else
    printf "Config or commit file not found.\n"
  fi
fi
