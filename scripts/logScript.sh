#!/bin/bash

if [ $# == 0 ]
then
  echo "todo: funcyfy ?make it be able to wrap around other scripts"
  echo "Usage:"
  echo "  logScript -l <config.conf>  : Logs all out to file."
  echo "  logScript -s                : Restores default descriptors."
elif [ $# == 2 ] && [ $1 == "-l" ]
then
  echo "2 -l"
  CONF=$2
  if [ -f $CONF ]
  then
    source $CONF
    if [ -f $LOG_NAME ]
    then
      echo "Starting to log to $LOG_NAME"
      exec 3>&1 4>&2
      trap 'exec 2>&4 1>&3' 0 1 2 3
      exec 1>>$LOG_NAME 2>&1
    else
      echo "File $LOG_NAME does not exist."
    fi
  else
    echo "File $CONF does not exist."
  fi
elif [ $1 == "-s" ]
then
  echo "Restoring to default descriptors for out."
  exec 2>&4 1>&3
fi
