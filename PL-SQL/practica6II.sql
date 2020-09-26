--1
begin
  for datos in (select nom_alum, provincia, dni from alumnos where provincia = 'Granada' order by nom_alum)loop
    DBMS_OUTPUT.PUT_LINE('nombre: ' || datos.nom_alum);
    DBMS_OUTPUT.PUT_LINE('provincia: ' || datos.provincia);
    DBMS_OUTPUT.PUT_LINE('dni: ' || datos.dni);
    DBMS_OUTPUT.PUT_LINE('-----------------------');
  end loop;
end;

--2
accept prov prompt 'introduzca una provincia'
declare
  contador decimal;
begin
  contador :=0;
  for datos in (select nom_alum, fecha_nac from alumnos where provincia = '&prov' order by nom_alum)loop
  contador := contador + 1;
  DBMS_OUTPUT.PUT_LINE('alumno ' || contador || ': '|| datos.nom_alum || ' - nacido en: ' ||datos.fecha_nac);
  
  end loop;
end;

--3
accept nom prompt 'Introduzca nombre de alumno'
accept fec prompt 'introduzca fecha nacimiento'
declare
begin
  for datos in (select nom_asig, convocatoria, calificacion from asignaturas, matriculas, alumnos where asignaturas.cod_asig = matriculas.cod_asig and matriculas.dni = alumnos.dni and nom_alum = '&nom' and fecha_nac = '&fec')loop
    DBMS_OUTPUT.PUT_LINE('nombre: ' || datos.nom_asig);
    DBMS_OUTPUT.PUT_LINE('convocatoria: ' || datos.convocatoria);
    if(datos.calificacion is null) then
      DBMS_OUTPUT.PUT_LINE('pendiente de evaluacion');
    else
      DBMS_OUTPUT.PUT_LINE('nota obtenida: ' || datos.calificacion);
    end if;
      DBMS_OUTPUT.PUT_LINE('-----------------------');
  end loop;
end;


--4
begin
  for datos in (select avg(calificacion) media, nom_asig from matriculas, asignaturas where matriculas.cod_asig = asignaturas.cod_asig group by nom_asig)loop
    DBMS_OUTPUT.PUT_LINE(datos.nom_asig || ' tiene: ' || datos.media);
  end loop;
end;


--5
accept cur prompt 'introduzca un curso'
begin
  for datos in (select count(distinct matriculas.dni) num_alum, nom_asig from matriculas, asignaturas, alumnos where matriculas.dni = alumnos.dni and matriculas.cod_asig = asignaturas.cod_asig and curso = '&cur' group by nom_asig)loop
    DBMS_OUTPUT.PUT_LINE(datos.nom_asig || ' tiene: ' || datos.num_alum);
  end loop;
end;


--6
declare
  resultado decimal;
begin
  select cod_gru from aula, grupo where aula.cod_aula = grupo.cod_aula and capacidad - max_al;
  
  for datos in (select grupo.*, nom_asig, nom_prof from grupo, asignaturas, profesores where grupo.nrp = profesores.nrp and grupo.cod_asig = asignaturas.cod_asig )loop
    DBMS_OUTPUT.PUT_LINE('grupo '|| datos.cod_gru ||' '|| datos.nom_asig || ' imparte: ' || datos.nom_prof || ' aula: ' || datos.cod_aula);
    if(datos.tipo = 'M')then
      DBMS_OUTPUT.PUT_LINE('tipo de grupo: MAÑANA');
    else
      DBMS_OUTPUT.PUT_LINE('tipo de grupo: TARDE');
    end if;
  end loop;
  DBMS_OUTPUT.PUT_LINE('El grupo con mas plazas disponibles es: ' || gru || ' y tiene: ' ||resultado );
end;