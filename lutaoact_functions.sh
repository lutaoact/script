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
    deploy=$(kubectl -n backend get deploy --selector=comp-name=russell-rpc-auth -o jsonpath='{.items[*].metadata.name}')
    if [ -z "$deploy" ]; then
      echo "cannot find deploy"
      return 1
    fi
    kubectl -n backend port-forward deployment/"$deploy" 8080
    sleep 3
  done
}

russelluser() {
  while true; do
    deploy=$(kubectl -n backend get deploy --selector=comp-name=russell-rpc-user -o jsonpath='{.items[*].metadata.name}')
    if [ -z "$deploy" ]; then
      echo "cannot find deploy"
      return 1
    fi
    kubectl -n backend port-forward deployment/"$deploy" 8081:8080
    sleep 3
  done
}

cooper() {
  while true; do
    #deploy=$(kubectl -n backend get deploy --selector=comp-name=cooper-grpc-lb -o jsonpath='{.items[*].metadata.name}')
    deploy=$(kubectl -n backend get deploy --selector=comp-name=cooper-grpc-lb -o json | jq -r '.items[]|select(.status.availableReplicas>0)|.metadata.name')
    if [ -z "$deploy" ]; then
      echo "cannot find deploy"
      return 1
    fi
    kubectl -n backend port-forward deployment/"$deploy" 8082:8080
    sleep 3
  done
}

telisruby() {
  while true; do
    deploy=$(kubectl -n backend get deploy -lcomp-name=telisruby -o json | jq -r '.items[]|select(.status.availableReplicas>0)|.metadata.name')
    kubectl -n backend port-forward deployment/"$deploy" 8083:80
    sleep 3
  done
}

llspay() {
  while true; do
    deploy=$(kubectl -n backend get deploy -lcomp-name=dev-rpc-lb -o json | jq -r '.items[]|select(.status.availableReplicas>0)|.metadata.name')
    kubectl -n backend port-forward deployment/"$deploy" 8084:50066
    sleep 3
  done
}

forward_dev() {
  russelluser
  russellauth
  cooper
  telisruby
  llspay
}

klog() {
  if [ -z "$1" ]; then
    echo "Usage: klog [pod name]"
    return 1
  fi

  if [ "$1" = "telis" ]; then
    kubectl -n algorithm logs --tail 1000 -f $(kubectl -n algorithm get po -lcluster=telis-telis-srv -o jsonpath='{.items[*].metadata.name}') -c comp
    return 0
  fi

  kubectl -n backend logs --tail 1000 -f $(kubectl -n backend get po -lcluster="telis-$1" -o jsonpath='{.items[*].metadata.name}') -c comp
}

kyaml() {
  if [ -z "$1" ]; then
    echo "Usage: kyaml [pod name]"
    return 1
  fi

  if [ "$1" = "telis" ]; then
    kubectl -n algorithm get po $(kubectl -n algorithm get po -lcluster=telis-telis-srv -o jsonpath='{.items[*].metadata.name}') -o yaml
    return 0
  fi

  kubectl -n backend get po $(kubectl -n backend get po -lcluster="telis-$1" -o jsonpath='{.items[*].metadata.name}') -o yaml
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

function mm {
  name="$1"
  cp cmd_dev.sh cmd_alidev.sh
  perl -i -pe 's/cluster="dev"/cluster="alidev"/' cmd_alidev.sh
  cp meta_dev.jsonnet meta_alidev.jsonnet
  cp ${name}_dev.jsonnet ${name}_alidev.jsonnet
  perl -i -pe "s/_env = 'dev'/_env = 'alidev'/" ${name}_alidev.jsonnet
}
