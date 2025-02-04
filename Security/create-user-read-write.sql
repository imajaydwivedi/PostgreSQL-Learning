
/* 01
Create dbname= stackoverflow
create user and give required permissions 
usr_report_rw → to create / delete schema and tables in all above database for user
usr_report_ro → to read the data
*/
create database stackoverflow;
CREATE USER usr_report_rw WITH PASSWORD 'My$tr0ngPwdHere';
CREATE USER usr_report_ro WITH PASSWORD 'My$tr0ngPwdHere2';

GRANT ALL PRIVILEGES ON DATABASE stackoverflow TO usr_report_rw;

GRANT CONNECT ON DATABASE stackoverflow TO usr_report_ro;
GRANT USAGE ON SCHEMA public TO usr_report_ro;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO usr_report_ro;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO usr_report_ro;
