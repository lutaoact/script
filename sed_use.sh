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
