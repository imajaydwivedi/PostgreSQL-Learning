export PGPASSWORD='<password>';

# Restore Sample Database from *.tar File
/PostgreSQL/14/bin> pg_restore -h localhost -d dvdreThishown postgres:postgres /vm-storage-01/pg_data

postgres=# create tablespace vm_storage_01 owner postgres location '/vm-storage-01/pg_data';
postgres=# create database stackoverflow with owner=postgres TABLESPACE=vm_storage_01;

postgres=# 

postgres=# set default_tablespace=vm_storage_01;
SET
postgres=# 

/PostgreSQL/14/bin> pg_restore -h localhost -d stackoverflow /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/stackoverflow.tar

pg_restore -h localhost -d stackoverflow -U postgres -v 'E:\Share\stackoverflow-postgres-2010\dump-stackoverflow2010.sql'

# restore postgres_air from pg_dump backup
pg_restore -h localhost -d postgres_air -U postgres /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/postgres_air/postgres_air_2023.backup
pg_restore -h officelaptop -d postgres_air -U postgres /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/postgres_air/postgres_air_2023.backup

# method 02: simply execute following query in Query Window
/stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/postgres_air/postgres_air_2023.sql

