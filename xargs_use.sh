file -Lz * | grep text | cut -d: -f1 | xargs -t -I {} cp {} {}.bak #-I的值会用来替换成命令的参数
