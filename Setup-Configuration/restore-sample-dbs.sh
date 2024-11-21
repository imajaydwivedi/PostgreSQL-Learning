export PGPASSWORD='<password>';

# Restore Sample Database from *.tar File
/PostgreSQL/14/bin> pg_restore -h localhost -d dvdrental /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/dvdrental.tar
/PostgreSQL/14/bin> pg_restore -h localhost -d forumdb /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/forumdb.tar

# Backup database
(base) saanvi@ryzen9:~$ pg_dump -U postgres -h localhost -d forumdb -F tar -f /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/forumdb.tar

# Backup smartpostgres database from internet
  # https://smartpostgres.com/posts/announcing-early-access-to-the-stack-overflow-sample-database-download-for-postgres/
pg_dump -U readonly -W '511e0479-4d35-49ab-98b1-c3a9d69796f4' -h query.smartpostgres.com -d stackoverflow -F tar -f ~/Downloads/stackoverflow.tar
pg_dump --dbname=postgresql://readonly:511e0479-4d35-49ab-98b1-c3a9d69796f4@query.smartpostgres.com/stackoverflow -F tar -f ~/Downloads/stackoverflow.tar


# Restore StackOverflow in custom tablespace
saanvi@ryzen9:~/Github/PostgreSQL-Learning$ mkdir /vm-storage-01/pg_data
saanvi@ryzen9:~/Github/PostgreSQL-Learning$ mkdir /vm-storage-02/pg_data
saanvi@ryzen9:~/Github/PostgreSQL-Learning$ sudo chown postgres:postgres /vm-storage-01/pg_data
saanvi@ryzen9:~/Github/PostgreSQL-Learning$ sudo chown postgres:postgres /vm-storage-02/pg_data

postgres=# create tablespace vm_storage_01 owner postgres location '/vm-storage-01/pg_data';
postgres=# create tablespace vm_storage_02 owner postgres location '/vm-storage-02/pg_data';

# create 2 stackoverflow dbs. [stackoverflow2010] - 6 gb size || [stackoverflow] - 117 gb size 
postgres=# create database stackoverflow2010 with owner=postgres;
postgres=# create database stackoverflow with owner=postgres TABLESPACE=vm_storage_01;


postgres=# set default_tablespace=vm_storage_01;
SET
postgres=# 

# Sample restore commands
/PostgreSQL/14/bin> pg_restore -h localhost -U postgres -d stackoverflow2010 /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/stackoverflow.tar
/PostgreSQL/14/bin> pg_restore -h localhost -U postgres -d stackoverflow -v 'E:\Share\stackoverflow-postgres-2010\dump-stackoverflow2010.sql'

# Actual restore commands
/PostgreSQL/14/bin> pg_restore -h localhost -U postgres -d stackoverflow2010 -v '/stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/stackoverflow-postgres-2010-v0.1/dump-stackoverflow2010-202408101013.sql'
/PostgreSQL/14/bin> pg_restore -h localhost -U postgres -d stackoverflow -v '/stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/stackoverflow-postgres-2024-v0.1/dump-stackoverflow-202408100709.sql'


# restore postgres_air from pg_dump backup
pg_restore -h localhost -d postgres_air -U postgres /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/postgres_air/postgres_air_2023.backup
pg_restore -h officelaptop -d postgres_air -U postgres /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/postgres_air/postgres_air_2023.backup

# method 02: simply execute following query in Query Window
/stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/postgres_air/postgres_air_2023.sql

