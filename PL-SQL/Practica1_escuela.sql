
/*EJEMPLO 1*/
accept nom prompt 'nombre alumno'
accept noma prompt 'nombre asignatura'
declare
  nota matriculas.calificacion%type;
begin
  select calificacion 
  into nota 
  from matriculas, asignaturas, alumnos 
  where matriculas.dni = alumnos.dni 
  and matriculas.cod_asig = asignaturas.cod_asig 
  and nom_alum = '&nom' 
  and nom_asig = '&noma';
  
  dbms_output.put_line(nota);
end;

/*EJEMPLO 2*/
accept asig prompt 'Introduzca asignatura para ver la nota mas alta del alumno...'
declare
  resultado alumnos%rowtype;
begin

  select alumnos.* 
  into resultado 
  from alumnos, matriculas, asignaturas 
  where alumnos.dni = matriculas.dni
  and asignaturas.cod_asig = matriculas.cod_asig
  and nom_asig = '&asig'
  and calificacion
  in 
    (select max(calificacion) 
    from matriculas);
  
  dbms_output.put_line(resultado.dni);
  dbms_output.put_line(resultado.nom_alum);
  dbms_output.put_line(resultado.fecha_nac);
  dbms_output.put_line(resultado.provincia);
  dbms_output.put_line(resultado.beca);
end;

/*EJEMPLO 3*/
accept asig1 prompt 'Introduce la 1º asignatura'
accept asig2 prompt 'Introduce la 2º asignatura'

declare
  aprobados decimal;
begin
  select cod_asig 
  into aprobados
  from matriculas 
  where cod_asig = '&asig1' 
  and cod_asig = '&asig2'
  and calificacion >= 5;
  
  dbms_output.put_line(aprobados); 
end;


/*EJEMPLO 4*/
accept nombre prompt 'Introduce nombre alumno'
accept prov prompt 'Introduce su provincia'
accept asig prompt 'Introduce asignatura'

declare
  nota matriculas.calificacion%type;
begin
  select calificacion 
  into nota 
  from matriculas, asignaturas, alumnos 
  where asignaturas.cod_asig = matriculas.cod_asig 
  and matriculas.dni = alumnos.dni
  and nom_asig = '&asig'
  and nom_alum = '&nombre'
  and provincia = '&prov';
  
  if (nota >= 5) then
    dbms_output.put_line('Esta aprobado con un: ' || nota);
  else
    dbms_output.put_line('Esta suspenso con un: ' || nota);
  end if;
end;

/*EJEMPLO 5*/
accept asig prompt 'Introduce asignatura'

declare
  aprobados decimal;
  suspensos decimal;
begin
  select count(calificacion)
  into aprobados
  from matriculas, asignaturas
  where asignaturas.cod_asig = matriculas.cod_asig
  and nom_asig = '&asig'
  and calificacion >= 5;
  
  select count(calificacion)
  into suspensos
  from matriculas, asignaturas
  where asignaturas.cod_asig = matriculas.cod_asig
  and nom_asig = '&asig'
  and calificacion < 5;
  
  dbms_output.put_line('Hay estos aprobados: ' || aprobados || ' de &asig');
  dbms_output.put_line('Hay estos suspensos: ' || suspensos || ' de &asig');
  
end;

/*EJEMPLO 6*/
accept city1 prompt 'Primera ciudad'
accept city2 prompt 'Segunda ciudad'

declare
  cantidad1 decimal;
  cantidad2 decimal;
  media1 decimal;
  media2 decimal;
begin
  select count(dni) into cantidad1 from alumnos where provincia = '&city1' ;
  select count(dni) into cantidad2 from alumnos where provincia = '&city2' ;
  select avg(calificacion) into media1 from matriculas, alumnos where alumnos.dni = matriculas.dni and provincia = '&city1';
  select avg(calificacion) into media2 from matriculas, alumnos where alumnos.dni = matriculas.dni and provincia = '&city2';  
  
  dbms_output.put_line('&city1 tiene: ' || cantidad1 || ' y su media es: ' || media1);
  dbms_output.put_line('&city2 tiene: ' || cantidad2 || ' y su media es: ' || media2);
end;
  

/*EJEMPLO 7*/
accept dni prompt 'Mete un dni'

declare
  cantidad_alum decimal;
begin
  select count(dni) 
  into cantidad_alum 
  from alumnos
  where provincia 
    in 
    (select provincia from alumnos where dni = '&dni');
  
  dbms_output.put_line('Hay: ' || cantidad_alum);
end;
/*EJEMPLO 8*/

accept dni prompt 'Mete un dni'
accept asig prompt 'Mete un codigo asignatura'

declare
  matriculado decimal;
  nota matriculas.calificacion%type;
begin

  select count(dni) 
  into matriculado 
  from alumnos 
  where '&dni' 
    in 
      (select dni from matriculas);
  
  if (matriculado > 0) then
    select calificacion into nota from matriculas where cod_asig = '&asig';
    dbms_output.put_line('La nota del alumno fue: ' || nota);
  else
    dbms_output.put_line('El alumno con dni &dni nunca se ha matriculado');
  end if;
end;

/*EJEMPLO 9*/
declare
  cantidad decimal;
  nom ASIGNATURAS.NOM_ASIG%type;
begin
  FOR i IN 1..6 LOOP
    select count(*)
    into cantidad
    from matriculas
    where cod_asig = i;
      DBMS_OUTPUT.PUT_LINE(cantidad);
  END LOOP;
  
  FOR i IN 1..6 LOOP
    select nom_asig
    into nom
    from asignaturas
    where cod_asig = i;
      DBMS_OUTPUT.PUT_LINE(nom);
  END LOOP;
  
END;


/*EJEMPLO 10*/
declare
  media decimal;
  alum matriculas.dni%type;
begin
  FOR i IN 1..6 LOOP
    select avg(calificacion) 
    into media
    from matriculas 
    where cod_asig = i;
    DBMS_OUTPUT.PUT_LINE(media);
  end loop;
end;
/*EJEMPLO 11*/
accept grupo prompt 'Introduzca un codigo de grupo'
declare
  grups grupo%rowtype;
  nom profesores.nom_prof%type;
begin
  select *
  into grups
  from grupo
  where cod_gru = '&grupo';
  
  select nom_prof 
  into nom 
  from profesores 
  where nrp 
    in 
      (select nrp from grupo where cod_gru = '&grupo');
  
  DBMS_OUTPUT.PUT_LINE('El Profesor que imparte clases en este grupo es: ' || nom);
  DBMS_OUTPUT.PUT_LINE('El codigo del grupo es: ' || grups.cod_gru);
  DBMS_OUTPUT.PUT_LINE('El codigo de asignatura del grupo es: ' || grups.cod_asig);
  DBMS_OUTPUT.PUT_LINE('El NRP del profesor es: ' || grups.nrp);
  DBMS_OUTPUT.PUT_LINE('El codigo del aula es: ' || grups.cod_aula);
  DBMS_OUTPUT.PUT_LINE('El tipo es: ' || grups.tipo);
  DBMS_OUTPUT.PUT_LINE('El tamaño es: ' || grups.max_al);
end;
  
/*EJEMPLO 12*/
accept grupo prompt 'Introduzca un codigo de grupo'
declare
  cantidad decimal;
  maximo decimal;
begin
  select count(dni) 
  into cantidad 
  from matriculas
  where cod_asig 
    in 
      (select cod_asig from grupo where cod_gru = '&grupo');
      
  select max_al 
  into maximo
  from grupo
  where cod_gru = '&grupo';
  
  if (cantidad >= maximo) then
    DBMS_OUTPUT.PUT_LINE('El grupo esta llen');
  else
    DBMS_OUTPUT.PUT_LINE('El grupo no esta lleno');
  end if;
      
end;

/*EJEMPLO 13*/

accept nrps prompt 'Introduzca el NRP de un profesor'

declare
  info profesores%rowtype;
  daclase decimal;
begin
  select *
  into info
  from profesores
  where nrp = '&nrps';
  
  select count(nrp)
  into daclase
  from grupo
  where nrp = '&nrps';
  
  DBMS_OUTPUT.PUT_LINE('Cod: ' || info.nrp);
  DBMS_OUTPUT.PUT_LINE(info.nom_prof);
  
  if (info.categoria = 'T') then
    DBMS_OUTPUT.PUT_LINE('titular');
  else
    DBMS_OUTPUT.PUT_LINE('suplente');
  end if;
  
  DBMS_OUTPUT.PUT_LINE('Area: ' || info.area);
  DBMS_OUTPUT.PUT_LINE('Codigo de departamento: ' || info.cod_dept);
  DBMS_OUTPUT.PUT_LINE('Da clase en: ' || daclase || ' grupos');
  
end;

/*EJEMPLO 14*/


/*EJEMPLO 15*/
accept bec prompt 'Introduzca si o no'
accept nom prompt 'Meta el nombre de una asignatura'

declare
  beca decimal;
  nobeca decimal;
begin
  if ('&bec' = 'si') then
    select count(distinct dni)
    into beca 
    from matriculas, asignaturas 
    where matriculas.cod_asig = asignaturas.cod_asig
    and nom_asig = '&nom'
    and dni 
      in 
        (select dni from alumnos where beca = 'si'  and beca = '&bec') group by asignaturas.nom_asig;
        
   DBMS_OUTPUT.PUT_LINE('De la asignatura &nom hay: ' || beca || ' con beca');
  else  
    select count(distinct dni)
    into nobeca 
    from matriculas, asignaturas 
    where matriculas.cod_asig = asignaturas.cod_asig
    and nom_asig = '&nom'
    and dni 
      in 
        (select dni from alumnos where beca = 'no'  and beca = '&bec') group by asignaturas.nom_asig;
        
    DBMS_OUTPUT.PUT_LINE('De la asignatura &nom hay: ' || nobeca || ' sin beca');
  end if;
end;

/*EJEMPLO 16*/

accept nom prompt 'Escriba nombre de la asignatura'
accept numc prompt 'Introduzca un numero'

declare
  credits asignaturas.creditos%type;
begin
  select creditos into credits from asignaturas where nom_asig = '&nom';
  if (credits is null) then
    update asignaturas set creditos = '&numc' where nom_asig = '&nom';
    DBMS_OUTPUT.PUT_LINE('Datos asignados con exito');
  else
    update asignaturas set creditos = (creditos + '&numc') where nom_asig = '&nom';
    DBMS_OUTPUT.PUT_LINE('Datos sumados con exito');
  end if;
end;
