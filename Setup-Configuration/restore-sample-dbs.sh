export PGPASSWORD='<password>';

# Restore Sample Database from *.tar File
/PostgreSQL/14/bin> pg_restore -h localhost -d dvdreThishown postgres:postgres /vm-storage-01/pg_data

postgres=# create tablespace vm_storage_01 owner postgres location '/vm-storage-01/pg_data';
postgres=# create database stackoverflow with owner=postgres TABLESPACE=vm_storage_01;

postgres=# 

postgres=# set default_tablespace=vm_storage_01;
SET
postgres=# 

/PostgreSQL/14/bin> pg_restore -h localhost -d stackoverflow /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/stackoverflow.tar -v

