export PGPASSWORD='<password>';

# Restore Sample Database from *.tar File
/PostgreSQL/14/bin> pg_restore -h localhost -d dvdrental /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/dvdrental.tar

# Backup database
(base) saanvi@ryzen9:~$ pg_dump -U postgres -h localhost -d forumdb -F tar -f /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/forumdb.tar

pg_dump -U readonly -W '511e0479-4d35-49ab-98b1-c3a9d69796f4' -h query.smartpostgres.com -d stackoverflow -F tar -f ~/Downloads/stackoverflow.tar
pg_dump --dbname=postgresql://readonly:511e0479-4d35-49ab-98b1-c3a9d69796f4@query.smartpostgres.com/stackoverflow -F tar -f ~/Downloads/stackoverflow.tar
