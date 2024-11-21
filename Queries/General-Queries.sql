/*  Some links with Queries 
**  https://gist.github.com/mencargo/79447185034ebabcb49087008fbdc266#table-sizes
**  
*/

-- Get database size
SELECT d.datname as database_name, pg_size_pretty(pg_database_size(d.datname)) AS database_size
FROM pg_database d
WHERE d.datistemplate = false
ORDER BY pg_database_size(d.datname) DESC;

-- kill running query
SELECT pg_cancel_backend(procpid);

-- kill idle query
SELECT pg_terminate_backend(procpid);

-- vacuum command
VACUUM (VERBOSE, ANALYZE);

-- all database users
select * from pg_stat_activity where query not like '<%';

-- all databases and their sizes
select * from pg_user;

-- all tables and their size, with/without indexes
select datname, pg_size_pretty(pg_database_size(datname))
from pg_database
order by pg_database_size(datname) desc;

-- cache hit rates (should not be less than 0.99)
SELECT sum(heap_blks_read) as heap_read, sum(heap_blks_hit)  as heap_hit, (sum(heap_blks_hit) - sum(heap_blks_read)) / sum(heap_blks_hit) as ratio
FROM pg_statio_user_tables;

-- table index usage rates (should not be less than 0.99)
SELECT relname, 100 * idx_scan / (seq_scan + idx_scan) percent_of_times_index_used, n_live_tup rows_in_table
FROM pg_stat_user_tables 
ORDER BY n_live_tup DESC;

-- how many indexes are in cache
SELECT sum(idx_blks_read) as idx_read, sum(idx_blks_hit)  as idx_hit, (sum(idx_blks_hit) - sum(idx_blks_read)) / sum(idx_blks_hit) as ratio
FROM pg_statio_user_indexes;

-- Find cardinality of index
SELECT schema_name,
       object_name,
       object_type,
       cardinality,
       pages
FROM (
       SELECT pg_catalog.pg_namespace.nspname AS schema_name,
              relname                         as object_name,
              relkind                         as object_type,
              reltuples                       as cardinality,
              relpages                        as pages
       FROM pg_catalog.pg_class
              JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
     ) t
WHERE schema_name NOT LIKE 'pg_%'
  and schema_name <> 'information_schema'
  --and schema_name = '$schema_name'
  --and object_name = '$object_name'
ORDER BY pages DESC, schema_name, object_name
;

-- Find Table/Index Usage
  -- https://github.com/SmartPostgres/Box-of-Tricks/blob/dev/checks/check_indexes.sql
select * from check_indexes('public','users');


-- Restart all sequences
SELECT 'ALTER SEQUENCE ' || relname || ' RESTART;' FROM pg_class WHERE relkind = 'S';

-- Dump database on remote host to file
$ pg_dump -U username -h hostname databasename > dump.sql

-- Import dump into existing database
$ psql -d newdb -f dump.sql


/* Get Tables & Row Counts */
WITH RECURSIVE pg_inherit(inhrelid, inhparent) AS
    (select inhrelid, inhparent
    FROM pg_inherits
    UNION
    SELECT child.inhrelid, parent.inhparent
    FROM pg_inherit child, pg_inherits parent
    WHERE child.inhparent = parent.inhrelid),
pg_inherit_short AS (SELECT * FROM pg_inherit WHERE inhparent NOT IN (SELECT inhrelid FROM pg_inherit))
SELECT Schema_Name, TABLE_NAME
    , row_estimate
    , pg_size_pretty(total_bytes) AS total_size
    , pg_size_pretty(table_bytes) AS table_size
    , pg_size_pretty(toast_bytes) AS toast_size
    , pg_size_pretty(index_bytes) AS index_size
  FROM (
    SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes
    FROM (
         SELECT c.oid
              , nspname AS Schema_Name
              , relname AS TABLE_NAME
              , TO_CHAR(c.reltuples, 'FM999,999,999,999') AS row_estimate
              , SUM(pg_total_relation_size(c.oid)) OVER (partition BY parent) AS total_bytes
              , SUM(pg_indexes_size(c.oid)) OVER (partition BY parent) AS index_bytes
              , SUM(pg_total_relation_size(reltoastrelid)) OVER (partition BY parent) AS toast_bytes
              , parent
          FROM (
                SELECT pg_class.oid
                    , reltuples
                    , relname
                    , relnamespace
                    , pg_class.reltoastrelid
                    , COALESCE(inhparent, pg_class.oid) parent
                FROM pg_class
                    LEFT JOIN pg_inherit_short ON inhrelid = oid
                WHERE relkind IN ('r', 'p', 'm')
             ) c
             LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE nspname NOT IN ('pg_catalog','information_schema')
  ) a
  WHERE oid = parent
) a
ORDER BY total_bytes DESC;


/* All elements sizes */
select  pg_namespace.nspname as schema_name,
        relkind as type,
        relname as name,
        pg_size_pretty(pg_relation_size(pg_catalog.pg_class.oid)) as size,
        TO_CHAR(reltuples, 'FM999,999,999,999') AS rows
from pg_catalog.pg_class
join pg_catalog.pg_namespace on relnamespace = pg_catalog.pg_namespace.oid
where pg_catalog.pg_namespace.nspname not in ('pg_catalog','pg_toast','information_schema')
order by relkind desc, relname desc;


/* Get Indexes & Attributes */
SELECT
  --U.usename                AS user_name,
  --ns.nspname               AS schema_name,
  idx.indrelid :: REGCLASS AS table_name,
  i.relname                AS index_name,
  idx.indisunique          AS is_unique,
  idx.indisprimary         AS is_primary,
  am.amname                AS index_type,
  --idx.indkey,
       ARRAY(
           SELECT pg_get_indexdef(idx.indexrelid, k + 1, TRUE)
           FROM
             generate_subscripts(idx.indkey, 1) AS k
           ORDER BY k
       ) AS index_keys,
  (idx.indexprs IS NOT NULL) OR (idx.indkey::int[] @> array[0]) AS is_functional,
  idx.indpred IS NOT NULL AS is_partial
FROM pg_index AS idx
  JOIN pg_class AS i
    ON i.oid = idx.indexrelid
  JOIN pg_am AS am
    ON i.relam = am.oid
  JOIN pg_namespace AS NS ON i.relnamespace = NS.OID
  JOIN pg_user AS U ON i.relowner = U.usesysid
WHERE 1=1
and nspname = 'public' -- Excluding system tables
LIMIT 20;