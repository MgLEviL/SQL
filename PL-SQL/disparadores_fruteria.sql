drop table clientes cascade constraints;
drop table productos cascade constraints;
drop table proveedores cascade constraints;
drop table stock cascade constraints;
drop table compras cascade constraints;

create table clientes(
  codigo number(3) primary key,
  nombre varchar(30) not null,
  telefono varchar(9)
);

create table proveedores(
  codigo number(3) primary key,
  nombre varchar(30) not null,
  telefono varchar(9)
);


create table productos(
  codigo number(3) primary key,
  nombre varchar(30) not null,
  precio decimal(3,1),
  cod_proveedor number(3),
  
  constraint ce_prov foreign key (cod_proveedor) references proveedores(codigo)
);

create table stock(
  codigo number(3) primary key,
  cantidad number(3),
  
  constraint fk_sto_pro foreign key (codigo) references productos (codigo)
);


create table compras(
  cod_cliente number(3),
  cod_producto number(3),
  fecha date,
  cantidad number(3),
  pagado char(2) check (pagado = 'si' or pagado = 'no'),
  
  constraint cp_comp primary key (cod_cliente, cod_producto, fecha),
  constraint ce_cod_cl foreign key (cod_cliente) references clientes(codigo),
  constraint ce_cod_prod foreign key (cod_producto) references productos(codigo)
);

insert into clientes values(1, 'Ramon Torres', '111111111');
insert into clientes values(2, 'Maria Lopez', '222222222');
insert into clientes values(3, 'Paloma Ruiz', '333333333');
insert into clientes values(4, 'Isabel Perea', '444444444');
insert into clientes values(5, 'Luisa Marin', '555555555');
insert into clientes values(6, 'Pedro Macias ', '666666666');
insert into clientes values(7, 'Teresa Vilchez', '777777777');
insert into clientes values(8, 'Ricardo Muñoz', '888888888');
insert into clientes values(9, 'Muriel Mina', '999999999');

insert into proveedores values(1, 'Fuitis SA', '101010101');
insert into proveedores values(2, 'Distribuciones SL', '202020202');
insert into proveedores values(3, 'Frutas SA', '303030303');
insert into proveedores values(4, 'Frutas Rocio SL', '404040404');

insert into productos values(1, 'malon', 0.6, 4);
insert into productos values(2, 'sandia', 0.6, 3);
insert into productos values(3, 'manzana', 1.2, 3);
insert into productos values(4, 'tomate', 1.5, 2);
insert into productos values(5, 'papaya', 0.3, 2);
insert into productos values(6, 'patata', 0.1, 2);

insert into stock values(1, 100);
insert into stock values(2, 150);
insert into stock values(3, 75);
insert into stock values(4, 89);
insert into stock values(5, 128);
insert into stock values(6, 35);

insert into compras values(1, 1, '21/05/18', 2, 'si');
insert into compras values(1, 3, '15//05/18', 3, 'si');
insert into compras values(1, 4, '10/05/18', 1, 'no');
insert into compras values(2, 3, '12/05/18', 5, 'no');
insert into compras values(2, 5, '13/05/18', 8, 'si');
insert into compras values(3, 1, '22/05/18', 5, 'no');
insert into compras values(3, 4, '05/05/18', 3, 'no');
insert into compras values(4, 4, '13/05/18', 5, 'si');
insert into compras values(5, 3, '10/05/18', 3, 'no');
insert into compras values(5, 6, '10/05/18', 6, 'no');
insert into compras values(5, 1, '13/05/18', 2, 'si');
insert into compras values(4, 3, '11/05/18', 5, 'no');
insert into compras values(9, 6, '12/05/18', 4, 'si');
insert into compras values(3, 6, '15/05/18', 6, 'no');
insert into compras values(4, 4, '20/05/18', 2, 'si');
insert into compras values(3, 4, '21/05/18', 1, 'no');
insert into compras values(4, 4, '22/05/18', 4, 'si');
insert into compras values(9, 1, '15/05/18', 5, 'no');
insert into compras values(9, 1, '13/05/18', 1, 'si');
insert into compras values(7, 3, '12/05/18', 2, 'no');
insert into compras values(2, 5, '11/05/18', 1, 'no');
insert into compras values(6, 4, '22/05/18', 9, 'si');

commit;


--1
create or replace trigger ej1
after insert on productos
for each row

begin
  if(:new.precio < 0,5)then
    dbms_output.put_line('El precio es inferior a 0.5€/kg');
  end if;
  dbms_output.put_line('Es necesario que introduzca tambien el stock');
end ej1;

insert into productos values(7, 'fresa', 0.4, 4);

--2
create or replace trigger ej2
after insert on compras
for each row

declare
  prove proveedores%rowtype;
  cant decimal;
begin
  update stock set cantidad = (cantidad - :new.cantidad) where codigo = :new.cod_producto;
  select cantidad into cant from stock where codigo = :new.cod_producto;
  if (cant < 15)then
    dbms_output.put_line('Hay poco stock, avisar al proveedor!!');
   
    select distinct proveedores.* into prove from productos, proveedores where productos.cod_proveedor = proveedores.codigo;
    dbms_output.put_line('--------datos del proveedor------');
    dbms_output.put_line('codigo: '|| prove.codigo);
    dbms_output.put_line('nombre: ' || prove.nombre);
    dbms_output.put_line('telefono: ' || prove.telefono);

  end if;
end ej2;

insert into compras values(3, 3, '30/08/18', 1, 'si');



--5
create or replace trigger ej5
before delete on compras
for each row

begin
  if(:old.pagado = 'si')then
    dbms_output.put_line('ALTO! NOSE PUEDE BORRAR, la compra esta pagada');
  end if;
end ej5;

delete from compras where fecha = '30/07/18';

--6
create or replace trigger ej6
after update on productos
for each row


begin
  if(:new.precio >= (:old.precio * 1.1))then
    DBMS_OUTPUT.PUT_LINE('el precio ha subido');
    DBMS_OUTPUT.PUT_LINE('no es bueno subir tanto de golpe');   
  end if;
end ej6;

update productos set precio = 1.6 where nombre = 'malon';


--7
create or replace trigger ej7
after update on stock
for each row

begin
  if(:new.cantidad > :old.cantidad)then
    DBMS_OUTPUT.PUT_LINE('el precio subio, REVISAR PRECIO');
    elsif(:new.cantidad < :old.cantidad)then
      DBMS_OUTPUT.PUT_LINE('el stock actual es de ' || :new.cantidad);
  end if;
end ej7;

update stock set cantidad = 55 where codigo = 6;


--9
create or replace trigger ej9
before update on compras
for each row

declare
  total decimal(3,1);
  clien clientes%rowtype;
begin
  if(:old.pagado = 'no' and :new.pagado = 'si')then
    select precio into total from productos where codigo = :new.cod_producto;
    total := total * :new.cantidad;
    DBMS_OUTPUT.PUT_LINE('el precio pagado es de ' || total);
    
    select * into clien from clientes where codigo = :new.cod_cliente;
    DBMS_OUTPUT.PUT_LINE('codigo ' || clien.codigo);
    DBMS_OUTPUT.PUT_LINE('nombre: ' || clien.nombre);
    DBMS_OUTPUT.PUT_LINE('telefono: ' || clien.telefono);
    
    elsif(:old.pagado = 'si' and :new.pagado = 'no')then
      DBMS_OUTPUT.PUT_LINE('el cambio no se puede realizar');
  end if;
end ej9;

update compras set pagado = 'si' where fecha = '21/05/18';


--12
create or replace trigger ej12
after insert on compras
for each row

begin
  if(:old.fecha)then
  end if;
end ej12;
