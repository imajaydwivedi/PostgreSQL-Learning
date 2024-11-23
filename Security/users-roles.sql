/* Find existing Users */
SELECT 
    rolname AS role_name,
    rolsuper AS is_superuser,
    rolinherit AS can_inherit,
    rolcreaterole AS can_create_roles,
    rolcreatedb AS can_create_db,
    rolcanlogin AS can_login,
    rolreplication AS can_replication,
    rolbypassrls AS bypass_rls
FROM pg_roles
WHERE rolname not like 'pg_%' and rolname not in ('postgres')
ORDER BY rolname;


-- Create super user
create role ajay with login superuser password '<Password>';

-- make it admin on pg
alter role ajay with superuser;
GRANT ALL PRIVILEGES ON DATABASE stackoverflow TO ajay;

-- drop role
drop role ajay;

/* Identity objects owned by role */
SELECT 
    n.nspname AS schema_name,
    c.relname AS object_name,
    c.relkind AS object_type
FROM 
    pg_class c
JOIN 
    pg_namespace n ON n.oid = c.relnamespace
WHERE 
    c.relowner = (SELECT oid FROM pg_roles WHERE rolname = 'ajay');

SELECT 
    n.nspname AS schema_name,
    p.proname AS function_name
FROM 
    pg_proc p
JOIN 
    pg_namespace n ON n.oid = p.pronamespace
WHERE 
    p.proowner = (SELECT oid FROM pg_roles WHERE rolname = 'ajay');

SELECT 
    n.nspname AS schema_name
FROM 
    pg_namespace n
WHERE 
    n.nspowner = (SELECT oid FROM pg_roles WHERE rolname = 'ajay');


/* Resolve ownership */
REASSIGN OWNED BY ajay TO postgres;

/* Terminate existing connections */
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.usename = 'ajay';




# Add entry in pg_hba.conf file also

-- Change password
alter user postgres password '<Password>';


/* Add entry for these users in pg_hba (/etc/postgres/16/main/pg_hba.conf) */
# ************************** Custom Settings by DBA ****************************************
# Allow roles to log in locally without a password
    # local user on machine need peer authentication
local   all             saanvi                        peer
    # database only user need trust authentication
local   all             ajay                       trust


# Allow roles to log in locally with a password
local   all             ajay                       scram-sha-256

# Allow roles to log in remotely with a password (from any host)
host    all             ajay      0.0.0.0/0       scram-sha-256
host    all             ajay      ::/0            scram-sha-256


/* Restart PG Service */
systemctl status postgresql@16-main.service
OR
systemctl status postgresql.service


/* Query to view Parsed Rules */
SELECT 
    line_number,
    type,
    database,
    user_name AS role,
    address,
    auth_method
FROM 
    pg_hba_file_rules
WHERE 
    user_name = 'ajay' OR user_name IS NULL -- Rules for 'ajay' or all users
ORDER BY 
    line_number;


/* Test Rules */
-- peer authentication
psql -d postgres

-- remote with password
psql -h localhost -U ajay -d postgres --password