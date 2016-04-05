#!/bin/bash

function gbk2utf8 {
  j="${1}_tmp"
  iconv -f GBK -t UTF-8 "$1" > "$j"
  mv "$j" "$1"
  dos2unix -r "$1"
}

function svn_ci {
  dir=$(pwd)
  #rsync的源路径如果以/结尾，表示同步目录里面的内容，如果没有/，则会将目录同步过去
  rsync -rv --exclude=.git --exclude=.gitignore --exclude-from="$dir"/.gitignore "$dir"/ ~/Service/trunk/node-server/
  cd ~/Service/trunk/node-server/
  svn add --force .
  svn ci -m "$1"
  cd $dir
}
