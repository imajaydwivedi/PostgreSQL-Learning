/*
|------------$ pg_dump --help
pg_dump dumps a database as a text file or to other formats.

Usage:
  pg_dump [OPTION]... [DBNAME]

General options:
  -f, --file=FILENAME          output file or directory name
  -F, --format=c|d|t|p         output file format (custom, directory, tar,
                               plain text (default))
  -j, --jobs=NUM               use this many parallel jobs to dump
  -v, --verbose                verbose mode
  -Z, --compress=METHOD[:DETAIL] compress as specified. Value 0-9.

Options controlling the output content:
  -a, --data-only              dump only the data, not the schema
  -c, --clean                  clean (drop) database objects before recreating
  -C, --create                 include commands to create database in dump
  -n, --schema=PATTERN         dump the specified schema(s) only
  -N, --exclude-schema=PATTERN do NOT dump the specified schema(s)
  -O, --no-owner               skip restoration of object ownership in plain-text format
  -s, --schema-only            dump only the schema, no data
  -t, --table=PATTERN          dump only the specified table(s)
  -T, --exclude-table=PATTERN  do NOT dump the specified table(s)
  -x, --no-privileges          do not dump privileges (grant/revoke)
  --column-inserts             dump data as INSERT commands with column names
  --disable-dollar-quoting     disable dollar quoting, use SQL standard quoting
  --disable-triggers           disable triggers during data-only restore
  --enable-row-security        enable row security (dump only content user has access to)
  --exclude-table-and-children=PATTERN
                               do NOT dump the specified table(s), including child and partition tables
  --exclude-table-data=PATTERN do NOT dump data for the specified table(s)
  --exclude-table-data-and-children=PATTERN
                               do NOT dump data for the specified table(s), including child and partition tables
  --extra-float-digits=NUM     override default setting for extra_float_digits
  --if-exists                  use IF EXISTS when dropping objects
  --include-foreign-data=PATTERN
                               include data of foreign tables on foreign servers matching PATTERN
  --inserts                    dump data as INSERT commands, rather than COPY
  --no-unlogged-table-data     do not dump unlogged table data
  --on-conflict-do-nothing     add ON CONFLICT DO NOTHING to INSERT commands
  --quote-all-identifiers      quote all identifiers, even if not key words
  --rows-per-insert=NROWS      number of rows per INSERT; implies --inserts
  --table-and-children=PATTERN dump only the specified table(s), including child and partition tables

Connection options:
  -d, --dbname=DBNAME      database to dump
  -h, --host=HOSTNAME      database server host or socket directory
  -p, --port=PORT          database server port number
  -U, --username=NAME      connect as specified database user
  -w, --no-password        never prompt for password
  -W, --password           force password prompt (should happen automatically)
  --role=ROLENAME          do SET ROLE before dump

If no database name is supplied, then the PGDATABASE environment
variable value is used.
*/


/* **** Dumping a single database **** */
/*
-- Dumping a single database with default format
    -- -F, --format=c|d|t|p         output file format (custom, directory, tar, plain text (default))
pg_dump stackoverflow2010 > /tmp/stackoverflow2010.sql

-- Dump single database from cross engine migration. Expect longer backup time
pg_dump --inserts stackoverflow2010 > /tmp/stackoverflow2010.sql
pg_dump --column-inserts stackoverflow2010 > /tmp/stackoverflow2010.sql
pg_dump --column-inserts -f /tmp/stackoverflow2010.sql stackoverflow2010

-- Create create database script is required
pg_dump --create --column-inserts stackoverflow2010 > /tmp/stackoverflow2010.sql


*/

/* **** Restore a single database **** */
/*
-- Create a database for restore. By default, database creation does not happen in backup script.
psql -c 'create database stackoverflow2010_copy with owner postgres;'

psql -U postgres -d stackoverflow2010_copy
\i /tmp/stackoverflow2010.sql

-- set search_path which is erased during restore to avoid issues.
select pg_catalog.set_config('search_path', 'public', "$user", false);
*/

/* **** Compression **** */
/*
# backup with no compression
pg_dump -Z 9 stackoverflow2010 > /tmp/stackoverflow2010.sql

# backup with gzip compression
pg_dump -Z 9 -f /tmp/stackoverflow2010_compressed.sql.gz stackoverflow2010

*/

/* ******** Dump formats and pg_restore ******* */
/*
# backup with custom format
pg_dump -Fc --create --verbose -Z 9 -f /tmp/pg_backup/stackoverflow2010.bkp stackoverflow2010

# restore database from backup
psql -c 'drop database stackoverflow2010_copy;'
pg_restore -C --verbose-d postgres /tmp/pg_backup/stackoverflow2010.bkp

# create a shell database and restore from backup
pg_restore --verbose -d stackoverflow2010_copy /tmp/pg_backup/stackoverflow2010.bkp

# extract backup content into sql file for inspection
pg_restore /tmp/pg_backup/stackoverflow2010.bkp -f /tmp/pg_backup/stackoverflow2010.sql


# backup in directory format
pg_dump -Fd --verbose -f /tmp/pg_backup.d stackoverflow2010
# restore backup from directory format
pg_restore --verbose -d stackoverflow2010_copy /tmp/pg_backup.d


# back in tar format (uncompressed backup)
pg_dump -Ft --verbose -f /tmp/pg_backup/stackoverflow2010.tar stackoverflow2010
# Check tar file
tar -tvf /tmp/pg_backup/stackoverflow2010.tar

*/


/* ************ Performing a Selective Restore ************* */
/*


*/