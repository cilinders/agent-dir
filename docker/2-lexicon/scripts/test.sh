#!/bin/bash

#valid=false
#while [[ "$valid" == "false" ]]; do
#  printf "1. design\n"
#  ./designScript.sh -f ../conf/designConfig.conf ../data/idee.txt
#  printf "1.1 validate design\n"
  #printf "1.1 TODO: fails redo 1.\n"
#  RESPONSE=$(./validateScript.sh -vdd ../conf/validate_designConfig.conf ../data/design_doc_raw.txt)
#  printf "%s\n" "$RESPONSE"
#  if [[ "$RESPONSE" =~ "True" ]]; then
#    valid=true
#  fi
#done
#printf "2. dir setup\n"
#./projectScript.sh -id ../conf/projectScriptConfig.conf

valid=false
while [[ "$valid" == "false" ]]; do
  printf "3. issues\n"
  ./issueScript.sh -g ../conf/issueConfig.conf ../data/design_doc_raw.txt
  printf "3.1 validate issues\n"
  #printf "3.1 TODO: fails redo 3.\n"
  RESPONSE=$(./validateScript.sh -vi ../conf/validate_issuesConfig.conf ../data/raw_issues.txt)
  printf "%s\n" "$RESPONSE"
  if [[ "$RESPONSE" =~ "True" ]]; then
    valid=true
  fi
done
#printf "4. format issues\n"
#./issueScript.sh -fi ../conf/issueConfig.conf ../data/raw_issues.txt
#printf "5. open issue -> TODO all issues\n"
#./issueScript.sh -fo ../conf/issueConfig.conf ../data/open_issues.txt
#printf "6. plan issue\n"
#./planScript.sh -p ../conf/planConfig.conf
#printf "7. writing code\n"
#printf "7.x TODO: validate inside testPlanConfig\n"
#./planScript.sh -tp ../conf/testPlanConfig.conf
#printf "8. commiting\n"
#./commitScript.sh -gic ../conf/commitCodeGivenConfig.conf
#printf "8.1 TODO: validate\n"
#printf "9. stripping codeblocks\n"
#./commitScript.sh -ff ../conf/commitFiles.conf
#printf "10. creating files"
#./actionScript.sh ../data/action_files_file.txt ../conf/actionConfig.conf
