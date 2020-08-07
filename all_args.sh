#!/bin/bash

for i in "$@"; do
  echo $i;
done

for i in "$@"; do
  while read -r j; do
    echo $j
  done < "$i"
done
