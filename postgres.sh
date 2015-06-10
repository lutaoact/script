createuser --superuser -echo sequelize #创建超级用户
createdb --username=sequelize development #利用sequelize用户创建数据库development

\l #mysql> show databases;
\dt #mysql> show tables;
\d tableName; #mysql> desc tableName;
\di #mysql> show index from databaseName;

select pg_database_size('playboy'); #查看playboy数据库的大小
select pg_database.datname, pg_database_size(pg_database.datname) AS size from pg_database; #查看所有数据库的大
select pg_size_pretty(pg_database_size('playboy')); #以KB，MB，GB的方式来查看数据库大小  
select spcname from pg_tablespace; #查看所有表空间
