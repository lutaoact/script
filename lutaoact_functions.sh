#!/bin/bash

function gbk2utf8 {
  j="${1}_tmp"
  iconv -f GBK -t UTF-8 "$1" > "$j"
  mv "$j" "$1"
  dos2unix -r "$1"
}
