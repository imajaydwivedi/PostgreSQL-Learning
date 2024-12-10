/*
-- reload cluster settings
select pg_reload_conf();

-- pg_hba.conf settings can be found in [Security/users-roles.sql]
*/

select r.line_number, r.type, r.database, r.user_name,
        r.address, r.netmask, r.auth_method, r.file_name
from pg_hba_file_rules as r;