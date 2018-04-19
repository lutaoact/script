echo $@

# 两个连续的dash表示将$@设置为--后面的内容
set -- *

echo $@
