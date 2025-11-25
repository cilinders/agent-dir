#!/bin/bash

#BEFORE: STATED GOAL!

#AFTER: GOAL REACHED?

#TODO: something goes wrong in the pipeline when getting here.
CREATE_STRUCTURE() {
  IFS=' ' read -d '' -ra COMPONENTS <<< "$DATA"
  declare -a STRUCTURE_PATH=()
  NESTED=0
  for ((j = 1; j < ${#COMPONENTS[@]}; ++j))
  do
    printf "$j %s" "${COMPONENTS[$j]}"
    if [[ "${COMPONENTS[$j]}" == "{" ]]
    then
      ((NESTED++))
      LAST_INDEX=$j
      ((LAST_INDEX--))
      STRUCTURE_PATH+=("${COMPONENTS[$LAST_INDEX]}")
    elif [[ "${COMPONENTS[$j]}" == "}" ]]
    then
      ((NESTED--))
      unset STRUCTURE_PATH[-1]
      #printf " %s " "${STRUCTURE_PATH[*]}"
    elif [[ "${COMPONENTS[$j]}" =~ "." ]]
    then
      CURRENT_PATH=""
      for p in "${STRUCTURE_PATH[@]}"
      #for ((k = 0; k < $NESTED; ++k))
      do
        CURRENT_PATH+="$p/"
      done
      printf " -> touch %s" "$CURRENT_PATH"
      printf "%s " "${COMPONENTS[$j]}"
    else
      if ! [[ "${COMPONENTS[$j]}" =~ "}" ]]
      then
        CURRENT_PATH=""
        for p in "${STRUCTURE_PATH[@]}"
        do
          CURRENT_PATH+="$p/"
        done
        printf " -> mkdir %s" "$CURRENT_PATH"
        printf "%s " "${COMPONENTS[$j]}"
      fi
    fi
    printf " %s " "$NESTED"
    printf "\n"
  done
}

CREATE_DIRECTORY() {
  printf "create dir"
}

#TODO: lost whitespaces v broken atm. problem with provided data not createfile
#TODO: IFFY now loops string $DATA 
CREATE_FILE() {
  #TODO: does file exist?
  #TODO: where to create
  #TODO: content
  #printf "create file\n"
  #IFS= read -r -a LINE_ARRAY <<< "$DATA"
  #printf "%s\n" "${#LINE_ARRAY[@]}"
  #for LINE in "${LINE_ARRAY[@]}"; do
  #  printf "%s\n" "$LINE"
  #done
  FORMATTED_DATA=""
  FILE_PATH=""
  for (( j=0; j<${#DATA}; ++j )); do
    #printf "%s:%s:\n" "$j" "${DATA:$j:2}"
    if [[ "${DATA:$j:2}" =~ "\n" ]]
    then
      #printf "true\n"
      #printf "%s\n" "$FORMATTED_DATA"
      if [[ "${#FILE_PATH}" == 0 ]]
      then
        FILE_PATH+="$PROJECT_PATH"
        FILE_PATH+="${FORMATTED_DATA:1}"
        SLASH_INDEX=0
        for ((k=0; k<${#FILE_PATH}; ++k)); do
          if [[ "${FILE_PATH:$k:1}" == "/" ]]
          then
            SLASH_INDEX="$k"
          fi
        done
        printf "%s\n" "${FILE_PATH:0:$SLASH_INDEX}"
        mkdir -p "${FILE_PATH:0:$SLASH_INDEX}"
        printf "%s\n" "$FILE_PATH"
        touch "$FILE_PATH"
        # TODO: remove this
        printf "" > "$FILE_PATH"
      else
        printf "%s\n" "$FORMATTED_DATA" >> "$FILE_PATH"
      fi
      FORMATTED_DATA=""
    else
      #printf "false\n"
      NEXT=$(($j-1))
      if ! [[ "${DATA:$NEXT:2}" =~ "\n" ]]
      then
        TO_ADD="${DATA:$j:1}"
        #printf "to> %s <add\n" "$TO_ADD"
        FORMATTED_DATA+="${DATA:$j:1}"
      fi
    fi
  done
  #printf "%s\n" "${#DATA}"
}

STEP_CREATE() {
  if [[ $TARGET == "structure" ]]; then
    #TODO:
    CREATE_STRUCTURE "$DATA"
  elif [[ $TARGET == "directory" ]]; then
    #TODO:
    CREATE_DIRECTORY "$DATA"
  elif [[ $TARGET == "file" ]]; then
    #TODO:
    CREATE_FILE "$DATA"
  fi
}

STEP_READ() {
  printf "step read"
}

STEP_WRITE() {
  printf "step write"
}

STEP_REMOVE() {
  printf "step remove"
}

STEP_TEST() {
  printf "step test"
}

STEP_ACTION() {
  #printf "action: %s\n" "$1"
  IFS=',' read -r ACTION TARGET DATA <<< "$1"
  #printf "type: %s\n" "$ACTION"
  #printf "target: %s\n" "$TARGET"
  #printf "data: %s\n" "$DATA"
  if [[ "${ACTION[0]}" == "create" ]]; then
    STEP_CREATE "$TARGET" "$DATA"
  elif [[ "${ACTION[0]}" == "read" ]]; then
    STEP_READ "${TARGET_DATA[0]}" "${TARGET_DATA[1]}"
  elif [[ "${ACTION[0]}" == "write" ]]; then
    STEP_WRITE "${TARGET_DATA[0]}" "${TARGET_DATA[1]}"
  elif [[ "${ACTION[0]}" == "remove" ]]; then
    STEP_REMOVE "${TARGET_DATA[0]}" "${TARGET_DATA[1]}"
  elif [[ "${ACTION[0]}" == "test" ]]; then
    STEP_TEST "${TARGET_DATA[0]}" "${TARGET_DATA[1]}"
  fi
}

if [[ $# == 0 ]] || [[ $1 == "-h" ]]
then
  printf "Usage: \n"
  printf "  actionScript.sh <actionFile> <configFile>  : Executes action in the action file.\n"
elif [[ $1 == "-t" ]]
then
  source $2
  printf "%s\n" "$PROJECT_DIR"
elif [[ $# == 2 ]] && [[ -f $1 ]] && [[ -f $2 ]]
then
  source $2
  IFS=$'\n' read -d '' -r -a ACTIONS < $1
  #printf "%s\n" "${#ACTIONS[@]}"
  for ((i = 2; i < ${#ACTIONS[@]}; ++i))
  do
    #printf "%s\n\n" "${ACTIONS[$i]}"
    #TODO: devide action into steps
    STEP_ACTION "${ACTIONS[$i]}"
  done
  #STEP_ACTION "${ACTIONS[2]}"
else
  printf "Action or config file not found\n"
fi

#TODO: loop list

  #TODO: devide action into steps

  #TODO: loop steps

    #TODO: preform step
      #TODO: log step and reverse for step

    #TODO: validate step
      #TODO: ERROR: reverse all actions
        #TODO: log error start bad step feedback

