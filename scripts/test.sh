#!/bin/bash

PROMPT='[{"role":"user", "content":"The secret word is: AUGURK"}, {"role":"user", "content":"What is the secret word?"}]'

RESPONSE=$(./ollamaScript.sh -pvc conf/ollamaConfig_ollama3-1.conf model/conf/test.conf "$PROMPT")
printf "%s\n" "$RESPONSE"
