# Changes for PostgreSQL.conf
```
session_preload_libraries = 'auto_explain'
auto_explain.log_min_duration = '5s'
auto_explain.log_format = 'json'
auto_explain.log_verbose = 'on'
auto_explain.log_analyze = 'on'
auto_explain.log_buffers = 'on'
auto_explain.log_wal = 'on'
auto_explain.log_timing = 'on'
auto_explain.log_settings = 'on'
shared_preload_libraries = 'pg_stat_statements'    # (change requires restart)

logging_collector = on
log_destination = 'stderr'
log_directory = 'log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
#log_filename = 'postgresql-%a.log'
log_rotation_age = '1d'
log_rotation_size = '50MB'

log_min_messages = 'info'
client_min_messages = 'warning'

log_min_duration_statement = '5s'
log_min_duration_sample = '2s'
log_statement_sample_rate = 0.1
log_transaction_sample_rate = 0.1

log_temp_files = '20MB'

# Indicate locking issues
log_lock_waits = on
deadlock_timeout = '5s'

log_line_prefix = '%m [%p] %a@@%h [%l] %q%u@%d '
# default
log_line_prefix = '%m [%p] %q%u@%d '

```

# Log Analysis for pgbadger
### Check [../Setup-Configuration/pgBadger-settings.md](../Setup-Configuration/pgBadger-settings.md)

# [Install PgAudit on Ubuntu for PostgreSQL 16](https://support.kaspersky.com/kuma/2.1/252059)
```
# Add the PostgreSQL 16 repository.
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key.
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

# Update the package list
sudo apt update

# Install pgaudit
sudo apt -y install postgresql-<PostgreSQL version>-pgaudit
sudo apt -y install postgresql-16-pgaudit

# Edit postgresql.conf
shared_preload_libraries = 'pgaudit'


```

# Implementing Auditing using PgAudit
```
# create pgaudit extension for audit database
create extension pgaudit;


prepare my_query(text) as select * from users where displayname like $1;
execute my_query('Ajay%');

# Possible value for pgaudit.log -> ALL, NONE, READ, WRITE, ROLE, DDL, FUNCTION, MISC, MISC_SET
pgaudit.log = 'WRITE,FUNCTION'
set pgaudit.log to 'write, function';

# Possible value for pgaudit.log_level -> debug1-debug5, info, notice, warning, error, log, fatal, panic
pgaudit.log_level = 'INFO'

# Configure additional query parameters
pgaudit.log_parameter = ''

# Configure pgaudit by Object
pgaudit.role = ''

```

# Auditing by session
```
-- set log at session level (only superuser)
set pgaudit.log to 'all';



