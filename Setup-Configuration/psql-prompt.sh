# Update psql prompt to include host name
    # https://gist.github.com/viniciusdaniel/53a98cbb1d8cac1bb473da23f5708836#foreground-text
    # https://www.postgresql.org/docs/current/app-psql.html#APP-PSQL-PROMPTING

(base) saanvi@ryzen9:PostgreSQL-Learning$ nano ~/.psqlrc
    -------------------
    \set PROMPT1 '%[%033[96m%]%n@%[%033[95m%]%m %[%033[39m%][%`date +%H:%M:%S`] %[%033[92m%](%/) \n%[%033[1;33m%]%R%#%]%[%033[0;39m%]%] '
    \set PROMPT2 '%[%033[1;33m%]%R%#%]%[%033[0;39m%]%] '
    -------------------