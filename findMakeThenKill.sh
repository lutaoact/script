ps axo 'user,pid,command' | grep 'make run_local_hms' | grep -v 'grep' | awk '{print $2}' | xargs kill
