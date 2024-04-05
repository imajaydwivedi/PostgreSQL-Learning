-- Create super user
create role saanvi with login superuser password '<Password>';
create role ajay with login superuser password '<Password>';

-- Change password
alter user postgres password '<Password>';


