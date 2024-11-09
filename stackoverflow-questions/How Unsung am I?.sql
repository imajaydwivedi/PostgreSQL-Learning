-- https://data.stackexchange.com/stackoverflow/query/7521/how-unsung-am-i

-- How Unsung am I?
-- Zero and non-zero accepted count. Self-accepted answers do not count.

set search_path to public;

do $$
declare userid INTEGER := 26837;
begin
    select
        count(a.id) as "accepted answers",
        sum(case when a.score = 0 then 0 else 1 end) as "scored answers",  
        sum(case when a.score = 0 then 1 else 0 end) as "unscored answers",
        sum(case when a.score = 0 then 1 else 0 end)*1000 / count(a.id) / 10.0 as "percentage unscored"
    from
        posts q
    inner join
        posts a
    on a.id = q.acceptedanswerid
    where
        a.communityowneddate is null
    and a.owneruserid = userid
    and q.owneruserid != userid
    and a.posttypeid = 2;
end $$;

