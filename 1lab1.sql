create table PYS_t(
id int primary key not null,
x number(3) not null , 
s varchar2(50)
);

insert into PYS_t (id, x, s) values (1, 1, 'ThinkPad');
insert into PYS_t (id, x, s) values (2, 2, 'Joga');
insert into PYS_t (id, x, s) values (3, 3, 'IdeaPad');
commit;

update PYS_t set s='Hello', x=4 where id=2;
update PYS_t set s='Goodbye', x=7 where id=3;
commit;

select max(x) from PYS_t where s='Hello'; 
select x from PYS_t where id=3;

select * from PYS_t;

delete from PYS_t where id<2;
commit;

create table PYS_t1(
id int primary key not null, 
pys_tID int, 
x number(3) not null , 
s varchar2(50),
foreign key (pys_tID) references PYS_t (id)
);

insert into PYS_t1 (id, pys_tID, x, s) values (4, 2, 5, 'Phone');
insert into PYS_t1 (id, pys_tID, x, s) values (5, 3, 7, 'Computer');

select * from PYS_t1 LEFT JOIN PYS_t on PYS_t1.x=PYS_t.x;
select * from PYS_t1 RIGHT JOIN PYS_t on PYS_t1.x=PYS_t.x;
select *from PYS_t1 INNER JOIN PYS_t on PYS_t1.x=PYS_t.x;

drop table PYS_t;
drop table PYS_t1;
