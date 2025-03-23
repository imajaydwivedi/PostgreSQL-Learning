-- https://www.postgresql.org/docs/current/monitoring-stats.html#MONITORING-PG-STAT-ALL-TABLES-VIEW
SELECT *
FROM pg_stat_all_tables r
where r.schemaname = 'public' and r.relname = 'posts'
limit 10;

-- https://www.postgresql.org/docs/current/monitoring-stats.html#MONITORING-PG-STATIO-ALL-TABLES-VIEW
select *
from pg_statio_all_tables tio
where tio.schemaname = 'public' and tio.relname = 'posts';

-- https://www.postgresql.org/docs/current/monitoring-stats.html#MONITORING-PG-STAT-ALL-INDEXES-VIEW
select *
from pg_stat_all_indexes i
where i.schemaname = 'public' and i.relname = 'posts' -- and i.indexrelname = 'posts_owneruserid'
limit 10;

-- https://www.postgresql.org/docs/current/monitoring-stats.html#MONITORING-PG-STATIO-ALL-TABLES-VIEW
select *
from pg_statio_all_indexes iio
where iio.schemaname = 'public' and iio.relname = 'posts';