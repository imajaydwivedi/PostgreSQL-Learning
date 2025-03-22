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