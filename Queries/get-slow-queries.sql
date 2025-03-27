/*  https://www.cybertec-postgresql.com/en/find-and-fix-a-missing-postgresql-index/
    https://www.postgresql.org/docs/current/pgstatstatements.html#PGSTATSTATEMENTS
*/
SELECT *
FROM   pg_stat_statements 
ORDER BY total_exec_time DESC;

--create extension pg_stat_statements;