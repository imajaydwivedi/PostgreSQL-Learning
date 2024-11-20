set search_path to postgres_air;

create table postgres_air.boarding_pass_large
    (like postgres_air.boarding_pass including all);

INSERT INTO postgres_air.boarding_pass_large
SELECT * FROM postgres_air.boarding_pass;
