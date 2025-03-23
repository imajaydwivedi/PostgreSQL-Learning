# set autovacuum off
show autovacuum;
\x
select name, setting, context, pending_restart from pg_settings where name = 'autovacuum';

alter system set autovacuum = off;

select name, setting, context, pending_restart from pg_settings where name = 'autovacuum';

select pg_reload_conf();

select name, setting, context, pending_restart from pg_settings where name = 'autovacuum';
