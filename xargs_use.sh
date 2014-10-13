file -Lz * | grep text | cut -d: -f1 | xargs -t -I {} cp {} {}.bak
