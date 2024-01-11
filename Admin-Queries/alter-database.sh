# Below worked for me
export PGPASSWORD='<password>'

# connect, and create a database
psql -h localhost -d postgres -U postgres
create database DBA2 with owner = 'postgres';

# rename database
ALTER DATABASE "StackOverflow" RENAME TO stackoverflow;

# change table schema
alter table users set schema dbo;

