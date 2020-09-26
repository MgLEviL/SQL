--1
exec horariosConcierto(3);
CREATE or replace PROCEDURE horariosConcierto
       (codc in decimal)
      IS
          nom concierto.titulo%type;
          prov concierto.localidad%type;
          contador decimal;
          sumatorio decimal;
      BEGIN
          select titulo, localidad into nom, prov from concierto where cod = codc;
          DBMS_OUTPUT.PUT_LINE('Horario del concierto: ' || nom || ' que tendra lugar en: ' || prov);
          
          contador := 1;
          for datos in (select cancion.nombre cancion_name, cantante.nombre from cancion, cantante, horarios 
                        where cancion.cod = horarios.cancion and cantante.cod = horarios.cantante and horarios.concierto = codc  )loop
                        
            DBMS_OUTPUT.PUT_LINE(contador || ' - ' || datos.cancion_name || ' == ' || datos.nombre);
            contador := contador + 1;
          end loop;
          
          sumatorio := 0;
          select sum(duracion) into sumatorio from cancion, horarios, concierto where cancion.cod = horarios.cancion and concierto.cod = horarios.cancion and horarios.concierto = codc;
          DBMS_OUTPUT.PUT_LINE('El concierto durara: '|| sumatorio);
      END horariosConcierto;


--2
exec infoConcert('24/05/2018');
exec horariosConcierto(3);
CREATE or replace PROCEDURE infoConcert
       (fec in date)
      IS
          dias varchar(10);
          meses varchar(10);
          anios varchar(10);
          contador decimal;
          sumatorio decimal;
          nom concierto.titulo%type;
          prov concierto.localidad%type;
      BEGIN
          dias := to_char(fec, 'DD');
          meses := rtrim(to_char(fec, 'MONTH'));
          anios := to_char(fec, 'YYYY');
          
          DBMS_OUTPUT.PUT_LINE('Conciertos del dia ' || dias || ' de ' || meses || ' de ' || anios);        
      END infoConcert;
      
      
      
--3
CREATE or replace PROCEDURE duraCancion
       (codigo in decimal, durac out decimal)
      IS
          resultado decimal;
      BEGIN
          select duracion into resultado from cancion where cod = codigo;
          durac := resultado;
      END duraCancion;
      
--bloque introduccion codigo y salida duracion
accept codd prompt 'introduce codigo de cancion'
declare
  dur decimal;
begin
  duraCancion('&codd', dur);
  DBMS_OUTPUT.PUT_LINE('La duracion de la cancion es de: '||dur || 'minutos');
end;


--4

CREATE or replace PROCEDURE tiempoCantado
       (cantantes in decimal, tiempo out decimal)
      IS
          resultado decimal;
      BEGIN 
          select sum(duracion) into resultado from cancion, cantante, horarios 
                    where cantante.cod = horarios.cantante 
                    and cancion.cod = horarios.cancion and horarios.cantante = cantantes;
                    
          tiempo := resultado;
      END tiempoCantado;
      
      
--bloque introduccion codigo y salida duracion
accept codd prompt 'introduce codigo de cancion'
declare
  tiempo decimal;
begin
  duraCancion('&codd', tiempo);
  DBMS_OUTPUT.PUT_LINE('va a cantar '||tiempo || ' minutos');
end;



--5
exec resumenTra(4);
CREATE or replace PROCEDURE resumenTra
       (codi in decimal)
      IS
          sumatorio decimal;
          nombre_cantante cantante.nombre%type;
      BEGIN
          select nombre into nombre_cantante from cantante where cod = codi;
          DBMS_OUTPUT.PUT_LINE('--------Resumen de trabajo de '||nombre_cantante||'---------');
          
          for datos in (select titulo, cancion.nombre, duracion from concierto, cancion, cantante, horarios 
                        where horarios.cantante = cantante.cod and cancion.cod = horarios.cancion and concierto.cod = horarios.concierto and cantante.cod = codi)loop
                        
                        DBMS_OUTPUT.PUT_LINE('CONCIERTO: '||datos.titulo|| '  CANCION: ' ||datos.nombre|| ' ' || datos.duracion || ' minutos');
          end loop;
          
          sumatorio := 0;
          
          select sum(duracion) into sumatorio from concierto, cancion, cantante, horarios 
          where horarios.cantante = cantante.cod and cancion.cod = horarios.cancion 
          and concierto.cod = horarios.concierto and cantante.cod = codi;
          
          DBMS_OUTPUT.PUT_LINE('=======> en total: '||sumatorio||' minutos <=========');
      END resumenTra;
      
      