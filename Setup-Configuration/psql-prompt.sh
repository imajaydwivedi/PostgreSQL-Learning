# Update psql prompt to include host name

(base) saanvi@ryzen9:PostgreSQL-Learning$ nano ~/.psqlrc
    -------------------
    \set PROMPT1 '%[%033[96m%]%n@%[%033[95m%]%m %[%033[92m%]%/%[%033[0m%]%R%# '
    -------------------