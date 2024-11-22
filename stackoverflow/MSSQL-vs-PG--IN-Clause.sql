use StackOverflow
go

exec sp_BlitzIndex @TableName = 'Users';
go

drop index DisplayName on dbo.Users;
create index DisplayName_Location on dbo.Users (DisplayName, Location);
go

select *
from dbo.Users u
where u.DisplayName in ('Ajay','David')
and u.Location = 'India'
go

/* MSSQL

Engine is able to perform 2 seek operations.
First for DisplayName = 'Ajay' & Location = 'India'
Second for DisplayName = 'David' & Location = 'India'
*/

explain (analyze, buffers, costs, verbose)
select *
from users u
where u.displayname in ('ajay','david')
and u.location = 'india'


