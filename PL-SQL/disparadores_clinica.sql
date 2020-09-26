create or replace trigger ej1
after insert on duenios
for each row

declare
  edad decimal;
begin
  edad := (sysdate - :new.f_nac);
   DBMS_OUTPUT.PUT_LINE(:new.nombre ||'  '|| :new.apell || 'con DNI ' || :new.dni || ' tiene ' || edad || ' años. Insertado correctamente');
end ej1;

insert into duenios values ('87849484K', 'ioee', 'perez', 'Grana', '17/06/1990');


--2
create or replace trigger ej2
before delete on mascota
for each row

begin
  DBMS_OUTPUT.PUT_LINE('Se borro:');
  DBMS_OUTPUT.PUT_LINE(:old.nombre);
  DBMS_OUTPUT.PUT_LINE(:old.tipo_animal);
  DBMS_OUTPUT.PUT_LINE(:old.duenio);
end ej2;

delete from mascota where nombre = 'Rey';



--3
create or replace trigger ej3
before update on mascota
for each row

begin
  DBMS_OUTPUT.PUT_LINE('La mascota llamada '|| :old.nombre || ' pasa a llamarse ' || :new.nombre );
end ej3;

update mascota set nombre = 'pancho' where nombre = 'Tobby';

--4
create or replace trigger ej4
after update on mascota
for each row

declare
  gano decimal;
  perdio decimal;
begin
  if (:new.peso > :old.peso) then
    gano := :new.peso - :old.peso;
    DBMS_OUTPUT.PUT_LINE('Ha ganado ' || gano||' kilos');
    elsif (:new.peso < :old.peso) then
        perdio := :new.peso - :old.peso;
        DBMS_OUTPUT.PUT_LINE('Ha perdido ' || perdio||' kilos');
  end if;
end ej4;

update mascota set peso = 20 where nombre = 'pancho';



--5
create or replace trigger ej5
after insert on ingresos
for each row
  
begin
  if :new.tratamiento is null then
  DBMS_OUTPUT.PUT_LINE('No se inserto tratamiento');
  end if;
end ej5;

insert into ingresos values (4,2,'16/03/2017','11/1/2018',null);


--6
create or replace trigger ej6
after insert on mascota
for each row

begin
  insert into ingresos values (:new.cod,2,:new.f_nac,null,null);
end ej6;


insert into mascota values (13,'panchpo',2,'22222222A','15/11/2018',0.6,'Blanco');



--7
CREATE table cantidad_animales(
  cod_tipo decimal,
  cantidad decimal,
  
  constraint cp_cant_ani primary key (cod_tipo),
  constraint ce_cod_tipo foreign key (cod_tipo) references animal(cod)
);

create or replace trigger ej7
after insert on mascota
for each row

declare
  numero decimal;
begin
  numero := 0;
    select count(*) into numero from cantidad_animales where cod_tipo = :new.tipo_animal;

    
    if(numero = 0)then
      insert into animal values(:new.tipo_animal, null, null);
      DBMS_OUTPUT.PUT_LINE('Se agrego nuevo tipo de animal a la tabla: ANIMAL');
      elsif (numero > 0) then
        update cantidad_animales set cantidad = numero + 1 where cod_tipo = :new.tipo_animal;
        DBMS_OUTPUT.PUT_LINE('Se actualizo la cantidad a ' || numero);
  end if;
end ej7;


insert into mascota values(13, 'sardina', 1, '22222222A', '01/01/2001', 1, 'azul');




--8
create table antiguos_clientes(
  dni			varchar2(9),
	nombre  	varchar2(20) not null,
	apell		varchar2(50) not null,
	prov		varchar2(25),
	f_nac		date
);

create or replace trigger ej8
before delete on duenios
for each row

begin
  insert into antiguos_clientes values(:old.dni, :old.nombre, :old.apell, :old.prov, :old.f_nac);
end ej8;

delete from duenios where nombre = 'Juan';



--9
create table facturas(
  precio number(4);
);
