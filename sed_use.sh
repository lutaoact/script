sed -i '' "s/my/Hao Chen's/" pets.txt
sed -i '' "3s/my/your/" pets.txt
sed -i '' "3,6s/my/your/" pets.txt #只替换第3到第6行的文本
sed -iold '1i\'$'\n''text to prepend'$'\n' file.txt

#         sed -iold '1i\'$'\n''text to prepend'$'\n' file.txt
#                      ^^^^^^^^                     ^
#                     / |\|||/ \                    |__ No need to reopen
#                     | | \|/  |                          string to sed
#     Tells sed to    | |  |   |
#    escape the next _/ |  |   +-----------------------------+
#         char          |  +-------------+                   |
#                       |                |                   |
#                  Close string   The  special bash   Reopen string to
#                     to sed       newline char to      send to sed
#                                    send to sed

sed 's/s/\'$'\n''xxx/2;h;s/s/xxx/g;H;g;s/\n.*\n//' my.txt
sed -i '' "1i\\"$'\n'"This is my monkey, my monkey's name is wukong"$'\n' my.txt
sed -i '' "$ a \\"$'\n'"This is my monkey, my monkey's name is wukong"$'\n' my.txt
sed -i '' "/fish/i\\"$'\n'"This is my monkey, my monkey's name is wukong"$'\n' my.txt
sed -i '' "2c \\"$'\n'"This is my monkey, my monkey's name is wukong"$'\n' my.txt
sed -i '' -n '/cat/,/fish/p' my.txt
sed '1!G;h;$!d' t.txt #反转一个文件的行
sed -i '' 'N; s/\n  /, /' pets.txt #将两行合并，并用逗号分开
sed -e 3,6{ -e /This/d -e } pets.txt
sed '3,6{/This/d;}' pets.txt #BSD sed, must add semi-colon
sed -f 3_6 pets.txt #use file
sed -i '' '3,6 {/This/{/fish/d;};}' pets.txt
sed -i '' '1,${/This/d;s/^ *//g;}' pets.txt
sed -i '' -E '/dog/{N;N;N;s/(^|\n)/&# /g;}' pets.txt #BSD sed
sed -i '' '/dog/,+3s/^/# /g' pets.txt #GNU sed
sed = pets.txt | sed 'N;s/\n/'$'\t''/' > line_num_pets.txt
sed = my.txt | sed 'N; s/^/    /; s/\(.\{5,\}\)\n/\1 /' #对文件中的所有行编号（行号在左，文字左端对齐）。
#sed = my.txt | sed -E 'N; s/(.*)\n/    \1 /' #貌似，我也可以这么写
sed '/'"$name"'/,/};/d' back_slash.txt
#$'\t' 在shell中输入tab键。或者先按Ctrl-V，然后再按Tab键
sed '/^p/{N;N;N;N;s/\n//g;}' sed_five_line.txt
sed '/^p/{N;N;N;N;s/\n/ /g;}' sed_five_line.txt
gsed -f gsed_convert_for_wind  -i *.txt #利用脚本处理文本
gsed '1~2G' -i *.txt #奇数行后加空行

#sed 之添加空行
一、每行前后添加空行
1.每行后面添加一行空行：
  sed 'G' tmpfile
 每行前面添加一行空行：
  sed '{x;p;x;}' tmpfile
2.每行后面添加两行空行：
  sed 'G;G' tmpfile
 每行前面添加两行空行：
  sed '{x;p;p;x;}' tmpfile
3.每行后面添加三行空行：
  sed 'G;G;G' tmpfile
  每行前面添加三行空行：
  sed '{x;p;p;p;x;}' tmpfile
以此类推。
二、如果行后有空行，则删除，然后每行后面添加空行
sed '/^$/d;G' tmpfile
三、在匹配行前后添加空行
sed '/shui/G' tmpfile  如果一行里面有shui这个单词，那么在他后面会添加一个空行
sed '/shui/{x;p;x;G}' tmpfile 如果一行里面有shui这个单词，那么在他前后各添加一个空行
sed '/shui/{x;p;x;}' tmpfile 如果一行里面有shui这个单词，那么在他前面添加一个空行
sed '1{x;p;x;}' tmpfile 在第一行前面添加空行，想在第几行，命令中的1就改成几
sed '1G' tmpfile 在第一行后面添加空行，想在第几行，命令中的1就改成几
四、每几行后面添加一个空行
1.每两行后面增加一个空行
  sed 'N;/^$/d;G' file.txt
 每两行前面添加一个空行
  sed 'N;/^$/d;{x;p;x;}' tmpfile
2.每三行后面增加一个空行
  sed 'N;N;/^$/d;G' file.txt
  每三行前面增加一个空行
  sed 'N;N;/^$/d;{x;p;x;}' tmpfile
五、以x为开头或以x为结尾的行前后添加空行
1.以xi为开头的行后面添加空行
 sed '/^xi/G;' tmpfile
 以xi为结尾的行前面添加空行
 sed '/^xi/{x;p;x;}' tmpfile
2.以xi为结尾的行后面添加空行
 sed '/xi$/G;' tmpfile
 以xi为结尾的行后面添加空行
 sed '/xi$/{x;p;x;}' tmpfile
如果有错误的地方，麻烦各位帮忙指正，谢谢！
