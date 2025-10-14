#!/bin/bash

if [[ $# == 0 ]] || [[ $1 == "-h" ]] || [[ $1 == "-help" ]]
then
  printf "Usage: \n"
  printf "  agentScript.sh -s <configFile.conf>: Start agent using the configFile.\n"
elif [[ $1 == "-s" ]]
then
  if [[ -f $2 ]]
  then
    #TODO: implement remainder of the flow
    #TODO: insert validation scripts to validate the output for cleanly sliding input.
    # script flow: design -> issue -> issueFormat -> issueOpen -> commit -> commitStructformat -> actionscript
    # configfile
    #  design -> G_DESIGN_SCRIPT, G_DESIGN_TAGS, G_DESIGN_CONFIG_FILE, G_DESIGN_INPUT_FILE
    #  TODO: format designfile form raw design file
    #  issue -> $G_ISSUE_SCRIPT $G_ISSUE_TAGS $G_ISSUE_CONFIG_FILE $DESIGN_FILE
    #  issueformat -> G_ISSUE_SCRIPT, G_ISSUE_RAW_TAGS, G_ISSUE_CONFIG_FILE, G_RAW_ISSUE_FILE
    #  issueOpen -> G_ISSUE_SCRIPT, G_ISSUE_OPEN_TAGS, G_ISSUE_CONFIG_FILE, G_OPEN_ISSUE_FILE
    #  commmit -> G_COMMIT_SCRIPT, G_COMMIT_TAGS, G_COMMIT_CONFIG_FILE, G_OPEN_ISSUE_FILE
    #  commitFormat -> G_COMMIT_SCRIPT, G_COMMIT_FORMAT_STRUCT_TAGS, G_COMMIT_CONFIG_FILE
    source $2
#    $G_DESIGN_SCRIPT $G_DESIGN_TAGS $G_DESIGN_CONFIG_FILE $G_DESIGN_INPUT_FILE
    #printf "%s %s %s %s\n" "$G_ISSUE_SCRIPT $G_ISSUE_TAGS $G_ISSUE_CONFIG_FILE $G_DESIGN_FILE"
#    $G_ISSUE_SCRIPT $G_ISSUE_TAGS $G_ISSUE_CONFIG_FILE $G_DESIGN_FILE
#    $G_ISSUE_SCRIPT $G_ISSUE_RAW_TAGS $G_ISSUE_CONFIG_FILE $G_RAW_ISSUE_FILE
#    $G_ISSUE_SCRIPT $G_ISSUE_OPEN_TAGS $G_ISSUE_CONFIG_FILE $G_OPEN_ISSUE_FILE
    $G_COMMIT_SCRIPT $G_COMMIT_TAGS $G_COMMIT_CONFIG_FILE $G_OPEN_ISSUE_FILE
    #TODO: now only generates a create structure action for the first issue
       #TODO: format file
#    $G_COMMIT_SCRIPT $G_COMMIT_FORMAT_STRUCT_TAGS $G_COMMIT_FORMAT_CONFIG_FILE
       #TODO: structure file
#    $G_COMMIT_SCRIPT $G_COMMIT_FORMAT_STRUCT_TAGS $G_COMMIT_FORMAT_CONFIG_FILE
  else
    printf "ConfigFile not found.\n"
  fi
fi
