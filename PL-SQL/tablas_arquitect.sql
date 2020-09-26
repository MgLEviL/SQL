create table departamento
(
	codigo		varchar2(2) primary key,
	capacidad	number(2) check (capacidad > 0)
);


create table arquitecto
(
	dni			varchar2(9) primary key,
	nombre		varchar2(10), 
	Apellido	varchar2(15), 
	dni_jefe	varchar2(9),
	cod_dpto varchar2(2),
	sueldo		number(6,2),
	constraint pk_jefe foreign key (dni_jefe) references arquitecto (dni),
	constraint pk_despacho foreign key (cod_dpto) references departamento (codigo)
);

create table proyectos
(
	codigo			varchar2(3) primary key,
	nombre_cliente			varchar2(30),
	especialidad			varchar2(20),
	presupuesto		number(6),
	dni_director	varchar2(9),
	constraint pk_director foreign key (dni_director) references arquitecto (dni)
);


insert into departamento values ('D1',3);
insert into departamento values ('D2',4);
insert into departamento values ('D3',3);
insert into departamento values ('D4',2);


insert into arquitecto values ('11111111k','Juan','Martinez', null,'D1',1500);
insert into arquitecto values ('22222222a','Manuel','Perez','11111111k','D1',1150);
insert into arquitecto values ('33333333s','Pablo','Ruiz', null,'D2',1800);
insert into arquitecto values ('44444444v','Eva','Lopez','11111111k','D1',985);
insert into arquitecto values ('55555555w','Maria','Perez','11111111k','D1',780);
insert into arquitecto values ('66666666x','Elena','Prieto','33333333s','D2',1150);
insert into arquitecto values ('77777777q','Pedro','Velazquez','33333333s','D2',1100);
insert into arquitecto values ('12121212b','Martin','Aguilera', null,'D3',2000);
insert into arquitecto values ('13131313i','Luis','Aguilar','12121212b','D3',1800);


insert into proyectos values ('P1' ,'Wapp-mania' ,'Remodelación', 120000, '11111111k');
insert into proyectos values ('P2' ,'MCN Toldos' ,'Diseño interior', 200000, '33333333s');
insert into proyectos values ('P3' ,'Hotel Dunas' ,'Ampliación', 85000, '33333333s');
insert into proyectos values ('P4' ,'Cafetería Ristra' ,'Remodelación', 158000, '11111111k');
insert into proyectos values ('P5' ,'Ángel Vícar' ,'Ampliación', 95000, null);	

