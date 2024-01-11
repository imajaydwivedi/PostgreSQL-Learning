# Location of postgresql.conf and pg_hba.conf on an Ubuntu server
  # https://serverfault.com/questions/152942/location-of-postgresql-conf-and-pg-hba-conf-on-an-ubuntu-server
  # https://serverfault.com/a/877213
export PGPASSWORD='<password>'
> psql -U postgres
=# show hba_file;
=# show config_file;


# connect to PostgreSQL server: FATAL: no pg_hba.conf entry for host
  # https://dba.stackexchange.com/a/84002

Add or edit the following line in your postgresql.conf :

listen_addresses = '*'
Add the following line as the first line of pg_hba.conf. It allows access to all databases for all users with an encrypted password:

# TYPE DATABASE USER CIDR-ADDRESS  METHOD
host  all  all 0.0.0.0/0 scram-sha-256
Restart Postgresql after adding this with service postgresql restart or the equivalent command for your setup. For brew, brew services restart postgresql

