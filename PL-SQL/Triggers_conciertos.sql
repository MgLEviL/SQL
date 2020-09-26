--EJEMPLO 1
create or replace trigger ej1
before insert or delete on horarios
for each row

declare
  title concierto.titulo%type;
  nom_can cancion.nombre%type;
  person cantante.nombre%type;
  
  del_title concierto.titulo%type;
  del_cancion cancion.nombre%type;
  del_cantante cantante.nombre%type;
begin
  
  if inserting then
    select titulo into title from concierto where cod = :new.concierto;
    select nombre into nom_can from cancion where :new.cancion = cod;
    select nombre into person from cantante where :new.cantante = cod;
    
    DBMS_OUTPUT.PUT_LINE('Se ha creado un nuevo horario para el concierto ' || title  || ', se incluira la cancion ' ||nom_can || ' interpretada por '|| person);
    DBMS_OUTPUT.PUT_LINE('Numero de orden de la cancion: '|| :new.orden);
    
    elsif deleting then
      select nombre into del_cancion from cancion where :old.cancion = cod;
      select titulo into del_title from concierto where cod = :old.concierto;
      select nombre into del_cantante from cantante where :old.cantante = cod;  
      
      DBMS_OUTPUT.PUT_LINE('Se ha borrado la cancion' || del_cancion || ' del concierto '|| del_title || ', iba a interpretarla ' || del_cantante);
  end if;
end ej1;


insert into horarios values(2, 3, 2, 1);
delete from horarios where orden = 1;




--EJEMPLO 2
create or replace trigger ej2
after update on horarios
for each row

declare
  original varchar(30);
  suplente varchar(30);
begin
  select nombre into original from cantante where :old.cantante = cod;
  select nombre into suplente from cantante where :new.cantante = cod;
  
  DBMS_OUTPUT.PUT_LINE('el cantante ' || original || ' fue sustituido por '|| suplente );
  
  update cantante set salario = salario + 50 where cod = :new.cantante;
  update cantante set salario = salario - 50 where cod = :old.cantante;
end ej2;

update horarios set cantante = 3 where cancion = 2;

--EJEMPLO 3 
create or replace trigger ej3
after insert on horarios
for each row

declare
  contar decimal;
  newtime decimal;
  dura decimal;
begin
  select count(*) into contar from recuentos where cantante = :new.cantante;
if(contar < 0)then
  update recuentos set num_canciones = (num_canciones + 1) where :new.cantante = cantante;
  
  select duracion into newtime from cancion where :new.cancion = cod;
  update recuentos set tiempo = tiempo + newtime where :new.cantante = cantante;
  elsif(contar = 0)then
    select sum(duracion) into dura from cancion where cod = :new.cancion;
    insert into recuentos values(:new.cantante, 1 , dura);
end if;
end ej3;

insert into horarios values(2, 3, 2, 4);
