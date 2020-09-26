/*EJEMPLO 1*/
begin
  for datos in (select * from duenios)loop
    DBMS_OUTPUT.PUT_LINE(datos.nombre ||' '|| datos.apell || ' con dni ' || datos.dni || ' vive en ' || datos.prov);
    DBMS_OUTPUT.PUT_LINE('su fecha de nacimiento es: ' || datos.f_nac);
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
  end loop;
end;

/*EJEMPLO 2*/
begin
  for datos in (select * from animal)loop
    DBMS_OUTPUT.PUT_LINE(datos.nombre ||' es de la familia de los ' || datos.familia);
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
  end loop;
end;

/*EJEMPLO 3*/
begin
  for datos in (select * from mascota where f_nac in (select min(f_nac) from mascota ))loop
    DBMS_OUTPUT.PUT_LINE('codigo: ' || datos.cod);
    DBMS_OUTPUT.PUT_LINE('nombre: ' || datos.nombre);
    DBMS_OUTPUT.PUT_LINE('tipo: ' || datos.tipo_animal);
    DBMS_OUTPUT.PUT_LINE('dueño: ' || datos.duenio);
    DBMS_OUTPUT.PUT_LINE('fecha nacimiento: ' || datos.f_nac);
    DBMS_OUTPUT.PUT_LINE('peso: ' || datos.peso);
    DBMS_OUTPUT.PUT_LINE('color: ' || datos.color);
  end loop;
end;
/*EJEMPLO 4*/
declare
  res_fecha decimal;
begin
  for datos in(select f_llegada, f_salida, enfermedades.nombre from ingresos, enfermedades
                where enfermedades.cod = ingresos.diagnostico)loop
               
    DBMS_OUTPUT.PUT_LINE('fecha de alta: ' || datos.f_salida);
    DBMS_OUTPUT.PUT_LINE('fecha de baja: ' || datos.f_llegada);
    DBMS_OUTPUT.PUT_LINE('causa: ' || datos.nombre);
    DBMS_OUTPUT.PUT_LINE('dias de ingreso: ' || res_fecha );
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
  end loop;
end;




accept fec prompt 'introduzca fecha'
declare
  res_fecha decimal;
begin
  for datos in(select f_llegada, f_salida, enfermedades.nombre from ingresos, enfermedades
                where enfermedades.cod = ingresos.diagnostico)loop
               
    DBMS_OUTPUT.PUT_LINE('fecha de alta: ' || datos.f_salida);
    DBMS_OUTPUT.PUT_LINE('fecha de baja: ' || datos.f_llegada);
    DBMS_OUTPUT.PUT_LINE('causa: ' || datos.nombre);
    DBMS_OUTPUT.PUT_LINE('dias de ingreso: ' || res_fecha );
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
  end loop;
end;
/*EJEMPLO 5*/
--A
begin
      for masco in (select mascota.nombre from mascota, duenios where mascota.duenio = duenios.dni )loop
        DBMS_OUTPUT.PUT_LINE(masco.nombre);
      end loop;
end;


--B
accept dnis prompt 'introduce dni del dueño para ver sus mascotas'
begin
    DBMS_OUTPUT.PUT_LINE('El dueño con dni: &dnis tiene: ');
    for masco in (select nombre from mascota where duenio = '&dnis')loop
      DBMS_OUTPUT.PUT_LINE(masco.nombre);
    end loop;
end;



--C
accept nom prompt 'introduce nombre del dueño'
accept ap prompt 'introduce apellido del dueño'
begin
  DBMS_OUTPUT.PUT_LINE('El dueño con nombre y apellidos: &nom &ap tiene: ');
  for datos in (select mascota.nombre from mascota, duenios where duenios.dni = mascota.duenio and duenios.nombre = '&nom' and apell = '&ap')loop
    DBMS_OUTPUT.PUT_LINE(datos.nombre);
  end loop;
end;

/*EJEMPLO 6*/
declare
 veces_enfermo decimal;
  
begin
    for datos in (select nombre from mascota where cod in (select  enfermo from ingresos ))loop
      select count(cod) into veces_enfermo from mascota, ingresos where mascota.cod = ingresos.enfermo and nombre = datos.nombre;
      dbms_output.put_line('la mascota: ' || datos.nombre || ' ha tenido: ' || veces_enfermo || ' ingresos');
    end loop;
end;

/*EJEMPLO 7*/
accept family prompt 'Introduzca la familia de mascotas'

declare
 total decimal;
 
begin
  select count(cod) into total from mascota;
  DBMS_OUTPUT.PUT_LINE('el total de mascotas es: ' || total);
  
  for datos in (select mascota.* from mascota, animal where mascota.tipo_animal = animal.cod and familia = '&family')loop
    DBMS_OUTPUT.PUT_LINE('Los datos de la familia: &family son: ');
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || datos.nombre);
    DBMS_OUTPUT.PUT_LINE('Dueño: ' || datos.duenio);
    DBMS_OUTPUT.PUT_LINE('fecha de nacimiento: ' || datos.f_nac);
    DBMS_OUTPUT.PUT_LINE('Peso: ' || datos.peso);
    DBMS_OUTPUT.PUT_LINE('Color: ' || datos.color);
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
  end loop;
end;

/*EJEMPLO 8*/
accept colo prompt 'Introduzca un color de mascota'
declare
  veces decimal;
begin
  for datos in (select nombre from mascota where color = '&colo' )loop
    select count(cod) into veces from mascota, duenios where mascota.duenio = duenios.dni;
    DBMS_OUTPUT.PUT_LINE('El dueño con dni' || datos.duenio || 'tiene: ' || veces || ' mascotas');
    DBMS_OUTPUT.PUT_LINE('las mascotas de color &colo son:' || datos.nombre);
  end loop;
end;

/*EJEMPLO 9*/
begin
  for datos in (select sintomas, nombre from enfermedades)loop
    DBMS_OUTPUT.PUT_LINE('la enfermedad: ' || datos.nombre || ' tiene los sintomas: ' || datos.sintomas);
    if(datos.sintomas is null) then
      DBMS_OUTPUT.PUT_LINE('consultar con el veterinario de guardia');
    end if;
  end loop;
end;

/*EJEMPLO 10*/
accept dnis prompt 'introduzca dni'

declare
  ingresos decimal;
begin
  select count(cod) into ingresos from mascota, ingresos where ingresos.enfermo = mascota.cod and duenio = '&dnis';
  dbms_output.put_line('El dueño con dni &dnis tiene ' || ingresos || ' ingresos');
    
  for datos in (select distinct mascota.nombre masco_nom, enfermedades.nombre nom_enfe, f_llegada, f_salida from duenios, mascota, enfermedades, ingresos
                  where mascota.cod = ingresos.enfermo and ingresos.diagnostico = enfermedades.cod and duenio = '&dnis')loop
                  
    dbms_output.put_line('la mascota: ' || datos.masco_nom || ', ' || datos.f_llegada || ' - ' || datos.f_salida || ' motivo: ' || datos.nom_enfe);
  end loop;
end;

/*EJEMPLO 11*/
accept nom prompt 'Introduce el nombre dela enfermedad'
declare
  contador decimal;
begin
  select count(diagnostico) into contador from ingresos, enfermedades where ingresos.diagnostico = enfermedades.cod and nombre = '&nom';
  dbms_output.put_line('enfermedad: &nom');
  dbms_output.put_line('Ingresos totales por dicha enfermedad: ' || contador);
  
  for datos in (select sintomas, mascota.nombre masco_nom, f_llegada, f_salida from ingresos, enfermedades, mascota where mascota.cod = ingresos.enfermo and ingresos.diagnostico = enfermedades.cod and enfermedades.nombre = '&nom')loop
     
     if(datos.sintomas is null) then
      dbms_output.put_line('sintomas: sin especificar');
     else
      dbms_output.put_line('sintomas: ' || datos.sintomas);
     end if;

     dbms_output.put_line(datos.masco_nom || ', ' || datos.f_llegada || ' - ' || datos.f_salida);
     dbms_output.put_line('----------------');
  end loop;
end;

/*EJEMPLO 12*/
declare
  contador decimal;
begin
  select count(diagnostico) into contador from ingresos, enfermedades where ingresos.diagnostico = enfermedades.cod;
  dbms_output.put_line('Ingresos totales por dicha enfermedad: ' || contador);

  for datos in (select sintomas, mascota.nombre masco_nom, f_llegada, f_salida from ingresos, enfermedades, mascota where mascota.cod = ingresos.enfermo and ingresos.diagnostico = enfermedades.cod )loop
    if(datos.sintomas is null) then
      dbms_output.put_line('sintomas: sin especificar');
    else
      dbms_output.put_line('sintomas: ' || datos.sintomas);
    end if;

     dbms_output.put_line(datos.masco_nom || ', ' || datos.f_llegada || ' - ' || datos.f_salida);
     dbms_output.put_line('----------------');
  end loop;
end;

