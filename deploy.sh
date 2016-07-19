#!/bin/bash

if [ x"$1" = "xrestart" ]; then
  echo "[0;32m********************** DEV **********************[0m"
  DEV_CMD="cd ~/node-server && git pull && pm2 restart app"
  echo "$DEV_CMD"
  ssh dev "$DEV_CMD"

  PDT_CMD="cd ~/node-server9006 && git pull && pm2 restart app9006"
  echo "[0;32m********************** NODE1 **********************[0m"
  echo "$PDT_CMD"
  ssh node "$PDT_CMD"

  echo "[0;32m********************** NODE2 **********************[0m"
  echo "$PDT_CMD"
  ssh node2 "$PDT_CMD"
else
  echo "[0;32m********************** DEV **********************[0m"
  DEV_CMD="cd ~/node-server && git pull"
  echo "$DEV_CMD"
  ssh dev "$DEV_CMD"

  PDT_CMD="cd ~/node-server9006 && git pull"
  echo "[0;32m********************** NODE1 **********************[0m"
  echo "$PDT_CMD"
  ssh node "$PDT_CMD"

  echo "[0;32m********************** NODE2 **********************[0m"
  echo "$PDT_CMD"
  ssh node2 "$PDT_CMD"
fi
