-- Get database size
SELECT pg_size_pretty(pg_database_size(current_database())) AS database_size;