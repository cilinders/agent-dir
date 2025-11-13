#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]]
then
  printf "Usage: \n"
  printf "  projectRunnerScript -c <configFile>  :  Creates the actionFile for the using llm.\n"
  printf "  projectRunnerScript -r <configFile>  :  Runs actionFile to start the project.\n"
elif [[ $1 == "-c" ]]
then
  if [[ -f $2 ]]
  then
    #ACTION_FILE
    #PROJECT_DIR
    #CONTEXT_FILE
    source $2
    touch "$ACTION_FILE"
    printf "#!/bin/bash\n" > $ACTION_FILE
    #printf "%s\n" "$(ls -R $PROJECT_DIR)"
    declare -a PROJECT_PATHS_RAW=()
    declare -a PROJECT_FILES=()
    PROJECT_PATHS_RAW+=($(ls -R $PROJECT_DIR))
    DIR_PATH=""
    for LINE in ${PROJECT_PATHS_RAW[@]}; do
      #printf "%s\n" "$LINE"
      if [[ "$LINE" =~ ":" ]]
      then
        #DIR_PATH="${LINE:0:${#LINE}-1}/"
        DIR_PATH="$LINE"
        DIR_PATH=${LINE//':'/'/'}
        DIR_PATH=${DIR_PATH//'//'/'/'}
      elif [[ "$LINE" =~ "." ]]
      then
        #printf "%s%s\n" "$DIR_PATH" "$LINE"
        PROJECT_FILES+=("$DIR_PATH$LINE")
      fi
    done
    #printf "%s\n" "${#PROJECT_FILES[@]}"
    touch $CONTEXT_FILE
    printf "[" > $CONTEXT_FILE
    #TODO: cat all files into PROJECT_CONTEXT_FILE
    for ((i=0; i<${#PROJECT_FILES[@]}; ++i)); do #LINE in ${PROJECT_FILES[@]}; do
      printf "%s\n" "${PROJECT_FILES[$i]}"
      # Prints the filepath to the context
      printf '{"role":"user","content":"``` // '"${PROJECT_FILES[$i]}"'\\n' >> $CONTEXT_FILE
      # Prints the content of file to the context
      declare -a FILES_LINES_ARR=()
      FILE_LINES=$(cat "${PROJECT_FILES[$i]}")
      for LINE in ${FILE_LINES[@]}; do
        printf '%s\\n' "$LINE" >> $CONTEXT_FILE
      done
      if ! [[ $i -eq ${#PROJECT_FILES[@]}-1 ]]
      then
        printf '```"},' >> $CONTEXT_FILE
      else
        printf '```"}]' >> $CONTEXT_FILE
      fi
    done
    printf "%s\n" "$(cat $CONTEXT_FILE)"
  else
    printf "Config file not found.\n"
  fi
elif [[ $1 == "-r" ]]
then
  if [[ -f $2 ]]
  then
    printf "TODO: \n"
  else
    printf "Config file not found.\n"
  fi
fi
