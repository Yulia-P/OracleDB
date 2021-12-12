--1 PYS
select * from dba_sys_privs;

grant all privileges to pysuser;
grant select any dictionary to pysuser;

grant create table to pysuser;
grant create sequence to pysuser;
grant create cluster to pysuser;
grant create synonym to pysuser;
grant create public synonym to pysuser;
grant create view to pysuser;
grant create MATERIALIZED  view to pysuser;

grant alter any table to pysuser;
grant alter any sequence to pysuser;
grant alter any cluster to pysuser;
--grant alter any synonym to pysuser;
grant alter any MATERIALIZED view to pysuser;

grant drop any table to pysuser;
grant drop any sequence to pysuser;
grant drop any cluster to pysuser;
grant drop any synonym to pysuser;
grant drop public synonym to pysuser;
grant drop any view to pysuser;
grant drop any MATERIALIZED view to pysuser;

--2 pysuser
drop sequence pysuser.S1
create sequence pysuser.S1
    increment by 10
    start with 1000
    nomaxvalue --10^27 or -1
    nominvalue --1 or -10^26
    nocycle
    nocache
    noorder;

select S1.nextval from dual;   
select S1.currval from dual;

--3 pysuser
drop sequence pysuser.S2
create sequence pysuser.S2
    increment by 10
    start with 80
    maxvalue 100
    nocycle;

select S2.nextval from dual;
select S2.currval from dual;

--4 pysuser
drop sequence pysuser.S3
create sequence pysuser.S3
    increment by -10
    start with 10
    maxvalue 20
    minvalue -100
    nocycle
    order;

select S3.nextval from dual;
select S3.currval from dual;

--5 pysuser
drop sequence pysuser.S4
create sequence pysuser.S4
    increment by 1
    start with 1
    maxvalue 10
    cycle
    cache 5
    noorder;

select S4.nextval from dual;
select S4.currval from dual;

--6 pysuser
select * from user_sequences;

--7 pysuser
drop table T1
create table T1 (
  n1 number(20),
  n2 number(20),
  n3 number(20),
  n4 number(20)
)cache storage (buffer_pool keep);

begin
  for i in 1..7 loop
    insert into T1(n1, n2, n3, n4) values(S1.currval, S2.currval, S3.currval, S4.currval);
    end loop;
end;
select * from T1;

drop sequence S1;
drop sequence S2;
drop sequence S3;
drop sequence S4;
drop table T1;

--8 --not dellit not empty
create cluster pysuser.ABC 
(
  X number(10),
  V varchar2(12)
) hashkeys 200;
drop cluster pysuser.ABC;

--9-11 
drop table A;
drop table B;
drop table C;
create table A(XA number(10), VA varchar(12), CA char(10)) cluster pysuser.ABC(XA,VA);
create table B(XB number(10), VB varchar(12), CB char(10)) cluster pysuser.ABC(XB,VB);
create table C(XC number(10), VC varchar(12), CC char(10)) cluster pysuser.ABC(XC,VC);

--12 PYS
select cluster_name, owner from DBA_CLUSTERS;
select * from dba_tables where cluster_name='ABC';    

--13-14 pysuser
create synonym SS1 for pysuser.C;
insert into SS1 values (500,'sss',7);
create public synonym SS3 for pysuser.B;
insert into SS3 values (500,'sss',7);

--15
drop table A1;
drop table B1;
    create table A1 (
        X number(20) primary key
        );
    create table B1 (
        Y number(20),
        constraint fk_column
        foreign key (Y) references A1(X)
        );
    
    insert into A1(X) values (1);
    insert into A1(X) values (2);
    insert into B1(Y) values (1);
    insert into B1(Y) values (2);
    
--drop view V1
    create view V1
    as select X, Y from A1 inner join B1 on A1.X=B1.Y;
    
    select * from V1;

--17??????
--drop materialized view MV
  
create materialized view MV
build immediate
refresh complete
start with sysdate
next sysdate + Interval '2' minute as select X from A1;

select * from MV; 
commit;
insert into A1(X) values (12);


