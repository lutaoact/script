#!/bin/bash

function gbk2utf8 {
  j="${1}_tmp"
  iconv -f GBK -t UTF-8 "$1" > "$j"
  mv "$j" "$1"
  dos2unix -r "$1"
}

function svn_ci {
  dir=$(pwd)
  cd ~
  rsync -rv --exclude=.git --exclude=.gitignore --exclude-from=node-server/.gitignore ~/node-server/ ~/Service/trunk/node-server/
  cd ~/Service/trunk/node-server/
  svn add --force .
  svn ci -m "$1"
  cd $dir
}
