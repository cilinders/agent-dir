#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]]
then
  printf "Usage: \n"
  printf "  projectRunnerScript -c <configFile>  :  Creates the actionFile for the using llm.\n"
  printf "  projectRunnerScript -r <configFile>  :  Runs actionFile to start the project.\n"
  printf "  projectRunnerScript -d <configFile>  :  Debugs runScript using llm.\n"
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
      #declare -a FILES_LINES_ARR=()
      IFS=$'\n'
      FILE_LINES=$(cat "${PROJECT_FILES[$i]}")
      for LINE in ${FILE_LINES[@]}; do
        #printf '%s\n' "$LINE"
        printf '%s\\n' "$LINE" >> $CONTEXT_FILE
      done
      printf '```"},' >> $CONTEXT_FILE
    done
    printf '{"role":"user","content":' >> $CONTEXT_FILE
    #printf "%s\n" "$(cat $CONTEXT_FILE)"
    PROMPT="$(cat $CONTEXT_FILE)"'"Generate a bash script to run the application, no additional commentary."}]'
    #TODO: curl llm and print/run runner
    #CONFIG: ./ollamaScript.sh -pvc conf/ollamaConfig_ollama3-1.conf model/conf/test.conf "$PROMPT"
    RESPONSE=$($G_SCRIPT $G_TAG $G_CONF $G_MODEL_CONF "$PROMPT")
    printf "%s\n" "$RESPONSE"
    IFS=$'\n'
    touch $PROJECT_DIR/run.sh
    printf "" > $PROJECT_DIR/run.sh
    START_RUN_PRINT=false
    for LINE in ${RESPONSE[@]}; do
      if [[ "$LINE" == '```bash' ]]
      then
        START_RUN_PRINT=true
      elif [[ "$LINE" == '```' ]]
      then
        START_RUN_PRINT=false
      elif [[ "$START_RUN_PRINT" == true ]]
      then
        printf "%s\n" "$LINE" >> $PROJECT_DIR/run.sh
      fi
    done
    chmod +x $PROJECT_DIR/run.sh
  else
    printf "Config file not found.\n"
  fi
elif [[ $1 == "-r" ]]
then
  # CONTEXT/ERROR_FILE req from -b/-r
  if [[ -f $2 ]]
  then
    source $2
    touch $ERROR_LOG
    printf "ERROR from running run script: " > $ERROR_LOG
    sh "$PROJECT_DIR"run.sh 2>>$ERROR_LOG
    cat $ERROR_LOG
  else
    printf "Config file not found.\n"
  fi
elif [[ $1 == "-d" ]]
then
  if [[ -f $2 ]]
  then
    source $2
    #PROMPT="$(cat $CONTEXT_FILE)"
    printf '"``` %srun.sh\\n' "$PROJECT_DIR" >> $CONTEXT_FILE
    IFS=$'\n'
    FILE_LINES=$(cat "$PROJECT_DIR"run.sh)
    for LINE in ${FILE_LINES[@]}; do
      #printf '%s\n' "$LINE"
      printf '%s\\n' "$LINE" >> $CONTEXT_FILE
    done
    printf '```"},{"role":"user","content":"' >> $CONTEXT_FILE
    FILE_LINES=$(cat "$ERROR_LOG")
    for LINE in ${FILE_LINES[@]}; do
      printf '%s\\n' "$LINE" >> $CONTEXT_FILE
    done
    printf '"},{"role":"user","content","Generate a response resolving the error, no additional commentary."}]' >> $CONTEXT_FILE
    PROMPT="$(cat $CONTEXT_FILE)"
    RESPONSE=$($G_SCRIPT $G_TAG $G_CONF $G_MODEL_CONF "$PROMPT")
    printf "%s\n" "$RESPONSE"
  else
    printf "Config file not found.\n"
  fi
fi
