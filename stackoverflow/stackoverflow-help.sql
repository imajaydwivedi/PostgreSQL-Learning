-- Get Read-Only copy of StackOverflow for Postgres
    -- https://smartpostgres.com/how-to-use-query-smartpostgres-com/
    -- Database Diagram (https://sedeschema.github.io/)
    -- Documentation about Schema (https://meta.stackexchange.com/questions/2677/database-schema-documentation-for-the-public-data-dump-and-sede/2678#2678)

/* 
Server: query.smartpostgres.com
Username: readonly
Password: 511e0479-4d35-49ab-98b1-c3a9d69796f4
*/

-- Take backup of stackoverflow
pg_dump --dbname=postgresql://readonly:511e0479-4d35-49ab-98b1-c3a9d69796f4@query.smartpostgres.com/stackoverflow -F tar -f ~/Downloads/stackoverflow.tar




