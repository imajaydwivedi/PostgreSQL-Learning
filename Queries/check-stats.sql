select *
from pg_stats
where schemaname = 'public' and tablename = 'posts'
