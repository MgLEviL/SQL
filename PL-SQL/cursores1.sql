commit;

--1
accept proy prompt 'Introduce codigo de proyecto'
begin
  for datos in (select * from proyectos where codigo = '&proy')loop
    dbms_output.put_line('Datos del proyecto &proy');
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || datos.nombre_cliente);
    DBMS_OUTPUT.PUT_LINE('Especialidad: ' || datos.especialidad);
    DBMS_OUTPUT.PUT_LINE('Presupuesto: ' || datos.presupuesto || '€');
    if(datos.dni_director is null) then
      DBMS_OUTPUT.PUT_LINE('Director por determinar');
    else
      DBMS_OUTPUT.PUT_LINE('Director: ' || datos.dni_director);
    end if;
  end loop;
end;


--2
declare
  cursor nombres is (select nombre from arquitecto where dni in (select dni from proyectos, arquitecto where proyectos.dni_director = arquitecto.dni));
  datos2 nombres%rowtype;
begin
  for datos in (select nombre_cliente, especialidad, presupuesto, nombre from proyectos, arquitecto where arquitecto.dni = proyectos.dni_director)loop
    DBMS_OUTPUT.PUT_LINE('-------- ' || datos.nombre_cliente || ' ---------');
    DBMS_OUTPUT.PUT_LINE('Pertenece a la especialidad ' || datos.especialidad || ' tiene un presupuesto de ' || datos.presupuesto || ' y su director es: ' || datos.nombre);
    DBMS_OUTPUT.PUT_LINE('Los trabajadores asignados a este proyecto son: '); 
    
      open nombres;
      FETCH nombres INTO datos2;
        while(nombres%found)loop
          DBMS_OUTPUT.PUT_LINE('- ' || datos2.nombre);
          FETCH nombres INTO datos2;
        end loop;
      close nombres; 
  end loop;
end;

--3
accept nom prompt 'introduce nombre de trabajador'
accept ap prompt 'introduce apellido del trabajador'
declare
  suma decimal;
  --nombres arquitecto.nombre%type;
  --apellidos arquitecto.nombre%type;
begin
  --select nombre into nombres from arquitecto where nombre = '&nom'  and dni not in (select dni_director from proyectos);
  
  --if(nombres is null or apellidos is null) then
    --DBMS_OUTPUT.PUT_LINE('&nom &ap no tiene proyectos a su cargo');
  --else
      DBMS_OUTPUT.PUT_LINE('&nom &ap tiene los siguientes proyectos a su cargo');
      for datos in (select * from proyectos, arquitecto where arquitecto.dni = proyectos.dni_director and nombre = '&nom' and apellido = '&ap')loop   
        DBMS_OUTPUT.PUT_LINE('----- Proyecto: ' || datos.codigo || ' -----');
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || datos.nombre_cliente);
        DBMS_OUTPUT.PUT_LINE('Especialidad: ' || datos.especialidad);
        DBMS_OUTPUT.PUT_LINE('Presupuesto: ' || datos.presupuesto || '€');
        
        --sacar suma de presupuestos segun director
        select sum(presupuesto) into suma from proyectos where dni_director in (select dni from arquitecto);
        DBMS_OUTPUT.PUT_LINE('&nom &ap en total tiene un presupuesto de: ' || suma);
      end loop;
    --end if;
end;

--4
declare
  cursor nomap is select nombre, apellido from arquitecto where cod_dpto in (select codigo from departamento);
  datos nomap%rowtype;
begin
  for dat in (select codigo from departamento)loop
    DBMS_OUTPUT.PUT_LINE('Personas que trabajan en el departamento ' || dat.codigo);
  
      open nomap;
      loop
        FETCH nomap INTO datos;
        DBMS_OUTPUT.PUT_LINE('- ' || datos.nombre || ' ' || datos.apellido);
        exit when nomap%notfound;
      end loop;
      close nomap;  
  end loop;
end;


