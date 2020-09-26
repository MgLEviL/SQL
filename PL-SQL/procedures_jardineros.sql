--1
begin
  select * from trabajos where fecha_inicio = sysdate;
end;


--2
begin
  select * from trabajos where fecha_inicio = (sysdate - 3);
end;

--3
CREATE or replace PROCEDURE traF
       (fecha in date)
      IS
          
      BEGIN
          for datos in (select * from trabajos where fecha_inicio = fecha and fecha <= sysdate)loop
            DBMS_OUTPUT.put_line('jardinero: ' || datos.jardinero);
            DBMS_OUTPUT.put_line('plantacion: ' || datos.plantacion);
            DBMS_OUTPUT.put_line('dias: ' || datos.dias);
            DBMS_OUTPUT.put_line('terminado: ' || datos.terminado);
            DBMS_OUTPUT.put_line('----------------------');
          end loop;      
      END traF;


accept fec prompt 'introduce fecha'
begin
  traF('&fec');
end;


--4

begin
  for datos in (select nombre, dni, nvl(salario, 0) salario from jardinero)loop
    DBMS_OUTPUT.put_line('nombre: ' || datos.nombre);
    DBMS_OUTPUT.put_line('dni: ' || datos.dni);
    DBMS_OUTPUT.put_line('salario: ' || datos.salario);
    DBMS_OUTPUT.put_line('----------------------');
  end loop; 
end;

--5

CREATE or replace PROCEDURE sueldoTra
       (nomja in varchar, tsueldo out decimal)
      IS
          sueldo decimal;
          dias_tra decimal;
          res decimal;
      BEGIN
      --sumar numero de dias trabajados
        select sum(dias) into dias_tra from jardinero, trabajos where jardinero.dni = trabajos.jardinero and jardinero.nombre = nomja;
      --obtener salario base
        select salario into sueldo from jardinero where jardinero.nombre = nomja;
            res := sueldo + (dias_tra * 6.5);
            tsueldo := trunc (res, 0);
      END sueldoTra;


accept nom prompt 'introduce nombre de trabajador'
declare
  resultado decimal;
begin
  sueldoTra('&nom', resultado);
  DBMS_OUTPUT.put_line('El sueldo de &nom es de ' || resultado);
end;


--6
accept newname prompt 'introduce nombre de plantacion nueva'
declare
  cantidad decimal;
begin
  cantidad := length ('&newname');
  if(cantidad > 10)then
    DBMS_OUTPUT.put_line('no cabe en la tabla ');
  else
    DBMS_OUTPUT.put_line('si cabe en la tabla');
  end if;
end;


--7

CREATE or replace PROCEDURE fechaMes
       (fec in date, nom_mes in varchar, solucion out varchar)
      IS

          nom varchar(15);
      BEGIN
          nom := lower(rtrim (to_char(fec, 'MONTH')));
          if(nom = nom_mes)then
            solucion := 'SI';
          else
            solucion := 'NO';
          end if;
      END fechaMes;
      
      
accept fec prompt 'introduce una fecha'
accept mes prompt 'introduce un mes para sabr si coincide con el mes de la fecha anterior'
declare
  resultado varchar(15);
begin
  fechaMes('&fec', '&mes', resultado);
  DBMS_OUTPUT.put_line(resultado);
end;


--8
accept mes prompt 'introduce nombre del mes'
begin
  DBMS_OUTPUT.put_line('  Jardinero     ' ||'  Plantacion      ' ||'  De &mes');
  for datos in (select jardinero.nombre, plantacion.nombre nomplant from jardinero, plantacion, trabajos where jardinero.dni = trabajos.jardinero and plantacion.codigo = trabajos.plantacion and '&mes' = lower(rtrim (to_char(fecha_inicio, 'MONTH'))))loop
    DBMS_OUTPUT.put_line('  '||datos.nombre||'       '|| datos.nomplant || ' '    );
  end loop;
end;


--9

CREATE or replace PROCEDURE nom_fecha
       (fec in date, solucion out varchar)
      IS
          
      BEGIN
           solucion := lower(rtrim (to_char(fec, 'MONTH')));
      END nom_fecha;
      
accept fec prompt 'introduce una fecha'
declare
  resultado varchar(15);
begin
  nom_fecha('&fec', resultado);
  DBMS_OUTPUT.put_line('El mes de la fecha dada, es ' || resultado);
end;

--10
declare
  resultado varchar(15);
begin
  DBMS_OUTPUT.put_line('Jardinero     Plantacion      Mes ');
  
  for datos in (select fecha_inicio, jardinero.nombre nom_jar, plantacion.nombre from trabajos, jardinero, plantacion where jardinero.dni = trabajos.jardinero and trabajos.plantacion = plantacion.codigo)loop
    resultado := lower(rtrim (to_char(datos.fecha_inicio, 'MONTH')));
    DBMS_OUTPUT.put_line(datos.nom_jar || '       '|| datos.nombre||'       '|| resultado);
  end loop;
end;


--11

CREATE or replace PROCEDURE dia_semana
       (fec in date, diasemana out varchar)
      IS
          
      BEGIN
          diasemana := lower(rtrim (to_char(fec, 'DAY')));
      END dia_semana;
      
accept fec prompt 'introduce una fecha'
declare
  resultado varchar(20);
begin
  dia_semana('&fec', resultado);
  DBMS_OUTPUT.put_line('El dia de la semana, fue o sera ' || resultado);
end;

--12
CREATE or replace PROCEDURE infoPlanta
       (nom_pla in varchar)
      IS
          sumatorio decimal;
          dia varchar(15);
          contador decimal;
      BEGIN
        contador := 1;
          for datos in (select fecha_inicio, dias from trabajos, plantacion where trabajos.plantacion = plantacion.codigo and nombre = nom_pla)loop
            dia := lower(rtrim (to_char(datos.fecha_inicio, 'DAY')));
            DBMS_OUTPUT.put_line(contador || '.  '|| dia || ' ' || datos.fecha_inicio|| ' durante ' || datos.dias);
            contador := contador + 1;
          end loop;
          
          --sumatorio
          select sum(dias) into sumatorio from trabajos, plantacion where trabajos.plantacion = plantacion.codigo and nombre = nom_pla;
          
          DBMS_OUTPUT.put_line('En total se han trabajo ' || sumatorio);
      END infoPlanta;
      

accept nom prompt 'introduce el nombre de una plantacion'
begin
  infoPlanta('&nom');
end;
