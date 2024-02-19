export PGPASSWORD='<password>';

# Restore Sample Database from *.tar File
/PostgreSQL/14/bin> pg_restore -h localhost -d dvdrental /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/dvdrental.tar

# Backup database
(base) saanvi@ryzen9:~$ pg_dump -U postgres -h localhost -d forumdb -F tar -f /stale-storage/Softwares/PostgreSQL/PostgreSQL-Sample-Dbs/forumdb.tar

