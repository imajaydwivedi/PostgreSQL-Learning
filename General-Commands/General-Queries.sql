-- Get database size
SELECT pg_size_pretty(pg_database_size(current_database())) AS database_size;


/* Get Tables & Row Counts */
WITH tbl AS
  (SELECT table_schema,
          TABLE_NAME
   FROM information_schema.tables
   WHERE TABLE_NAME not like 'pg_%'
     --AND table_schema in ('postgres_air')
     )
SELECT table_schema,
       TABLE_NAME,
       (xpath('/row/c/text()', query_to_xml(format('select count(*) as c from %I.%I', table_schema, TABLE_NAME), FALSE, TRUE, '')))[1]::text::int AS rows_n
FROM tbl
ORDER BY rows_n DESC
LIMIT 20;



/* Get Indexes with Size */
SELECT
    t.tablename,
    indexname,
    c.reltuples AS num_rows,
    pg_size_pretty(pg_relation_size(quote_ident(t.tablename)::text)) AS table_size,
    pg_size_pretty(pg_relation_size(quote_ident(indexrelname)::text)) AS index_size,
    CASE WHEN indisunique THEN 'Y'
       ELSE 'N'
    END AS UNIQUE
    --idx_scan AS number_of_scans,
    --idx_tup_read AS tuples_read,
    --idx_tup_fetch AS tuples_fetched
FROM pg_tables t
LEFT OUTER JOIN pg_class c ON t.tablename=c.relname
LEFT OUTER JOIN
    ( SELECT c.relname AS ctablename, ipg.relname AS indexname, x.indnatts AS number_of_columns, idx_scan, idx_tup_read, idx_tup_fetch, indexrelname, indisunique FROM pg_index x
           JOIN pg_class c ON c.oid = x.indrelid
           JOIN pg_class ipg ON ipg.oid = x.indexrelid
           JOIN pg_stat_all_indexes psai ON x.indexrelid = psai.indexrelid )
    AS foo
    ON t.tablename = foo.ctablename
WHERE 1=1
--AND t.schemaname = 'postgres_air'
ORDER BY 1,2;


/* Get Indexes & Details */
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