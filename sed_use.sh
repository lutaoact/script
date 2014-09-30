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
