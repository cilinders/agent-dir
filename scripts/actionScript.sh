#!/bin/bash

#BEFORE: STATED GOAL!

#AFTER: GOAL REACHED?

CREATE_STRUCTURE() {
  IFS=' ' read -d '' -ra COMPONENTS <<< "$DATA"
  for ((j = 0; j < ${#COMPONENTS[@]}; ++j))
  do
    #TODO: if dir -> mkdir (use right structure(create right logic))
    printf "$j %s\n" "${COMPONENTS[$j]}"
  done
}

CREATE_DIRECTORY() {
  printf "create dir"
}

CREATE_FILE() {
  printf "create file"
}

STEP_CREATE() {
  if [[ $TARGET == "structure" ]]; then
    #TODO:
    CREATE_STRUCTURE "$DATA"
  elif [[ $1 == "directory" ]]; then
    #TODO:
    CREATE_DIRECTORY $2
  elif [[ $1 == "file" ]]; then
    #TODO:
    CREATE_FILE $2
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
  printf "action: %s\n" "$1"
  IFS=',' read -r ACTION TARGET DATA <<< "$1"
  printf "type: %s\n" "$ACTION"
  printf "target: %s\n" "$TARGET"
  printf "data: %s\n" "$DATA"
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

if [ $# == 1 ] || [ -f $1 ]
then
  IFS=$';\n' read -d '' -r -a ACTIONS < $1
  #for ((i = 2; i < ${#ACTIONS[@]}; ++i))
  #do
    #printf "%s\n\n" "${ACTIONS[$i]}"
    #TODO: devide action into steps
    #STEP_ACTION "${ACTIONS[$i]}"
  #done
  STEP_ACTION "${ACTIONS[2]}"
else
  printf "Action file not found\n"
fi

#TODO: loop list

  #TODO: devide action into steps

  #TODO: loop steps

    #TODO: preform step
      #TODO: log step and reverse for step

    #TODO: validate step
      #TODO: ERROR: reverse all actions
        #TODO: log error start bad step feedback

