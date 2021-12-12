-- 1
select name,open_mode from v$pdbs; 

--2
select INSTANCE_NAME from v$instance;

--3 
select * from PRODUCT_COMPONENT_VERSION;

--5
select * from v$pdbs;

--6
--drop tablespace pdb14
--drop tablespace pdb_temp14
--drop role pdbrole
--drop profile pdbprofile cascade
--drop user userpdb14 cascade

create tablespace pys
  datafile 'C:\db\pys.dbf'
  size 10 M
  offline;
  
  alter tablespace pys online;
  
  
create temporary tablespace pys_temp
tempfile 'C:\db\pys_temp.dbf'
size 5 m
autoextend on next 3 m
maxsize 30 m
extent management local;

alter session set "_ORACLE_SCRIPT"=true;

alter session set container=CDB$ROOT;

create role pysrole;

grant create session to pysrole;
grant create table,
      create view,
      create procedure to pysrole;
grant drop any table ,
      drop any view,
      drop any procedure to pysrole;
      
create profile pysprofile limit
password_life_time 180 
sessions_per_user 3
failed_login_attempts 7
password_lock_time 1 
password_reuse_time 10  
password_grace_time default
connect_time 180  
idle_time 30

create user pysuser41 identified by 12345
default tablespace pys quota unlimited on pys
temporary tablespace pys_temp
profile pysprofile
account unlock
password expire

grant pysrole to pysuser41;


--7 user pysuser
create table  pys_table(
id int,
name varchar(15)
);

insert into pys_table values (1,'David');
insert into pys_table values(2,'Helen');
insert into pys_table values(3,'Nick');
insert into pys_table values(4,'Lui');

select * from pys_table;

--drop table pys_table;

--8 user PYS
select * from ALL_USERS;  
select * from DBA_TABLESPACES;  
select * from DBA_DATA_FILES;   
select * from DBA_TEMP_FILES;  
select * from DBA_ROLES;
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS;  
select * from DBA_PROFILES;  



