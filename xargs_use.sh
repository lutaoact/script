file -Lz * | grep text | cut -d: -f1 | xargs -t -I {} cp {} {}.bak #-I的值会用来替换成命令的参数
ls | xargs -t -n2 ls -ltr #-n每次只传指定个数的参数给后续命令

# xargs 命令读取标准的输入，然后使用参数作为输入构建和执行命令。如果没有给出命令，那么将使用 echo 命令。
# 默认情况下，xargs 在空格处中断输出，并且每个生成的标记都成为一个参数。不过，当 xargs 构建命令时，它将一次传递尽可能多的参数。您可以使用 -n 覆盖该行为。
xargs < text1 -n1 echo "args>"
