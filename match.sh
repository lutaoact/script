#!/usr/local/bin/bash -xv

for i in *; do
    if [[ "$i" =~ .*me.* ]]; then
        echo $i
    fi
done
