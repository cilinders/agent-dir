#!/bin/bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>test_log.log 2>&1

echo "this should go into log file."
echo "this should go to the terminal." | tee /dev/fd/3
