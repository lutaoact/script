#!/bin/bash
# 兼容run_local_hms和run_local_hub
ps axo 'user,pid,command' | grep "make run_local_$1" | grep -v 'grep' | awk '{print $2}' | xargs kill
