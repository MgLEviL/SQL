/*EJERCICIO 1*/
declare
  datos tratamiento%rowtype;
begin
  select * into datos from tratamiento where precio in (select max(precio) from tratamiento);
  DBMS_OUTPUT.PUT_LINE(datos.cod);
  DBMS_OUTPUT.PUT_LINE(datos.descripcion);
  DBMS_OUTPUT.PUT_LINE(datos.precio);
end;

/*EJERCICIO 2*/
accept cliente prompt 'Introduzca el nombre del cliente'
accept fec prompt 'Introduzca la fecha'
declare
  datos cita%rowtype;
begin
  select cita.* into datos from cita, cliente where cita.cliente = cliente.cod and nombre = '&cliente' and fecha = '&fec';
  DBMS_OUTPUT.PUT_LINE('&cliente');
  DBMS_OUTPUT.PUT_LINE(datos.trabajador);
  DBMS_OUTPUT.PUT_LINE(datos.tratamiento);
  DBMS_OUTPUT.PUT_LINE(datos.fecha);
  DBMS_OUTPUT.PUT_LINE(datos.duracion);
end;

/*EJERCICIO 3*/
accept nom prompt 'Nombre de usuario'
accept ap prompt 'Apellidos'

declare
  veces decimal;
begin
--select count(cod) into veces from cliente where nombre = '&nom' and apellidos = '&ap' and cod in (select cliente from cita);

 select count(cliente) 
 into veces 
 from cita
 where cliente 
  in  
    (select cod from cliente where nombre = '&nom' and apellidos = '&ap');
    
  DBMS_OUTPUT.PUT_LINE('&nom ha estado: ' || veces);
end;
/*EJERCICIO 4*/
accept nom prompt 'Nombre de tratamineto'
declare
  veces decimal;
  valor decimal;
  total decimal;
begin
  
  select count(tratamiento) 
  into veces 
  from cita, tratamiento 
  where tratamiento.cod = cita.tratamiento 
  and descripcion = '&nom';
  
  select precio into valor from tratamiento where descripcion = '&nom';
  
  total := valor*veces;
  DBMS_OUTPUT.PUT_LINE('El tratamiento &nom se ha dado: ' || veces);
  DBMS_OUTPUT.PUT_LINE('Los beneficios son: ' || total );
end;


/*EJERCICIO 5*/
accept nom prompt 'Introducri nombre de trabajador'
declare
  plus decimal;
  sueldo decimal;
  sueldo_total decimal;
begin
  select salario into sueldo from trabajador where nombre = '&nom';
  
  select count(duracion) 
  into plus 
  from cita, trabajador 
  where cita.trabajador = trabajador.cod 
  and duracion < 120 
  and trabajador.nombre = '&nom';
  
  if (plus > 0) then
    update trabajador set salario = (sueldo*plus) where nombre = '&nom';
      DBMS_OUTPUT.PUT_LINE('Lleva plus');
  else
      DBMS_OUTPUT.PUT_LINE('No lleva plus');
  end if;
end;

/*EJERCICIO 6*/
accept cod prompt 'Introduzca codigo de trabajador'

declare
begin
  delete from cita where trabajador = '&cod';
end;

/*EJERCICIO 7*/
/*EJERCICIO 8*/
/*EJERCICIO 9*/
/*EJERCICIO 10*/
/*EJERCICIO 11*/
/*EJERCICIO 12*/

