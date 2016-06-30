function sync_from {
  if [ -z "$1" ]; then
    echo "collection name is required"
    exit 1
  fi
  date=$(date +%F)
  backup_file=${1}_$date.json
  echo "mongoexport -h mongo -d gpws -c $1 -o /data/backup/$backup_file"
  mongoexport -h mongo -d gpws -c $1 -o /data/backup/$backup_file

  echo "mongoimport -d gpws-dev -c $1 /data/backup/$backup_file"
  mongoimport -d gpws-dev -c $1 --numInsertionWorkers=4 --batchSize=100 --drop /data/backup/$backup_file
}


tables=(code_info effect_topic favor_stock_alarm \
    invitation new_stock push_token recharge redeem_code stock \
    theme theme_stock top_info)

if [ "$1" = 'all' ]; then
  for i in "${tables[@]}"
  do
    sync_from $i
  done
else
  sync_from top_info
fi
