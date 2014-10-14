file -Lz * | grep text | cut -d: -f1 | xargs -t -I {} cp {} {}.bak #-I的值会用来替换成命令的参数
ls | xargs -t -n2 ls -ltr #-n每次只传指定个数的参数给后续命令
