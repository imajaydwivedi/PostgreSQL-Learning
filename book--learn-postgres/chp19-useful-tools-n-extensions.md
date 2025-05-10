# Using foreign data wrappers and the postgres_fdw extension
### [List of foreign data wrapper](https://wiki.postgresql.org/wiki/Foreign_data_wrappers)


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

