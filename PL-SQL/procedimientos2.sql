--1

CREATE or replace PROCEDURE infoDue
       (cod_masco in decimal)
      IS
          
      BEGIN
          for datos in (select duenios.NOMBRE, dni, apell, prov, duenios.F_NAC from duenios, mascota where duenios.dni = mascota.duenio and cod = cod_masco)loop
            DBMS_OUTPUT.PUT_LINE('nombre: ' || datos.nombre);
            DBMS_OUTPUT.PUT_LINE('DNI: ' || datos.dni);
            DBMS_OUTPUT.PUT_LINE('apellido: ' || datos.apell);
            DBMS_OUTPUT.PUT_LINE('provincia : ' || datos.prov);
            DBMS_OUTPUT.PUT_LINE('Fecha nacimiento: ' || datos.f_nac);
          end loop;
      END infoDue;


accept cod prompt 'introduce el codigo de una mascota para ver lso datos de su dueño'
begin
  infoDue('&cod');
end;


--2??????

CREATE or replace PROCEDURE contactKg
       (cod_masco in decimal)
      IS
          
      BEGIN
          EXECUTE infoDue(cod_masco);
          
      END contactKg;
      
      

--3
CREATE PROCEDURE n_Mascotas
       (nom in varchar, apellido in varchar, numero out decimal)
      IS
          
      BEGIN
          numero := select count(distinct cod) from mascota, duenios where duenios.dni = mascota.duenio and duenios.nombre = nom and apell = apellido;
      END n_Mascotas;

accept nom prompt 'introduce nombre cliente'
accept apelli prompt 'introduce apellido cliente'

declare
  resultado decimal;
begin
  n_Mascotas('&nom', '&apelli')
end;
      
