CREATE or replace TRIGGER ej1
  before delete ON proyecciones
BEGIN
  DBMS_OUTPUT.PUT_LINE('se va a borrar una proyeccion');
END ej1;
      
delete from proyecciones where pelicula='p1' and sala = 's5' and hora = '12.00'; 


CREATE or replace TRIGGER ej2
  after update ON salas
BEGIN
  DBMS_OUTPUT.PUT_LINE('se va a modificar una sala');
END ej2;

update salas set nombre = 'misala' where s = 's2';



CREATE or replace TRIGGER ej3
  after insert ON salas
  for each row
BEGIN
  DBMS_OUTPUT.PUT_LINE('nueva sala insertada');
END ej3;

insert into salas values ('s99', 'sdgsdg', 56,50);



CREATE or replace TRIGGER ej4
  after insert ON peliculas
  for each row
BEGIN
  DBMS_OUTPUT.PUT_LINE('la pelicula '|| :new.nombre || ' insertada correctamente' );
END ej4;

insert into peliculas values ('p9', 'lalalalala', '7', 'spanish');




CREATE or replace TRIGGER ej5
  before update ON peliculas
  for each row
BEGIN
  DBMS_OUTPUT.PUT_LINE('Datos antiguos de la pelicula' );
  DBMS_OUTPUT.PUT_LINE('codigo: '|| :old.p );
  DBMS_OUTPUT.PUT_LINE('titulo: '|| :old.nombre );
  DBMS_OUTPUT.PUT_LINE('calificacion por edad: '|| :old.calificacion );
  
  
  DBMS_OUTPUT.PUT_LINE('Datos nuevos de la pelicula' );
  DBMS_OUTPUT.PUT_LINE('codigo: '|| :new.p );
  DBMS_OUTPUT.PUT_LINE('titulo: '|| :new.nombre );
  DBMS_OUTPUT.PUT_LINE('calificacion por edad: '|| :new.calificacion );
END ej5;

update peliculas set nombre = 'el parguela' where nombre = 'El autor';




CREATE or replace TRIGGER ej6
  after insert ON proyecciones
  for each row when (new.hora='18.00')
declare
  nom_sala salas.nombre%type;
  nompeli peliculas.nombre%type;
BEGIN
  select nombre into nom_sala from salas where s= :new.sala;
  select nombre into nompeli from peliculas where p= :new.pelicula;
  
  DBMS_OUTPUT.PUT_LINE('en la sala ' ||nom_sala|| ' se va a proyectar '|| nompeli|| ' a las 18.00' );

END ej6;

insert into proyecciones values ('s5','p9', '18.00', 0);




CREATE or replace TRIGGER ej7
  after insert or update or delete ON proyecciones
  for each row
declare
  nom_sala salas.nombre%type;
  titulo peliculas.nombre%type;
  cap salas.capacidad%type;
BEGIN
  if updating then
    DBMS_OUTPUT.PUT_LINE('datos actualizados correctamenet' );
  elsif deleting then
    select nombre into titulo from peliculas where p = :old.pelicula;
    DBMS_OUTPUT.PUT_LINE('se ha borrado una proyeccion de '|| titulo );
  elsif inserting then
    select nombre, capacidad into nom_sala, cap from salas where s = :new.sala;
    DBMS_OUTPUT.PUT_LINE('sala: '|| nom_sala|| ' Capacidad: '|| cap );
  end if;
END ej7;


insert into proyecciones values ('s2', 'p3', '21.00', 23);
update proyecciones set ocupacion = 200 where sala = 's2' and pelicula = 'p3' and hora = '21.00';
delete from proyecciones where sala = 's2' and pelicula = 'p3' and hora = '21.00';






CREATE or replace TRIGGER ej8
  before insert ON salas
  for each row

BEGIN
  DBMS_OUTPUT.PUT_LINE('neuva sala isnertada con lso datos:' );
  DBMS_OUTPUT.PUT_LINE('codigo:'|| :new.s );
  DBMS_OUTPUT.PUT_LINE('nombre:' || :new.nombre );
  DBMS_OUTPUT.PUT_LINE('capacidad:'|| :new.capacidad );
  DBMS_OUTPUT.PUT_LINE('numero de filas:' || :new.filas);
          
END ej8;

insert into salas values ('s89', 'ghj', 66,57);




create or replace trigger ej9
  before update on peliculas
  for each row
  
  begin
    DBMS_OUTPUT.PUT_LINE('la pelicula antes llamada '|| :old.nombre || ' tiene las siguientes proyecciones' );
    for datos in (select * from proyecciones where pelicula = :old.nombre)loop
      DBMS_OUTPUT.PUT_LINE(datos.sala ||' -- ' || datos.hora);
    end loop;
    DBMS_OUTPUT.PUT_LINE('el nuevo titulo es: ' || :new.nombre);
  end ej9;


update peliculas set nombre = 'yiiijaa' where nombre = 'El autor';