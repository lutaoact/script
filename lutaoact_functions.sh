#!/bin/bash -xv

function qyg() {
  qingcloud "$@" -f ~/private-config/qingcloud_config.yaml
}

function qyw() {
  qingcloud "$@" -f ~/private-config/qingcloud_config_wind.yaml
}

function gotunnel() {
  while true
  do
    ssh -v -N tunnel
    sleep 5
  done
}

function remotenode() {
  while true
  do
    ssh -v -N remotenode
    sleep 10
  done
}

function mkdircd () {
  mkdir -p "$@" && eval cd "\"\$$#\""
}

function sort_lines_by_length {
  if [ -z "$1" ]; then
    echo "collection name is required"
    exit 1
  fi
  cp "$1" /tmp/$(basename "$1")
  awk '{print length, $0}' "$1" | sort -nk1 -s | cut -d" " -f2- > "${1}.tmp"
  mv "${1}.tmp" "$1"
}

function gbk2utf8 {
  j="${1}_tmp"
  iconv -f GBK -t UTF-8 "$1" > "$j"
  mv "$j" "$1"
  dos2unix -r "$1"
}

function svn_ci {
  dir=$(pwd)
  cd ~/Service/trunk/node-server/ && svn update
  #rsync的源路径如果以/结尾，表示同步目录里面的内容，如果没有/，则会将目录同步过去
  rsync --recursive --verbose --exclude=.git --exclude=scripts \
      --exclude=services --exclude=.gitignore --exclude=mongoscripts \
      --exclude-from="$dir"/.gitignore \
      "$dir"/ ~/Service/trunk/node-server/
#  rsync -r --quiet --exclude=.git --exclude=scripts --exclude=.gitignore --exclude-from="$dir"/.gitignore "$dir"/ ~/Service/trunk/node-server/
  svn add --force .
  svn ci -m "$1"
  cd $dir
}

function sync_to {
  if [ -z "$1" ]; then
    echo "collection name is required"
    exit 1
  fi
  date=$(date +%F)
  backup_file=${1}_$date.json
  echo -e "mongoexport -d gpws-dev -c $1 -o /data/backup/$backup_file"
  mongoexport -d gpws-dev -c "$1" -o /data/backup/$backup_file

  echo "scp /data/backup/$backup_file node:/data/backup"
  scp /data/backup/$backup_file node:/data/backup

  echo "ssh node \"mongoimport -h gpws/mongo,mongoB,mongoD -d gpws -c $1 /data/backup/$backup_file\""
  ssh node "mongoimport -h gpws/mongo,mongoB,mongoD -d gpws -c $1 /data/backup/$backup_file"
}

function sync_from {
  if [ -z "$1" ]; then
    echo "collection name is required"
    exit 1
  fi
  date=$(date +%F)
  backup_file=${1}_$date.json
  echo "ssh node \"mongoexport -h mongo -d gpws -c $1 -o /data/backup/$backup_file\""
  ssh node "mongoexport -h mongo -d gpws -c $1 -o /data/backup/$backup_file"

  echo "scp node:/data/backup/$backup_file /data/backup/"
  scp node:/data/backup/$backup_file /data/backup/

  echo -e "mongoimport -d gpws-dev -c $1 /data/backup/$backup_file"
  mongoimport -d gpws-dev -c $1 --numInsertionWorkers=4 --batchSize=100 --drop /data/backup/$backup_file
}

function dump {
  if [ -z "$1" ]; then
    echo "collection name is required"
    exit 1
  fi
  time_str=$(date +'%Y%m%d%H%M%S')
  backup_file=${1}_${time_str}.json
  echo -e "mongoexport -d gpws -c $1 -o /data/backup/$backup_file"
  mongoexport -d gpws -c "$1" -o /data/backup/$backup_file
}
