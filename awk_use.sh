awk '{print $1, $3}' netstat.txt
awk '{printf "%-8s %-8s %-8s %-18s %-22s %-15s\n",$1,$2,$3,$4,$5,$6}' netstat.txt
awk '$3 == 0 && $6 == "LAST_ACK"' netstat.txt
awk '$3 > 0 && NR != 1 {print $3}' netstat.txt
awk 'BEGIN{FS=":"} {print $1,$3,$6}' semi_colon_FS #awk -F: '{print $1,$3,$6}' semi_colon_FS
awk '/WAIT/' netstat.txt
awk 'NR != 1 {print > $6}' netstat.txt
awk 'NR!=1{a[$6]++;} END {for (i in a) print i ", " a[i];}' netstat.txt
cat shuf.txt | awk 'BEGIN{srand()} {print rand() "\t" $0}' | sort -n | cut -f2- #shuffle一个文件

awk内建变量
$0  当前记录（这个变量中存放着整个行的内容）
$1~$n 当前记录的第n个字段，字段间由FS分隔
FS  输入字段分隔符 默认是空格或Tab
NF  当前记录中的字段个数，就是有多少列
NR  已经读出的记录数，就是行号，从1开始，如果有多个文件话，这个值也是不断累加中。
FNR 当前记录数，与NR不同的是，这个值会是各个文件自己的行号
RS  输入的记录分隔符， 默认为换行符
OFS 输出字段分隔符， 默认也是空格
ORS 输出的记录分隔符，默认为换行符
FILENAME 当前输入文件的名字
ARGC 命令行参数个数
ARGV 命令行参数排列
ENVIRON 支持队列中系统环境变量的使用

BEGIN{这里面放的是执行前的语句}
END{这里面放的是处理完所有的行后要执行的语句}
{这里面放的是处理每一行时要执行的语句}
