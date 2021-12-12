--1 permanent
create tablespace ts_pys2
  datafile 'C:\db2\TS_PYS2.dbf'
  size 7 M
  autoextend on next 5m
  maxsize 20m
  extent management local;
  
--2 temporary
create temporary tablespace ts_pys_temp2
tempfile 'C:\db2\ts_pys_temp2.dbf'
size 5 m
autoextend on next 3 m
maxsize 30 m
extent management local;

--3 
select file_name, tablespace_name, status, maxbytes, user_bytes from dba_data_files
union
select file_name, tablespace_name, status, maxbytes, user_bytes from dba_temp_files;

--
alter session set "_ORACLE_SCRIPT"=true

--4 named privilege set
create role rl_pysrole2;

grant create session to rl_pysrole2;
grant create table,
      create view,
      create procedure to rl_pysrole2;
grant drop any table ,
      drop any view,
      drop any procedure to rl_pysrole2;
      
--5
select * from dba_roles;

--6
create profile pf_pyscore limit
password_life_time 180 
sessions_per_user 3
failed_login_attempts 7
password_lock_time 1 
password_reuse_time 10  
password_grace_time default
connect_time 180  
idle_time 30 

--7 
select * from dba_profiles; --all profiles
select * from dba_profiles where profile like 'PF_PYSCORE';
select * from dba_profiles where profile like 'DEFAULT';

--8
create user pyscore identified by 12345
default tablespace ts_pys2 quota unlimited on ts_pys2
temporary tablespace ts_pys_temp2
profile pf_pyscore
account unlock
password expire

grant rl_pysrole2 to pyscore;


-- connect /as sysdba
-- connect pyscore/12345
--10 user pyscore
create table ugroup(
  id number(2) primary key,
  course number(2),
  spec varchar2(10),
  faculty varchar(20),
  students number(2)
);

insert into ugroup(id, course, spec, faculty, students) values(1, 3, 'ISIT', 'FIT', 25);
insert into ugroup(id, course, spec, faculty, students) values(4, 3, 'POIT', 'FIT', 26);
insert into ugroup(id, course, spec, faculty, students) values(5, 3, 'POIT', 'FIT', 29);
insert into ugroup(id, course, spec, faculty, students) values(7, 3, 'POIBMS', 'FIT', 20);
commit;

create view groups_view as select id, course, faculty from ugroup;

select * from ugroup;
select * from groups_view;

--drop table ugroup;
--drop view groups_view;

--11
create tablespace pys_qdata 
datafile 'C:\db2\PYS_QDATA.dbf'
SIZE 10M reuse
autoextend on next 5M
maxsize 20M
offline
extent management local;

alter tablespace pys_qdata online

create user PYS2
identified by q12345
default tablespace pys_qdata
quota 2M on pys_qdata 
profile pf_pyscore
account unlock 
password expire;

grant rl_pysrole2 to PYS2;

-- connect /as sysdba
-- connect PYS2/q12345


--drop tablespace pys_qdata 
--drop user PYS2 cascade

--user PYS2
create table tab(
    t number(2));
  
insert into tab(t) values(2);
insert into tab(t) values(1);
insert into tab(t) values(5);

select * from tab

--drop table tab

--drop tablespace pys_qdata 
--drop user PYS2 cascade

--drop user pyscore cascade
--drop tablespace ts_pys2
--drop tablespace ts_pys_temp2
--drop profile pf_pyscore 
--drop role rl_pysrole2








