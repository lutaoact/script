suffix="$(date +'%Y%m%d%H%M%S')"
echo "suffix is: $suffix"

backup_path="development_$suffix"
echo "remote backup_path is: $backup_path"

backup_tar_gz="${backup_path}.tar.gz"
echo "backup_tar_gz is: $backup_tar_gz"

remote_cmd="cd /root && mongodump -d development -o $backup_path && tar cvfz $backup_tar_gz $backup_path"
echo "remote_cmd: $remote_cmd"

ssh dd "$remote_cmd"
scp dd:"/root/$backup_tar_gz" "/data/backup"
cd /data/backup
tar xvfz $backup_tar_gz
mongorestore --drop -d development "$backup_path/development/"
