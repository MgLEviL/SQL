--EJERCICIO 1
accept c_client prompt 'Introduzca codigo del cliente'

begin
  for datos in (select distinct actividad.* from actividad, grupo, asistencia where actividad.codactividad = grupo.actividad and asistencia.grupo = grupo.codgrupo and asistencia.alumno = '&c_client')loop
    DBMS_OUTPUT.PUT_LINE('Nombre actividad: ' || datos.nombre);
    DBMS_OUTPUT.PUT_LINE('Descripcion: ' || datos.descripcion);
    DBMS_OUTPUT.PUT_LINE('----------------------------');
  end loop;
end;


--EJERCICIO 2
CREATE or replace PROCEDURE deudas_client
       (cod in decimal, total out decimal)
      IS
          
      BEGIN
          select sum(precio) into total from actividad, asistencia, grupo where grupo.codgrupo = asistencia.grupo  and grupo.actividad = actividad.codactividad and cod = alumno;
      END deudas_client;
      
      
--EJERCICIO 3
CREATE or replace PROCEDURE resumen_actividad
      IS
          res decimal;
      BEGIN
          for datos in (select nombre, codcliente from cliente)loop
            DBMS_OUTPUT.PUT_LINE('El cliente ' || datos.nombre);
           
            for datosgru in (select codgrupo, actividad.nombre, dia_semana, hora, monitor.nombre nom_monitor, precio 
                            from grupo, actividad, monitor, asistencia, cliente where grupo.actividad = actividad.codactividad and monitor.codmonitor = grupo.monitor
                            and asistencia.grupo = grupo.codgrupo and asistencia.alumno = cliente.codcliente and cliente.nombre = datos.nombre)loop
                            
              DBMS_OUTPUT.PUT_LINE('Codigo del grupo: ' || datosgru.codgrupo);
              DBMS_OUTPUT.PUT_LINE('La actividad del grupo es ' || datosgru.nombre || ', que se imparte los ' || datosgru.dia_semana || ' a las ' || datosgru.hora || ' por ' || datosgru.nom_monitor);
              DBMS_OUTPUT.PUT_LINE('Precio: ' || datosgru.precio || ' €');
            end loop;
            
            deudas_client(datos.codcliente, res);
            DBMS_OUTPUT.PUT_LINE('Precio mensual: '|| res || ' €');
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
          end loop;
      END resumen_actividad;
/*test*/
begin
  resumen_actividad();
end;
      
--EJERCICIO 4
create or replace trigger ej4
after insert or update on compra
for each row

declare
  coste decimal;
  diferencia decimal;
begin
  if inserting then
    update producto set stock = stock - :new.cantidad where :new.producto = codproducto;
    
    select precio into coste from producto where codproducto = :new.producto;
    coste := coste * :new.cantidad;
    
    DBMS_OUTPUT.PUT_LINE('El precio de la compra es: ' || coste || ' €');
  elsif updating then
    if (:new.cantidad > :old.cantidad) then
      select precio into coste from producto where :new.producto = codproducto;
      diferencia := (:new.cantidad - :old.cantidad) * coste;
      DBMS_OUTPUT.PUT_LINE('El precio a abonar es de: ' || diferencia || ' €');
    end if;
  end if;
end ej4;

/*test*/
insert into compra values (8, 2, '16/05/2018', 20);
update compra set cantidad = cantidad + 20 where cliente = 8;

--EJERCICIO 5
create or replace trigger ej5
after insert on cliente
for each row

declare
  grup decimal;
begin
  select codgrupo into grup from grupo, actividad where grupo.actividad = actividad.codactividad and actividad.nombre = 'Libre';
  insert into asistencia values(grup, :new.codcliente);
  DBMS_OUTPUT.PUT_LINE('Se ha matriculado en el grupo ' || grup);
  DBMS_OUTPUT.PUT_LINE('');

  DBMS_OUTPUT.PUT_LINE('-----RESUMEN-----');
  for datos in (select * from actividad)loop
    DBMS_OUTPUT.PUT_LINE('Nombre actividad: ' || datos.nombre);
    DBMS_OUTPUT.PUT_LINE('Descripcion: ' || datos.descripcion);
    DBMS_OUTPUT.PUT_LINE('Coste: ' || datos.precio || ' €');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
  end loop;
end ej5;

/*test*/
insert into cliente values (20, 'Prieto, pepe', '188888881', '02/09/1990');
