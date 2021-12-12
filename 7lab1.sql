--1
select name, description from v$bgprocess order by name;

--2
select * from v$bgprocess;
select name, description from v$bgprocess where paddr!=hextoraw('00') order by name;

--3
select spid, pname, username, program from v$process where pname like 'DBW%';

--4
select * from v$session where username is not null;

--5
select username, status, server from v$session where username is not null;

--6
select * from v$services;

--7
show parameter dispatcher; 

--9
select username, sid, serial#, server, status from v$session where username is not null;




