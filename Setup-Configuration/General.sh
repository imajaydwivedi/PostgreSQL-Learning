# Location of postgresql.conf and pg_hba.conf on an Ubuntu server
# Where does PostgreSQL store configuration/conf files?
  # https://serverfault.com/questions/152942/location-of-postgresql-conf-and-pg-hba-conf-on-an-ubuntu-server
  # https://serverfault.com/a/877213
  # https://stackoverflow.com/a/3603162
export PGPASSWORD='<password>'
> psql -U postgres
=# show hba_file;
=# show config_file;


# Change postgres role password when forgot it
  # https://askubuntu.com/a/594002
sudo -u postgres psql
ALTER USER postgres PASSWORD 'newpassword';

# Locate config file within connecting to Postgres
(base) saanvi@ryzen9:~/Github/PostgreSQL-Learning$ sudo -u postgres psql -c 'SHOW config_file'
               config_file               
-----------------------------------------
 /etc/postgresql/14/main/postgresql.conf
(1 row)



# connect to PostgreSQL server: FATAL: no pg_hba.conf entry for host
  # https://dba.stackexchange.com/a/84002

Add or edit the following line in your postgresql.conf :

listen_addresses = '*'
Add the following line as the first line of pg_hba.conf. It allows access to all databases for all users with an encrypted password:

# TYPE DATABASE USER CIDR-ADDRESS  METHOD
host  all  all 0.0.0.0/0 scram-sha-256
Restart Postgresql after adding this with service postgresql restart or the equivalent command for your setup. For brew, brew services restart postgresql


# Connect to Postgres using password
export PGPASSWORD='<password>'
> psql -h localhost -U postgres

# Upgrade postgres repository configuration for Ubuntu to latest
https://www.postgresql.org/download/linux/ubuntu/
(base) saanvi@ryzen9:~$ sudo apt install postgresql-client-16

# Get Postgres tools path on Ubuntu
dpkg -l | grep postgres

# Below is path of pg_dump on Ubuntu
/usr/lib/postgresql/16/bin/pg_dump

# Find/Save current pg_dump settings/links
(base) saanvi@ryzen9:~/Github/PostgreSQL-Learning$ ls -l /usr/bin/ | grep pg_dump
lrwxrwxrwx 1 root root           37 Feb 10  2022 pg_dump -> ../share/postgresql-common/pg_wrapper
lrwxrwxrwx 1 root root           37 Feb 10  2022 pg_dumpall -> ../share/postgresql-common/pg_wrapper

# Overwrite pg_dump link to reflect latest pg_dump version
sudo ln -sfn /usr/lib/postgresql/16/bin/pg_dump /usr/bin/pg_dump


