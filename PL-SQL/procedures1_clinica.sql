--1
CREATE or replace PROCEDURE mostrarMascotas
       (nom in varchar)
      IS
          
      BEGIN
       for datos in (select mascota.nombre from mascota, duenios where mascota.duenio = duenios.dni and duenios.nombre = nom)loop
        DBMS_OUTPUT.PUT_LINe('nombre: ' || datos.nombre);
       end loop;
      END mostrarMascotas;

accept nom prompt 'Introduce nombre del dueño(para ver sus mascotas en la clinica)'
begin
  mostrarMascotas('&nom');
end;



--2
CREATE or replace PROCEDURE SalidasEntradas
       (fec in varchar)
      IS
          
      BEGIN
          for datos in (select f_llegada, f_salida, mascota.nombre from ingresos, mascota where ingresos.enfermo = mascota.cod and f_llegada = fec or f_salida = fec)loop
            DBMS_OUTPUT.PUT_LINE('en la fecha  ' || fec || ' ingreso/salio ' || datos.nombre);          
           -- DBMS_OUTPUT.PUT_LINE('ingreso: ' || datos.f_llegada);
           -- DBMS_OUTPUT.PUT_LINE('alta: ' || datos.f_salida);
           -- DBMS_OUTPUT.PUT_LINE('nombre: ' || datos.nombre);
            DBMS_OUTPUT.PUT_LINE('-------------------');
          end loop;
      END SalidasEntradas;
      
accept fec prompt 'Introduce una fecha'
begin
  SalidasEntradas('&fec');
end;



--3
CREATE or replace PROCEDURE nomAp_Prov
       (provi in varchar)
      IS
          
      BEGIN
          DBMS_OUTPUT.PUT_LINE('Los clientes de ' || provi || ' son:');
          
          for datos in (select duenios.nombre, apell, mascota.nombre nom_masco, animal.nombre animal from duenios, mascota, animal where duenios.dni = mascota.duenio and animal.cod = mascota.tipo_animal and prov = provi)loop
            DBMS_OUTPUT.PUT_LINE('- ' || datos.nombre || ' ' || datos.apell || ' es dueño de ' || datos.nom_masco || ' de la raza: ' || datos.animal);
            DBMS_OUTPUT.PUT_LINE('-------------------');
          end loop;
      END nomAp_Prov;
      
accept provi prompt 'Introduce una provincia'
begin
  nomAp_Prov('&provi');
end;
      
   
      
--4
CREATE or replace PROCEDURE ingresosEnferm
       (enfermedad in varchar)
      IS
          cont decimal;
          ingreso ingresos.f_llegada%type;
          salida ingresos.f_salida%type;
          resultado decimal;
      BEGIN
        DBMS_OUTPUT.PUT_LINE('Informacion almacenada sobre: ' || enfermedad);
        
        cont := 0;
        select count(diagnostico) into cont from ingresos, enfermedades where ingresos.DIAGNOSTICO = enfermedades.cod and enfermedades.nombre = enfermedad;
        DBMS_OUTPUT.PUT_LINE('El numero de ingresados por ' || enfermedad || ' es: ' || cont);
        for datos in (select f_llegada, f_salida into ingreso, salida from ingresos, enfermedades where ingresos.diagnostico = enfermedades.cod and enfermedades.nombre = enfermedad)loop
          resultado := (datos.f_salida) - (datos.f_llegada);
          DBMS_OUTPUT.PUT_LINE('Duraciones: ' || resultado || ' dias' || ingreso || salida);
        end loop;
      END ingresosEnferm;


accept enf prompt 'Introduce una enfermedad'
begin
  ingresosEnferm('&enf');
end;


--5

CREATE PROCEDURE expSintomas
       (nom_enf in varchar, lista in varchar)
      IS
          
      BEGIN
          update enfermedades set sintomas = lista where nom_enf = nom_enf;
      END expSintomas;
      
      
accept nom_en prompt 'Introduce nombre de la enfermedad'
accept lista prompt 'Introduce una lista de sintomas'

begin
  expSintomas('&nom_en', '&lista');
end;


--6

CREATE or replace PROCEDURE tratamientoD
       (cod_masco in decimal, f_ingres in date, precio out decimal)
IS
          dias decimal;
          ingreso ingresos.f_llegada%type;
          salida ingresos.f_salida%type;
BEGIN
      select f_llegada, f_salida into ingreso, salida from ingresos where enfermo = cod_masco and f_llegada = f_ingres;
      dias := (salida) - (ingreso);
      precio := 25 * dias;
          
END tratamientoD;
      
accept cod prompt 'Introduce el codigo de mascota'
accept f_in prompt 'Introduce fecha de su ingreso'
declare
  coste decimal;
begin
  tratamientoD('&cod', '&f_in', coste);
  DBMS_OUTPUT.PUT_LINE('su total ha pagar es de: ' ||coste);
end;


--7
CREATE or replace PROCEDURE nom_duenio
       (nom_masco in varchar, nom_du out varchar)
      IS
      
      BEGIN
        select duenios.nombre into nom_du from duenios, mascota where duenios.dni = mascota.duenio and mascota.nombre = nom_masco;
      END nom_duenio;
    
accept masco prompt 'introduce nombre de mascota para saber el nombre de su dueño'  
declare
  persona DUENIOS.NOMBRE%type;
begin
  nom_duenio('&masco', persona);
  DBMS_OUTPUT.PUT_LINE('Su dueño es: ' ||persona);
end;



--8

CREATE or replace PROCEDURE facDuenio
       (nom_masco in varchar, entrof in date, nom_du out varchar, precio out decimal)
      IS
          dias decimal;
          entro ingresos.f_llegada%type;
          salida ingresos.f_salida%type;
      BEGIN
        /*Sacar dueño*/
        select duenios.nombre into nom_du from duenios, mascota where duenios.dni = mascota.duenio and mascota.nombre = nom_masco;
        /*Sacar precio*/
        select f_llegada, f_salida into entro, salida from ingresos, mascota where ingresos.enfermo = mascota.cod and mascota.nombre = nom_masco and f_llegada = entrof;
        dias := (salida) - (entro);
        precio := 25 * dias;
      END facDuenio;
      
accept nom_masco prompt 'introduce nombre de mascota'
accept ingre prompt 'introduce fecha de ingreso'
declare
  persona DUENIOS.NOMBRE%type;
  coste decimal;
begin
  facDuenio('&nom_masco', '&ingre', persona, coste);
  DBMS_OUTPUT.PUT_LINE('D./ña ' ||persona || ' debe pagar por el ingreso de &nom_masco un total de ' || coste || '€');
end;
      
      
      
--9
CREATE or replace PROCEDURE familiaCont
       (family in varchar, contador out decimal)
      IS

      BEGIN
        contador := 0;
          for datos in (select mascota.cod, mascota.nombre from mascota, animal where animal.cod = mascota.tipo_animal and animal.familia = family)loop      
            if(datos.cod is not null and datos.nombre is not null)then
              contador := contador + 1;
            end if;
            if(contador = 0)then
              DBMS_OUTPUT.PUT_LINE('Error, no hay mascotas de este tipo ');
            end if;          
          end loop;       
      END familiaCont;
      
accept fam prompt 'Introduce familia de animal'
declare
  numero decimal;
begin
  familiaCont('&fam', numero);
  DBMS_OUTPUT.PUT_LINE('Se encontraron ' || numero || ' de animales de este tipo');
end;

--10

CREATE or replace PROCEDURE info_masco
       (dnis in varchar)
      IS
          
      BEGIN
        DBMS_OUTPUT.PUT_LINE('el dni perteneciente a ' || dnis || ' tiene: ');
          for datos in (select mascota.nombre, animal.nombre ani_nom from animal, mascota where animal.cod = mascota.tipo_animal and duenio = dnis)loop
              
              DBMS_OUTPUT.PUT_LINE('Nombre: ' ||datos.nombre|| ' de raza ' || datos.ani_nom);
          end loop;
      END info_masco;
      
accept dnis prompt 'introduce dni para ver info de sus animales'
begin
  info_masco('&dnis');
end;


--11

CREATE or replace PROCEDURE info_masco
       (dnis in varchar)
      IS
          
      BEGIN
        DBMS_OUTPUT.PUT_LINE('el dni perteneciente a ' || dnis || ' tiene: ');
          for datos in (select mascota.nombre, animal.nombre ani_nom from animal, mascota where animal.cod = mascota.tipo_animal and duenio = dnis)loop
              
              DBMS_OUTPUT.PUT_LINE('Nombre: ' ||datos.nombre|| ' de raza ' || datos.ani_nom);
          end loop;
      END info_masco;
      
accept dnis prompt 'introduce dni para ver info de sus animales'
begin
  info_masco('&dnis');
end;

--12
CREATE or replace PROCEDURE info_masco
       (dnis in varchar)
      IS
          edad date;
          res decimal;
      BEGIN
        
        DBMS_OUTPUT.PUT_LINE('el dni perteneciente a ' || dnis || ' tiene: ');
          for datos in (select mascota.nombre, animal.nombre ani_nom, duenios.f_nac from duenios, animal, mascota where animal.cod = mascota.tipo_animal and duenios.DNI = mascota.DUENIO and duenio = dnis)loop
              res := edad - sysdate;
              --if(res > 20) then
                --DBMS_OUTPUT.PUT_LINE('Nombre: ' ||datos.nombre|| ' de raza ' || datos.ani_nom);
              --end if;
          end loop;
      END info_masco;
      
accept dnis prompt 'introduce dni para ver info de sus animales'
begin
  info_masco('&dnis');
end;
