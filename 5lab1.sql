--1
select tablespace_name, file_name from DBA_DATA_FILES;  
select tablespace_name, file_name from DBA_TEMP_FILES; 

--drop tablespace PYS_QDATA 
--drop tablespace ts_pys5_temp
--drop role pys5role
--drop profile pys5profile cascade
--drop user pys5user 

--2
create tablespace PYS_QDATA  
datafile 'C:\db5\PYS_QDATA.dbf' 
size 10M
offline;

alter tablespace PYS_QDATA online;

create temporary tablespace ts_pys5_temp
tempfile 'C:\db5\pys5_temp.dbf'
size 5 m
autoextend on next 3 m
maxsize 30 m
extent management local;

alter session set "_ORACLE_SCRIPT"=true

create role pys5role;

grant create session to pys5role;
grant create table,
      create view,
      create procedure to pys5role;
grant drop any table ,
      drop any view,
      drop any procedure to pys5role;
      
create profile pys5profile limit
password_life_time 180 
sessions_per_user 3
failed_login_attempts 7
password_lock_time 1 
password_reuse_time 10  
password_grace_time default
connect_time 180  
idle_time 30

create user pys5user identified by 12345
default tablespace pys_qdata quota unlimited on pys_qdata
temporary tablespace ts_pys5_temp
profile pys5profile
account unlock
password expire

grant pys5role to pys5user;

alter user pys5user quota 2 m on PYS_QDATA;
grant pys5role to pys5user;

--user pys5user connect user
create table PYS5_T1(
id number(15) PRIMARY KEY,
name varchar2(10));

insert into PYS5_T1 values(5, 'BAddZ');
insert into PYS5_T1 values(2, 'IBS');
insert into PYS5_T1 values(3, 'SRG');

--3 user PYS
select owner, segment_name, segment_type, tablespace_name from dba_segments where tablespace_name like 'PYS_QDATA';

--4
--PYS5user
drop table PYS5_T1;
--PYS
select owner, segment_name, segment_type, tablespace_name from dba_segments where tablespace_name like 'PYS_QDATA';
--PYS5 user
select object_name, original_name, type, operation, ts_name from user_recyclebin;

--5
--PYS5
flashback table PYS5_T1 to before drop;
select * from PYS5_T1;

delete from PYS5_T1 

--6
begin
for k in 1..10000
loop
insert into PYS5_T1(id, name) values(k, 'a');
end loop;
commit;
end;

select count(*) from PYS5_T1;

--7 user PYS5user
select * from user_extents where tablespace_name='PYS_QDATA';

--8 user PYS
drop tablespace PYS_QDATA INCLUDING CONTENTS;

--9
SELECT * FROM V$LOG;
SELECT GROUP# FROM V$LOG WHERE STATUS = 'CURRENT';

--10
SELECT * FROM V$LOGFILE;

--11
ALTER SYSTEM SWITCH LOGFILE;
select group#, status from v$log;

select current_timestamp from dual;

--12
ALTER DATABASE ADD LOGFILE GROUP 4 'C:\db5\REDO04.LOG'
SIZE 150m BLOCKSIZE 512;

select group#, status from v$log;

alter database add logfile member 'C:\db5\REDO041.LOG' to group 4;
alter database add logfile member 'C:\db5\REDO042.LOG' to group 4;
alter database add logfile member 'C:\db5\REDO043.LOG' to group 4;

select group#, status from v$log;

alter system switch logfile;
select group#, status from v$log; --povtor

--13
alter database drop logfile group 4 
alter database drop logfile member 'C:\db5\REDO04.LOG';
alter database drop logfile member 'C:\db5\REDO042.LOG';
alter database drop logfile member 'C:\db5\REDO043.LOG';
alter database drop logfile group 4;
select group#, status from v$log;

--14
select name, log_mode from v$database;
select instance_name, archiver, active_state from  v$instance;

--15
SELECT * FROM V$LOG;
SELECT * FROM V$DATABASE;

--16
--shutdown IMMEDIATE;
--STARTUP MOUNT;
--alter database ARCHIVELOG;
--alter database open;

--17
alter system set LOG_ARCHIVE_DEST_1 ='LOCATION=C:\db5'

alter system switch logfile;
select * from v$archived_log;

--18
--shutdown immediate
--startup mount;
--alter database noarchivelog;
--select name, log_mode from v$database;
SELECT * FROM V$LOG;
SELECT * FROM V$DATABASE;

--19
select * from v$controlfile;

--20
show parameter control;
select * from v$controlfile_record_section;

--21
select * from v$parameter where name like 'spfile';

--22---
create pfile = 'pys_pfile.ora' from spfile;

--23
select * from v$diag_info;

--24
select * from v$diag_info;




