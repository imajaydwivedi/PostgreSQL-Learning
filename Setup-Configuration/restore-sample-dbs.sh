export PGPASSWORD='<password>';

# Restore Sample Database from *.tar File
/PostgreSQL/14/bin> pg_restore -h localhost -d dvdrental /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/dvdrental.tar
/PostgreSQL/14/bin> pg_restore -h localhost -d forumdb /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/forumdb.tar

# Backup database
(base) saanvi@ryzen9:~$ pg_dump -U postgres -h localhost -d forumdb -F tar -f /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/forumdb.tar

pg_dump -U readonly -W '511e0479-4d35-49ab-98b1-c3a9d69796f4' -h query.smartpostgres.com -d stackoverflow -F tar -f ~/Downloads/stackoverflow.tar
pg_dump --dbname=postgresql://readonly:511e0479-4d35-49ab-98b1-c3a9d69796f4@query.smartpostgres.com/stackoverflow -F tar -f ~/Downloads/stackoverflow.tar


# Restore StackOverflow in custom tablespace
saanvi@ryzen9:~/Github/PostgreSQL-Learning$ mkdir /vm-storage-01/pg_data
saanvi@ryzen9:~/Github/PostgreSQL-Learning$ sudo chown postgres:postgres /vm-storage-01/pg_data

postgres=# create tablespace vm_storage_01 owner postgres location '/vm-storage-01/pg_data';
postgres=# create database stackoverflow with owner=postgres TABLESPACE=vm_storage_01;

postgres=# 

postgres=# set default_tablespace=vm_storage_01;
SET
postgres=# 

/PostgreSQL/14/bin> pg_restore -h localhost -d stackoverflow /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/stackoverflow.tar -v

