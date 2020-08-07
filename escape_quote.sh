
#echo "$str"
#perl -ne "s/\"|'|\\/\$&/"
#perl -pe 's/"|\047|\134/\134$&/g' <<< "$str"
perl -pe 's/"|\047|\134/\134$&/g;s/\n/\\n/g' <<< "$str"
#perl -ne 's/"/\\$&/g' <<< "$str"
#str2=$(perl -pe 's/"/\134$&/g' <<< "$str")

#perl -pe 's/"/\\$&/g;' <<< "$str"
#grep 'Pod' <<< "$str"

#mysql -e 'insert into table1(id, value) values(1, \'"$json"');'
echo "insert into table1(id, value) values(1, '"\""$str"');'

create table a(
  id int AUTO_INCREMENT,
  value text,
  PRIMARY KEY (`id`)
);

echo 'insert into table1(id, value) values(1, "'"$str2"'");'
#mysql -uroot -pmy-secret-pw -h127.0.0.1 -P32777 -Dtest -e 'insert into table1(id, value) values(1, "'\'$'\n''");'

str=$(cat 'test.yaml')
str2=$(perl -pe 's/\n/\\n/g;s/"|\047|\134/\134$&/g;' <<< "$str")
mysql -uroot -p -h127.0.0.1 -P32777 -Dtest -e 'insert into a(id, value) values(1, "'"$str2"'");'

str=$(perl -pe 's/"|\047|\134/\134$&/g' <(cat 'test.yaml'))
mysql -uroot -p -h127.0.0.1 -P32777 -Dtest -e 'insert into a(id, value) values(1, "'"$str"'");'

str='{"b":"a\nb\nc"}'
str2=$(perl -pe 's/"|\047|\134/\134$&/g;' <<< "$str")
mysql -uroot -pmy-secret-pw -h127.0.0.1 -P32777 -Dtest -e 'insert into a(value) values("'"$str2"'");'
mysql -uroot -pmy-secret-pw -h127.0.0.1 -P32777 -Dtest
