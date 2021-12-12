 --1
DECLARE
  procedure GET_TEACHERS(PCODE TEACHER.PULPIT % TYPE)
   is
    cursor c_teacher is select * from TEACHER;
     begin
      for row_teacher in c_teacher
       loop
        if PCODE = row_teacher.PULPIT
         then
          SYS.DBMS_OUTPUT.PUT_LINE('NAME: ' || row_teacher.TEACHER_NAME || ' ' || 'TEACHER: ' || row_teacher.TEACHER || ' ' || 'PULPIT: ' || row_teacher.PULPIT);
        end if;
       end loop;
     end;
BEGIN
    GET_TEACHERS('����');
END;

--2
DECLARE
  code integer :=0;
  function GET_NUM_TEACHERS(PCODE TEACHER.PULPIT % TYPE)
  return number
  is
  num integer :=0;
  begin
    select count(*) into num from teacher where pulpit like pcode;
    return num;
  end get_num_teachers;

BEGIN
  code:=get_num_teachers('%����%');
  dbms_output.put_line('teachers of pulpit = '||code);
END;

--3
DECLARE
  procedure GET_TEACHERS(FCODE PULPIT.FACULTY%TYPE)
  is
    teacher_name teacher.teacher_name%type;
    pulpit teacher.pulpit%type;
    facu faculty.faculty%type;
    cursor fact_teachers is 
    select teacher_name, teacher.pulpit, pulpit.faculty from teacher inner join pulpit on teacher.pulpit like pulpit.pulpit where pulpit.faculty like FCODE ;
  begin
    open fact_teachers;
    fetch fact_teachers into teacher_name, pulpit, facu;
    while(fact_teachers%found)
    loop
      dbms_output.put_line(teacher_name||', '||pulpit||', '||facu);
      fetch fact_teachers into teacher_name, pulpit, facu;
    end loop;
  end GET_TEACHERS;
BEGIN
  GET_TEACHERS('%���%');
END;

------
DECLARE
  procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE)
  is
    sub subject.subject%type;
    cursor pulp_subs is select subject from subject where subject.pulpit like PCODE ;
  begin
    open pulp_subs;
    fetch pulp_subs into sub;
    while(pulp_subs%found)
    loop
      dbms_output.put_line(sub);
      fetch pulp_subs into sub;
    end loop;
  end  GET_SUBJECTS;
BEGIN
   GET_SUBJECTS('%����%');
END;

--4
DECLARE
  code integer :=0;
  function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE)
  return number
  is
  num integer :=0;
  begin
    select count(*) into num from teacher inner join pulpit on teacher.pulpit like pulpit.pulpit where pulpit.faculty like FCODE ;
    return num;
  end get_num_teachers;

BEGIN
  code:=get_num_teachers('%���%');
  dbms_output.put_line('teachers of faculty = '||code);
END;

----
DECLARE
  code integer :=0;
  function GET_NUM_SUBJECTS(PCODE TEACHER.PULPIT%TYPE)
  return number
  is
  num integer :=0;
  begin
    select count(*) into num from subject where pulpit like PCODE ;
    return num;
  end GET_NUM_SUBJECTS;

BEGIN
  code:=GET_NUM_SUBJECTS('%����%');
  dbms_output.put_line('subjects on pulpit = '||code);
END;

--5
--ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:ALL','DISABLE:06015';

CREATE OR REPLACE PACKAGE TEACHERS IS
  PROCEDURE GET_TEACHERS(PCODE TEACHER.PULPIT%TYPE);
  procedure GET_SUBJECTS(PCODE PULPIT.PULPIT%TYPE);
  function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) return number;
  function GET_NUM_SUBJECTS(PCODE PULPIT.PULPIT%TYPE) return number;
END;
--rollback
CREATE OR REPLACE PACKAGE BODY TEACHERS IS
    PROCEDURE GET_TEACHERS(PCODE TEACHER.PULPIT%TYPE) IS cursor cs is select * from teacher where lower(pulpit) like lower('%' || pcode || '%') ;
    buffer teacher%rowtype;
    begin
       open cs;
         loop
          fetch cs into buffer;
          exit when cs%notfound;
          dbms_output.put_line(buffer.teacher_name);
        end loop;
      close cs;
    end;
    
    PROCEDURE GET_SUBJECTS(PCODE PULPIT.PULPIT%TYPE) IS cursor cs is select * from subject where lower(pulpit) like lower('%' || pcode || '%') ;
    buffer SUBJECT%rowtype;
    begin
       open cs;
         loop
           fetch cs into buffer;
           exit when cs%notfound;
           dbms_output.put_line(buffer.subject_name);
         end loop;
       close cs;
    end;
  
   function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) return number is buff number;
    begin
     select count(*) into buff from teacher , pulpit where teacher.pulpit = pulpit.pulpit and lower(pulpit.faculty) like lower('%' || fcode || '%');
     return buff-2;
    end GET_NUM_TEACHERS;

   function GET_NUM_SUBJECTS(PCODE PULPIT.PULPIT%TYPE) return number IS buff number;
    begin
     select count(*) into buff from subject where lower(pulpit) like lower('%' || pcode || '%');
     return buff;
    end GET_NUM_SUBJECTS;

END TEACHERS;

--6.
declare
FUNC_RES1 number;
FUNC_RES2 number;
BEGIN
  dbms_output.put_line('----------TEACERS----------');
  TEACHERS.GET_TEACHERS('����');
  dbms_output.put_line('---------------------------');
  dbms_output.put_line('---------SUBJECTS----------');
  TEACHERS.GET_SUBJECTS('����'); 
  dbms_output.put_line('----------------------------');
  dbms_output.put_line('------COUNT OF TEACERS------');
  FUNC_RES1 := TEACHERS.GET_NUM_TEACHERS('����');
  dbms_output.put_line(FUNC_RES1);
  dbms_output.put_line('----------------------------');
  dbms_output.put_line('-----COUNT OF SUBJECTS------');
  FUNC_RES2 := TEACHERS.GET_NUM_SUBJECTS('��');
  dbms_output.put_line(FUNC_RES2);
  dbms_output.put_line('----------------------------');
END;

