#!/bin/bash

for ((i = 0; i < 5; i++)) do
  printf "A: %s\n" "$i"
done

for ((i = 0; i < 5; ++i)) do
  printf "B: %s\n" "$i"
done
