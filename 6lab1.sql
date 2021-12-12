--1
select sum(value) from v$sga;

--2
select * from v$sga_dynamic_components;

--3
select component, granule_size from v$sga_dynamic_components;

--4
select sum(max_size), sum(current_size) from v$sga_dynamic_components;

--5
select component, current_size from v$sga_dynamic_components where
component like '%DEFAULT%' or component like '%KEEP%' or component like '%RECYCLE%';

--6-7
create table XXX (k int) storage(buffer_pool keep);
create table ZZZ (k int) storage(buffer_pool default);

insert into XXX values(1);
insert into ZZZ values(1);

select segment_name, segment_type,  buffer_pool from user_segments 
where segment_name in ('XXX', 'ZZZ');

drop table XXX;
drop table ZZZ;

--8
show parameter log_buffer;

--9
select  pool, name, bytes from v$sgastat where pool like 'large pool' order by bytes;

--10
set SERVEROUTPUT on;
declare m1 int := 0;
    c1 int := 0;
    f1 int := 0;
begin
    select max_size into m1  from v$sga_dynamic_components where component = 'large pool';
    select current_size into c1 from v$sga_dynamic_components where component = 'large pool';
    f1 := m1-c1;
    DBMS_OUTPUT.PUT_LINE(f1);
end;

--11-12
select * from v$session;
select osuser, schemaname, server from v$session;

--13
select name, owner, type, executions from v$db_object_cache order by executions desc;

