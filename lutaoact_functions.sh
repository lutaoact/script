#!/bin/bash -xv

#alias ls='ls -G' #for BSD ls
#alias ll="ls -alFG" #for BSD ls

alias ls='ls --color=auto' #for GNU ls
alias ll="ls --color=auto -alF" #for GNU ls
alias grep='grep --color=auto'

alias redis-cli='redis-cli --raw' #让redis-cli正常显示中文

function cd() { builtin cd "$@" && ls; }

russellauth() {
  while true; do
    deploy=$(kubectl -n backend get deploy --selector=comp-name=rpc-auth -o jsonpath='{.items[*].metadata.name}')
    if [ -z "$deploy" ]; then
      echo "cannot find deploy"
      return 1
    fi
    kubectl -n backend port-forward deployment/"$deploy" 8080
    sleep 3
  done
}

kget() {
  if [ -z "$1" ]; then
    echo "Usage: kget [type]"
    return 1
  fi

  kubectl get "$1" --all-namespaces
}

clear_tags() {
  for i in $(cat /tmp/tags.txt); do git push --delete origin refs/tags/$i; done
}

refresh_tags() {
  git tag -l | xargs git tag -d && git fetch -t
}
