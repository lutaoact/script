
#function tailmf() {
#  tail -f "$@" |
#      awk '/^==> / {a=substr($0, 5, length-8); next}
#                   {print a":"$0}'
#}
# tailmf /data/log/gpws.log /data/log/polipo.log
# 用这条命令可以完成同样的功能
# parallel --tagstring '{}:' --line-buffer tail -f {} ::: gpws.log polipo.log

#
#function render() {
#  python render.py --template global --values cluster/$1/global.ini cluster/$1/global_s.ini --output .
#}
#
#function kevm() {
#  export KUBECONFIG=~/me/newevm_k8s_admin.conf
#  alias k='kubectl -n kube-system'
#}
#

# function qyg() {
#   qingcloud "$@" -f ~/private-config/qingcloud_config.yaml
# }
# 
# function qyw() {
#   qingcloud "$@" -f ~/private-config/qingcloud_config_wind.yaml
# }
# 
# function rediscome() {
#   if [ $# -ne 2 ]; then
#     echo "Usage: rediscome n key"
#     echo "\tn is database number"
#     echo "\tkey is redis number"
#     return 1
#   fi
#   n=$1
#   key=$2
#   ssh node "\redis-cli -h mongo -n $n --raw dump $2" | head -c-1 | \redis-cli -n $n -x restore $key 0
# }
# 
# function redis1come() {
#   if [ -z "$1" ]; then
#     echo "Usage: redis1come key"
#     echo "redis key is required"
#     return 1
#   fi
#   rediscome 1 "$1"
# }
# 
# function mkdircd () {
#   mkdir -p "$@" && eval cd "\"\$$#\""
# }
# 
# function sort_lines_by_length {
#   if [ -z "$1" ]; then
#     echo "collection name is required"
#     exit 1
#   fi
#   cp "$1" /tmp/$(basename "$1")
#   awk '{print length, $0}' "$1" | sort -nk1 -s | cut -d" " -f2- > "${1}.tmp"
#   mv "${1}.tmp" "$1"
# }
# 
# function gbk2utf8 {
# #  j="${1}_tmp"
# #  iconv -f GBK -t UTF-8 "$1" > "$j"
# #  mv "$j" "$1"
#   perl ~/perl/gbk2utf8.pl "$@" && dos2unix -r "$@"
# }
# 
# function svn_ci {
#   dir=$(pwd)
#   cd ~/Service/trunk/node-server/ && svn update
#   #rsync的源路径如果以/结尾，表示同步目录里面的内容，如果没有/，则会将目录同步过去
#   rsync --recursive --verbose --exclude=.git \
#       --exclude=.gitignore \
#       --exclude-from="$dir"/.gitignore \
#       "$dir"/ ~/Service/trunk/node-server/
# #  rsync -r --quiet --exclude=.git --exclude=scripts --exclude=.gitignore --exclude-from="$dir"/.gitignore "$dir"/ ~/Service/trunk/node-server/
#   svn add --force .
#   svn ci -m "$1"
#   cd $dir
# }
# 
# function sync_to {
#   if [ -z "$1" ]; then
#     echo "collection name is required"
#     exit 1
#   fi
#   mongodump -h 127.0.0.1 -p 27017 -d gpws-dev -c "$1" --archive --gzip | \
#     ssh dev "mongorestore -h 127.0.0.1 -p 27017 --archive --gzip"
# }
# 
# function sync_to_pdt {
#   if [ -z "$1" ]; then
#     echo "collection name is required"
#     exit 1
#   fi
#   mongodump -h 127.0.0.1 -d gpws-dev -c $1 --out - | ssh node \
#     "mongorestore -h gpws/mongo,mongoB,mongoD -d gpws -c $1 --dir -"
# }
# 
# function sync_from_pdt {
#   if [ -z "$1" ]; then
#     echo "collection name is required"
#     exit 1
#   fi
#   ssh node "mongodump -h mongo -d gpws -c $1 --archive --gzip" | \
#     mongorestore --nsFrom='gpws.*' --nsTo='gpws-dev.*' --archive --gzip
# }
# 
# function syncBigRes {
#   if [ -z "$1" ]; then
#     echo "collection name is required"
#     exit 1
#   fi
#   ssh node "mongodump -h mongoB -d bigRes -c $1 --archive --gzip" | \
#     mongorestore --archive --gzip
# }
# 
# function syncBigResToFile {
#   if [ -z "$1" ]; then
#     echo "collection name is required"
#     exit 1
#   fi
#   ssh node "mongodump --host mongoB --port 37019 -d bigRes -c $1 --archive --gzip" > $1.archive
# }
# 
# function sync_from {
#   if [ -z "$1" ]; then
#     echo "collection name is required"
#     exit 1
#   fi
#   ssh dev "mongodump -h 127.0.0.1 -d gpws-dev -c $1 --archive --gzip" | \
#     mongorestore --archive --gzip #重复数据会报错，但程序并不结束
# }
# 
# function dump {
#   if [ -z "$1" ]; then
#     echo "collection name is required"
#     exit 1
#   fi
#   time_str=$(date +'%Y%m%d%H%M%S')
#   backup_file=${1}_${time_str}.json
#   echo -e "mongoexport -d gpws -c $1 -o /data/backup/$backup_file"
#   mongoexport -d gpws -c "$1" -o /data/backup/$backup_file
# }
# 
# function gettoken() {
#   response=$(curl -s 'http://dev.api.stockalert.cn/auth/token?appid=d8f334a0396f&sign=c452ebae5f8b7d62e3189e19a229edf284b72995')
#   # response的格式：
#   # {"message":"ok","timestamp":1491897440465,"payload":{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiJkOGYzMzRhMDM5NmYiLCJpYXQiOjE0OTE4OTc0NDAsImV4cCI6MTQ5MTk4Mzg0MH0.ZwkRvscvDMlobzuL38nW3TrT6WSjt63Pko2-ewdi734"}}
#   tmpvalue=${response%\"*} #右截取 最小匹配 *是通配符 也就是从最右边开始到第一个双引号
#   result=${tmpvalue##*\"}  #左截取 最大匹配 也就是从左边开始，直到遇到第一个双引号
#   echo $result
# }
