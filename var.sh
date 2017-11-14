#!/bin/bash -xv

# 间接引用
t=table_cell_3
table_cell_3=24
echo "\"table_cell_3\" = $table_cell_3"            # "table_cell_3" = 24
echo -n "dereferenced \"t\" = "; eval echo \$$t    # 解引用 "t" = 24
# 在这个简单的例子中, 下面的表达式也能正常工作么(为什么?).
         eval t=\$$t; echo "\"t\" = $t"
