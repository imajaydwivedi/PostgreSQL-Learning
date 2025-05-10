# Using foreign data wrappers and the postgres_fdw extension
### [List of foreign data wrapper](https://wiki.postgresql.org/wiki/Foreign_data_wrappers)

## fetch data from ryzen9
```
ansible@pgpoc:~$ psql -h localhost -U postgres

\c forum_shell

set search_path to forum;

create extension postgres_fdw;

CREATE SERVER remote_ryzen9 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'ryzen9', dbname 'forumdb');
\des

create role forum with login password 'LearnPostgreSQL';
\dg

create schema forum;

CREATE USER MAPPING FOR forum SERVER remote_ryzen9 OPTIONS (user 'forum', password 'LearnPostgreSQL');
\deu

create foreign table forum.f_categories (pk integer, title text, description text)
SERVER remote_ryzen9 OPTIONS (schema_name 'forum', table_name 'categories');

GRANT USAGE ON SCHEMA forum TO forum;
grant SELECT ON forum.f_categories to forum;

\q

psql -h localhost -U forum -d forum_shell

select * from f_categories;

```

# Exploring pg_trgm extension

```
\c forumdb

set enable_seqscan to 'off';

explain analyze select * from categories where title like 'Da%';

create index categories_title_btree on categories using btree (title varchar_pattern_ops);

explain analyze select * from categories where title like 'Da%';
explain analyze select * from categories where title like '%Da%';

create extension pg_trgm;

create index categories_title_trgm on categories using gin (title gin_trgm_ops);

\d categories
\di *categories*

explain analyze select * from categories where title like 'Da%';
explain analyze select * from categories where title like '%Da%';


# Clean up
\d categories

DROP INDEX IF EXISTS categories_title_btree;
DROP INDEX IF EXISTS categories_title_trgm;

DROP EXTENSION IF EXISTS pg_trgm;

RESET enable_seqscan;

```

