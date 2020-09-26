

create table cantante
(
	cod number(2) primary key,
	nombre varchar2(20) not null,
	salario number(5,2) check (salario > 0)
);


create table cancion
(
	cod number(2) primary key,
	nombre varchar2(30) not null,
	duracion number(3) check (duracion > 1)
);

create table concierto
(
	cod number(2) primary key,
	titulo varchar2(100) not null,
  fecha date,
  localidad varchar2(25)
);

create table horarios
(
	concierto number(2),
	cancion number(2),
	cantante number(2),
	orden number(1),
	constraint pk_horarios primary key (concierto, cancion, cantante, orden),
	constraint fk_hor_eve foreign key (concierto) references concierto (cod),
	constraint fk_hor_cha foreign key (cancion) references cancion (cod),
	constraint fk_hor_pon foreign key (cantante) references cantante (cod)
);

insert into cantante values ( 1, 'Andrés', 150.75);
insert into cantante values ( 2, 'Julia', 185.25);
insert into cantante values ( 3, 'Héctor', 95.3);
insert into cantante values ( 4, 'Luis', 175.25);
insert into cantante values ( 5, 'María', 140.5);
insert into cantante values ( 6, 'Olivia', 195.25);

insert into cancion values ( 1, 'Rigoletto', 50);
insert into cancion values ( 2, 'La traviata', 75);
insert into cancion values ( 3, 'Don Pasquale', 35);
insert into cancion values ( 4, 'Barbero de Sevilla', 90);
insert into cancion values ( 5, 'Hija de regimiento', 85);
insert into cancion values ( 6, 'Pagliacci (Payaso)', 120);
insert into cancion values ( 7, 'Don Carlo', 25);
insert into cancion values ( 8, 'Madama Butterfly', 100);

insert into concierto values ( 1, 'Ópera Clasica en español', '24/05/2018', 'Granada');
insert into concierto values ( 2, 'Ópera Clasica universal', '25/05/2018', 'Granada');
insert into concierto values ( 3, 'Recopilación clásica', '26/05/2018', 'Granada');
insert into concierto values ( 4, 'Ópera Clasica en español', '26/05/2018', 'Jaén');
insert into concierto values ( 5, 'Ópera Clasica universal', '27/05/2018', 'Jaén');
insert into concierto values ( 6, 'Recopilación clásica', '28/05/2018', 'Jaén');



insert into horarios values ( 1, 3, 2, 1);
insert into horarios values ( 1, 4, 1, 2);
insert into horarios values ( 1, 5, 3, 3);
insert into horarios values ( 2, 1, 5, 1);
insert into horarios values ( 2, 6, 6, 2);
insert into horarios values ( 2, 7, 4, 3);
insert into horarios values ( 2, 4, 4, 4);
insert into horarios values ( 3, 3, 3, 1);
insert into horarios values ( 3, 4, 2, 2);
insert into horarios values ( 3, 6, 1, 3);
insert into horarios values ( 3, 7, 5, 4);
insert into horarios values ( 3, 2, 4, 5);

insert into horarios values ( 4, 3, 2, 1);
insert into horarios values ( 4, 4, 1, 2);
insert into horarios values ( 4, 5, 3, 3);
insert into horarios values ( 5, 1, 5, 1);
insert into horarios values ( 5, 6, 6, 2);
insert into horarios values ( 5, 7, 4, 3);
insert into horarios values ( 5, 4, 4, 4);
insert into horarios values ( 6, 3, 3, 1);
insert into horarios values ( 6, 4, 2, 2);
insert into horarios values ( 6, 6, 1, 3);
insert into horarios values ( 6, 7, 5, 4);
insert into horarios values ( 6, 2, 4, 5);



