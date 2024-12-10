/*
-- reload cluster settings
select pg_reload_conf();
*/

select r.line_number, r.type, r.database, r.user_name,
        r.address, r.netmask, r.auth_method, r.file_name
from pg_hba_file_rules as r;