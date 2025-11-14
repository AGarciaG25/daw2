-- Comentario en una línea
/*
comentario
en
varias
lineas
*/
/* Lenguaje SQL
DDL - create, alter, drop
DML - insert, update, delete
DCL - grante, revoke
*/
/*
NORMAS ESCRITURA SQL:
toda instrucción acaba ;
Da igual mayus / minus
Los nomebres de bd, tablas, sean representativos, no tengan más 30 caract, no
símbolos especiales, no tildes ;
No podemos usar palabras reservadas com nombres, table;
No podemos crear bases, tablas con el mismo nombre porque dar error ;
*/
/*
Crear BBDD
create database/schema nombre_base;
*/
create database escuela;
/*
Eliminar BD
drop database/schema nombre_base;
*/
/* Mostrar todas las base de datos que hay
show databases;
*/
/*
Crear BBDD
create database/schema nombre_base;
*/
create database hospital;
/*

Eliminar BD
drop database/schema nombre_base;
*/
/*
Crear BBDD
create database/schema nombre_base;
*/
create database ambulatorio;
/*
Eliminar BD
drop database/schema nombre_base;
*/
-- Posicionarse en una BD
use escuela;
/*
Crear table
create table nombre_table(
atributo tipoDato restricciones,
atributo tipoDato restricciones,
atributo tipoDato restricciones,
atributo tipoDato restricciones
);
*/
/*
restriccion obligatoriedad, se indica con null o not null

*/
create table alumnos(
codigo int not null,
nombre varchar(5) not null
);
/*Borrar una tabla
drop table alumnos;
*/
/*crear table con clave primaria PK */
-- primera forma
create table alumnos(
codigo int not null primary key,
nombre varchar(5) not null
);

-- segunda forma
create table alumonos(
codigo int not null,
nombre varchar(5) not null,
constraint pk_alumnos primary key(codigo)
);
/*Tabla profesores: codigo entero clave primaria, dni varchar(9) clave candidata,
nombre varchar(30), falta tipo fecha
departamento puede tener nulos varchar(20) (y por defecto el departamento es
informatica)
cuando hagamos un ejercicio sino indico que puede o no tener nulos, lo tomamos
como que no puede tener nulo*/
create table profesores(
codigo int not null auto_increment,
dni varchar(9) profesoresnot null,
nombre varchar(30) not null,
falta date not null,
departamento varchar(20) not null default "informatica",
constraint pk_profesores primary key(codigo),
constraint uk_profesores unique(dni)
);
/*Los codigos, a veces queremos que sean autoincrementales, es decir que yo no
los tenga que insertar y que cada vez
que inserto una fila */
/*Tabla asignaturas: codigo int clave primaria, nombre varchar(20), ciclo solo puede
ser DAM o DAW,
horas entero, créditos decimal con 1 dígito decimal*/
/* decimal(totaldigitos, digitosdecimales) 10,25 decimal (4,2)*/
create table asignaturas(
codigo int not null auto_increment,
nombre varchar(20) not null,
ciclo enum("DAM", "DAW") not null,
horas int not null,
creditos decimal(3,1),
constraint pk_asignaturas primary key(codigo)
);
-- restricción check sobre una o varias columnas.
-- crear una tabla con una clave primaria formada por dos columnas

create table hospital(
codigo int not null auto_increment,
constr
)?
-- visualizar la creación de una tabla
describe profesores;
create table fichaMedica(
codFicha int not null, -- parte de la clave pk
codProfesor int not null, -- parte de la clave pk
alergias boolean not null,
grupoSanguineo varchar(5) not null,
constraint pk_fichaMedica primary key(codFicha, codProfesor)
);
-- Restricciones check de comprabación
-- el stock tiene ser mayor que 0
-- precio material mayor que 0
create table material(
codMaterial int not null auto_increment,
nombre varchar(50) not null,
stock int not null, -- check(stock>0),
precio decimal(6,2) not null, -- check(precio>0)
constraint ck_stock check(stock>0),
constraint ck_precio check(precio>0), -- puedo poner más de una condición
constraint pk_material primary key(codMaterial)
);

/* Esta tabla es igual que la de arriba
create table profesores(
codigo int not null primary key,
dni varchar(9) not null unique,
nombre varchar(30) not null,
falta date not null,
departamento varchar(20) not null default "informatica",
)?

BUSCA TESORO

create database buscaTesoro;
use buscaTesoro;
/*1- Crear tablas con estructura y restricciones (not null, default, auto_increment, pk,
unique, check)*/
create table piratas(
idPirata int not null auto_increment,
nonmbre varchar(50) not null,
apodo varchar(50) not null,
edad int not null,
maldad enum("malisimo", "buenisimo") not null default "malisimo",
barba varchar(10) null,
constraint pk_piratas primary key(idPirata),
constraint uk_apodo unique(apodo),
constraint ck_edad check(edad>16)
);
describe piratas; -- muestra la creacion de la tabla
show tables; -- lista las tablas creadas
create table tesoro(
idTesoro int not null auto_increment,
nombre varchar(50) not null,
tipo enum("baratija", "valioso") not null default "baratija",
precioActual decimal(10,2) not null,
idPirata int null, -- clave foramea
constraint pk_tesoro primary key(idTesoro),
constraint ck_precio check(precioActual>0)
);
-- crear tabla isla
-- crear tabla islaPirata o descubrir
create table isla(
Coorx int not null,
Coory int not null,
nombre varchar(50) not null,
ubicacion varchar(100) not null,
constraint pk_isla primary key(coorx)
);

create table inspecionar(
idPirata int not null, -- foranea proviene de piratas
coorx int not null, -- foranea proviene de isla
coory int not null, -- foranea proviene de isla
fecha date not null,
duracion int not null,
constraint pk_inspecionar primary key(idPirata, coorx, fecha)
);
describe isla;
/*2 Insertar datos*/
/*3 Modificar las tablas necesarias para crear/añadir la claves forâneas*/
-- alter modificamos tabla, alter nombre_tabla
alter table tesoro add constraint fk_pirata_tesoro foreign key(idPirata) references
piratas(idPirata);
alter table inspecionar add constraint fk_inspecionar_pirata foreign key(idPirata)
references piratas(idPirata);
alter table inspecionar add constraint fk_inspecionar_isla foreign key(coorx)
references isla(coorx);
-- alter table inspecionar add constraint fk_isla_inspecionar foreign key(coory)
references isla(coory);

LA LIGA

create database laLiga;
use laLiga;
create table arbitros(
id_arbitro int not null,
nombre varchar(50) not null,
apellido varchar(50) not null,
constraint pk_arbitros primary key(id_arbitro)
);
create table equipos(
id_equipo int not null,
nombre_equipo varchar(50) not null,
ciudad varchar(20) not null,
web_oficial varchar(100) not null,
id_capitan int not null,
constraint pk_equipos primary key(id_equipo)
);
create table jugadores(
id_jugador int not null,
nombre varchar(50) not null,
apellido varchar(50) not null,
puesto varchar(100) not null,
fecha_alta date not null,
salario_bruto decimal(20,2) not null,
id_equipo int not null,
constraint pk_jugadores primary key(id_jugador)
);
create table partidos(
e_visitante int not null,
e_local int not null,
fecha datetime not null,
resultado varchar(200) not null,
id_arbitro int not null,
constraint pk_jugadores primary key(e_visitante, e_local, fecha)
);

insert into arbitros values ("1","Juan","López");
insert into arbitros values ("2","Mario","Martínez");
insert into arbitros values ("3","Alexa","Diéguez");
insert into arbitros values ("4","Ignacio","Castro");
insert into arbitros values ("5","Alma","Castrillón");
insert into arbitros values ("6","Ángel","Cabana");
insert into arbitros values ("7","José","Pérez");
insert into equipos values ("1","Barcelona","Barcelona","www.fcbacelona.com","10");
insert into equipos values ("2","Real Madrid","Madrid","www.realmadrid.com","9");
insert into equipos values
("3","Valencia","Valencia","wwww.valenciabasket.com","11");
insert into equipos values ("4","Caja Laboral","Vitoria","www.baskonia.com","4");
insert into equipos values ("5","Gran Canaria","Las Palmas","www.acb.com","6");
insert into equipos values ("6","CAI
Zaragoza","Zaragoza","www.basketzaragoza.net","14");
insert into jugadores values ("1","Juan
Carlos","Navarro","Escolta","2010-01-10","130000","1");
insert into jugadores values ("2","Felipe","Reyes","Pivot","2009-02-20","120000","2");
insert into jugadores values ("3","Víctor","Claver","Alero","2009-03-08","90000","3");
insert into jugadores values
("4","Rafa","Martínez","Escolta","2010-11-11","51000","3");
insert into jugadores values
("5","Fernando","Emeterio","Alero","2008-09-22","60000","4");
insert into jugadores values ("6","Mirza","Teletovic","Pivot","2010-05-13","70000","4");
insert into jugadores values ("7","Sergio","Llull","Escolta","2011-10-29","100000","2");
insert into jugadores values ("8","Víctor","Sada","Base","2012-01-01","80000","1");
insert into jugadores values ("9","Carlos","Suárez","Alero","2008-10-12","60000","2");
insert into jugadores values ("10","Xavi","Rey","Pivot","2012-01-21","95000","5");
insert into jugadores values
("11","Carlos","Cabezas","Base","2010-05-13","105000","6");
insert into jugadores values ("12","Pablo","Aguilar","Alero","2011-06-14","47000","6");
insert into jugadores values
("13","Rafa","Hettsheimeir","Pivot","2008-04-15","53000","6");
insert into jugadores values
("14","Sitapha","Savané","Pivot","2011-07-27","60000","5");

insert into partidos values ("1","2","2011-10-10","100-100","4");
insert into partidos values ("2","3","2011-11-17","90-91","5");
insert into partidos values ("3","4","2011-11-23","88-77","6");
insert into partidos values ("1","6","2011-11-30","66-78","6");

insert into partidos values ("2","4","2012-12-01","90-90","7");
insert into partidos values ("4","5","2012-01-19","79-83","3");
insert into partidos values ("3","6","2012-02-22","91-88","3");
insert into partidos values ("5","4","2012-04-27","90-66","2");
insert into partidos values ("6","5","2012-05-30","110-70","1");
/*Crear las claves foraneas*/
alter table equipos add constraint fk_equipos_jugadores foreign key(id_capitan)
references jugadores(id_jugador);
alter table jugadores add constraint fk_jugadores_equipos foreign key(id_equipo)
references equipos(id_equipo);
alter table partidos add constraint fk_partidos_equipos foreign key(e_visitante)
references equipos(id_equipo);
alter table partidos add constraint fk_partidos_equipos2 foreign key(e_local)
references equipos(id_equipo);
alter table partidos add constraint fk_partidos_arbitros foreign key(id_arbitro)
references arbitros(id_arbitro);
/*Modificar tablas - alter table nombre_table*/
-- Modificar table arbitro anadiendo columna nueva telf nuull varchar(9)
alter table arbitros add column telefono varchar(9) null;
alter table arbitros add column edad int not null;
-- Modificar tabla borrando una columna
alter table arbitros drop column edad;
-- Modificar tabla cambiando nombre de columna, telefono por telf
alter table arbitros rename column telefono to telf;
-- Modificar tabla cambiando el tipo de dato de una columna, varchar a int
alter table arbitros modify column telf int; /*no esta nos apuntes!*/
-- Modificar una tabla y cambiar su nombre
rename table arbitros to arbitro;
/*Clausula Select: permite realizar consultas de datos en un BBDD
En una consulta es obligatorio usar Select y usar from!!!
Select: mostrar las columnas / atributos que se le piden. Las columnas irán
separadas por comas
(nombre de una columna de una tabla)
from: de que tabla o tablas quiero sacar los datos
*/

Select nombre from arbitros;
Select nombre, apellido, id_arbitro from arbitros;
alter table arbitros drop column telf;
select * from arbitros; -- * selecciona todas las columnas de la tabla que indico en
from
select * from jugadores;
-- Alias de columna: darle un nombre a una columna, pero no modifica la tabla
original, solo es para visualizar.
select id_arbitro as ID, nombre as NOMBRE, apellido as APELLIDO from arbitros; --
cuando son dos palabras pone entre " por ejemplo: "ID ARBITRO.
-- all / distinct
-- all es como si no ponemos nada, porque es el valor por defecto, muestra todos os
datos aunque estén repetidos
-- distinct muestra solo los datos sin repetirse
select distinct nombre from arbitros;
select all nombre from arbitros;
-- where: filtra filas de datos, hay que pasarle una o varias condiciones.
-- sintaxis: select col, col, col from tabla where condicion operadorlog condicion......;
-- operadores: lógicos (and, or, not, between, not between, in, not in) y aritméticos (=
!= <> > > >= >0)

select nombre as "NOMBRE ARBITRO", apellido as "APELLIDO ARBITRO" from
arbitros where id_arbitro=4;
-- nombre de los jugadores con salario mayor que 120000
select nombre as "NOMBRE JUGADOR" from jugadores where
salario_bruto>120000;
-- muestra los nombres de equipos que tengan el id_capitan distinto de 10
select nombre_equipo as "NOMBRE" from equipos where id_capitan!=10;
select nombre_equipo as "NOMBRE" from equipos where id_capitan<>10;
-- muestra el nombre, apellido, salario de los jugadores cuyo salario esté entre
100000 y 120000
select nombre, apellido, salario_bruto from jugadores where salario_bruto>=100000
and salario_bruto<=120000;
-- forma equivalente
select nombre, apellido, salario_bruto from jugadores where salario_bruto between
100000 and 120000;

-- muestra el nombre de equipo y la web de aquel/llos equipos cuyo id no sea 1, 2, 3
y cuyo nombre sea Caja Laboral o Gran Canaria
select nombre_equipo as "NOMBRE", web_oficial as "WEB" from equipos
where id_equipo not between 1 and 3 and nombre_equipo="Caja Laboral" or
nombre_equipo in ("Caja Laboral","Gran Canaria");
select nombre_equipo from equipo where id_equipo not between 1 and 3 and nombre_equipo="caja laboral" or nombre_equipo="gran canaria";
-- muestra el resultado de los partidos que no se hayan jugado durante el año 2011
y que haya arbitrado el arbitro 3
select resultado from partidos where fecha not between "2011-01-01" and
"2011-12-31" and id_arbitro=3;
-- o
select resultado from partidos where fecha>"2011-12-31" and "<2011-01-01" and
id_arbitro=3;
-- operador like y not like para compara cadenas pero utiliza %, _y permite que esa comparación no sea tan restrictiva.
select id_arbitro, nombre, apellido from arbitros where nombre="juan";
select id_arbitro, nombre, apellido from arbitros where nombre like "juan";
-- Datos de los árbitros que empiecen por letra J
-- % : indica que podría haber cualquier caracter
select * from arbitros where nombre like "J%";
-- la palabra tiene que tener por lo menos hay una j
select * from arbitros where nombre like "%J%";
-- finalice con la letra a
select * from arbitros where nombre like "%a";
-- _guión bajo, indica que tiene que haber un caracter cuando se escriba un guión
-- Datos de los arbitros que tenga el nombre 4 letras y empiecen y acaben por a
select * from arbitros where nombre like "A__a";
-- Nombres de árbitros con nombre distinto de 5 letras (hay 5 guions abajo)
select * from arbitros where nombre not like "_____";
-- Order by: ordena el resultado de las consultas
-- Podemos ordenar ascendente asc (valor por defecto) desc descendente
-- se coloca después del where si es que lo hay!!!
-- podemos ordenar por cualquier columana/s de nuestra tabla y van entre comas,
nombre, apellido

-- Mostrar todos los datos de los jugadores ordenados por nombre y apellido de
jugador desc
select * from jugadores order by nombre desc;
select * from jugadores order by apellido desc;
-- Podemos ordenar en lugar de por el nombre de la columna por un numero
select * from jugadores order by 2 desc;
select nombre, apellido, puesto from jugadores order by id_equipo desc;

-- EJERCÍCIOS
-- 1. Obtén todos los datos de todos los equipos.
select * from equipos;
-- 2. Obtén el nombre de todos los jugadores en una columna llamada “NOMBREJUGADOR”.
select nombre as "NOMBRE JUGADOR" from jugadores;
-- 3. Selecciona los nombres, apellido y posición de todos los jugadores ordenados
por posición descendentemente.
select nombre, apellido, puesto from jugadores order by puesto desc;
-- 4. Selecciona los nombres, equipo y posición de todos los jugadores ordenados
Select nombre, id_equipo, puesto from jugadores order by id_equipo, puesto (2,3);
es para poner los numeros no lugar
-- 5. Selecciona los distintos puestos de los jugadores.
Select distinct puesto from jugadores;
-- 6. Selecciona los 5 primeros registros de la tabla jugador.
-- limit 5(limita la visulaizacion a 5 registros)
Select * from jugador limit 5;
-- 7. Selecciona 5 registros de la tabla jugador a partir del tercer registro.
-- limit 3,5 -> desde que registro quieres empezar a visualizar y 5 es el numero de
registros a visualizar

Select * from jugadores limit 3,5;
-- 8. Selecciona el nombre y el salario anual (salario*12) de los jugadores, llama a la proyección de la columna Salario Anual.
*/ -- round(numero, numdec)
Select upper(nombre), round(salario_bruto,0), round(salario_bruto*12,0) as "Salario
Anual" from jugadores;
-- 9. Selecciona el nombre y apellido de los jugadores que sean Pivot.
Select nombre, apellido from jugadores where puesto="Pivot";
Select nombre, apellido from jugadores where puesto like "Pivot";
Select nombre, apellido from jugadores where puesto in ("Pivot");
-- 10. Selecciona los datos de los jugadores que no pertenezcan al equipo 3.
Select *from jugadores where id_equipo!=3;
Select *from jugadores where id_equipo<>3;
Select *from jugadores where id_equipo not like 3;
Select *from jugadores where id_equipo not in (3);
-- 11. Selecciona los datos de los equipos cuya web es nula.
Select *from equipos where web_oficial is null;
/* Selecciona los datos de los equipos cuya web no sea nula.*/
Select *from equipos where web_oficial is not null;
-- 12. Selecciona los datos de los equipos menos los de Valencia y de Madrid.
Select * from equipos where ciudad not like "Valencia" and ciudad not like "Madrid";
Select * from equipos where ciudad not in ("Valencia","Madrid");
Select * from equipos where ciudad!= "Valencia" and ciudad!= "Madrid";
-- 13. Selecciona los datos de los jugadores “pivot”, “escolta” y “base”
Select * from jugadores where puesto in ("Pivot","Escolta","Base");
Select * from jugadores where puesto like "Pivot" or puesto like "Escolta" or puesto
like "Base";
Select * from jugadores where puesto="Pivot" or puesto="Escolta" or puesto="Base";
-- 14. Obtener datos de todos los jugadores menos los de los equipos uno, dos y
tres.

Select * from jugadores where id_equipo not in (1,2,3);
-- 15. Obtener los datos de los partidos jugados en febrero del 2012.
Select * from partidos where fecha like "2012-02-%";
Select * from partidos where fecha between "2012-02-01" and "2012-02-29";
-- funciones de fechas now(), current_timestamp(), current_date(), curdate(), year(),
month()
Select year(fecha) from partidos;
Select month(fecha) from partidos;
Select * from partidos where year(fecha)=2012 and month(fecha)=2;
-- 16. Selecciona los datos de los jugadores cuyo nombre tenga por lo menos 7
letras.
Select * from jugadores where nombre like "_______%";
-- 17. Selecciona los datos de los jugadores cuyo nombre empiece por las letras Fe.
Select * from jugadores where nombre like "Fe%";
-- 18. Selecciona los datos de los árbitro cuyo nombre acabe por la letra l
Select * from jugadores where nombre like "%1";
-- 19. Selecciona los datos de los equipo que empiecen por “B o por R”
Select * from equipos
-- 20. Selecciona el nombre, el salario y el salario redondeado sin dígitos decimales
en lugar de dos.

-- 21. Selecciona la media del salario de los jugadores que superen los 85000 euros.
-- avg, max, min, count, sum;
Select truncate(avg(salario_bruto),0) as "MEDIA SALARIO" from jugadores where
salario_bruto > 8500;
22. Cuenta los jugadores que superan el salario de 90000
-- count(columna que sea clavepk)
Select count(*) from jugadores where salario_bruto>90000;
23. Selecciona el salario máximo y el mínimo de los jugadores, llama a las columnas
SALARIO MÁXIMO y SALARIO MÍNIMO.

Select min(salario_bruto) as "MINIMO", max(salario_bruto) as "MAXIMO" from
jugadores;
Select min(salario_bruto) as "MINIMO", max(salario_bruto) as "MAXIMO" from
jugadores where puesto like "Pivot";
24. Selecciona los datos de los jugadores que tengan mayor salario que el salario
del jugador “Teletovic”.
/*1. crea una consulta que me devuleve el salario de Teletovic*/
Select salario_bruto from jugadores where apellido="Teletovic";
/* crea una consulta que me devuelva los datos de los jugadores que cobran mas de
70000*/
Select * from jugadores where salario_bruto > (select salario_bruto from jugadores
where apellido="Teletovic");

25. Selecciona los datos de los jugadores cuyo equipo esté en Las Palmas.
26. Selecciona el nombre y apelido de los jugadores que tengan como capitán a
Carlos Suárez
27. Calcula el número de jugadores que cobra más que el salario medio de todos
los jugadores.
28. Selecciona el nombre, apellido y salario de los jugadores cuyo salario esté
entre los salarios de los jugadores de puesto Pivot.
29. Selecciona el apellido de los jugadores que tengan cualquier posición como las

-- Cálculos en el select
-- muestra el nombre, apellido, salario bruto anual (*12) de los jugadores
select nombre, apellido, salario_bruto, salario_bruto*12 as "SALARIO BRUTO
ANUAL" from jugadores
where (salario_bruto*12)>100000;
-- crea una consulta que muestre nombre, puesto, salario_bruto "Salario inicial",
"salario con subida" + 200 a los PIVOT
select nombre, puesto, salario_bruto as "SALARIO INICIAL", salario_bruto+200 as
"SALARIO CON SUBIDA"
from jugadores where puesto like "Pivot";
-- FUNCIONES numericas, cadenas, fechas
-- Funciones numericas: números simples, con un conjunto de valores (columnas),
listado de valores

/*
Las funciones se llaman en select
abs(num): devulve el valor absoluto - de negativo para positivo
ceil(num): devuelve el entero superior
floor(num): devuelve el entero inferior
round(num,dec): num es el numero que quereis redondear y dec son los digitos
decimales
sign(num): se le pasa un número y comprueba su signo, si es negativo devuelve -1,
si es positivo devuelve 1, si es 0 devuleve 0
*/
select abs(-5) as "VALOR ABSOLUTO";
select abs(id_arbitro) from arbitros;
select ceil(3.46) as "ENTERO SUPERIOR";
select nombre, puesto, floor(salario_bruto) as "SALARIO INICIAL",
ceil(salario_bruto+200) as "SALARIO CON SUBIDA"
from jugadores where puesto like "Pivot";
-- lo mismo pero usad round y 1 decimal
select nombre, puesto, round(salario_bruto1) as "SALARIO INICIAL",
round(salario_bruto+200) as "SALARIO CON SUBIDA"
from jugadores where puesto like "Pivot";
select sign(-4);
select sign(4);
select sign(0);
select sign(id_arbitro) from arbitros;
-- Funciones numericas a las que se les pasa un conjunto de valores (columna de
una tabla) y van devuelver un único valor!!
/*
avg: devuelve la media
min: devuelve el valor minimo
max: devuelve el valor máximo
sum: devuelve la suma de los valores
count: devuelve el conteo de filas
*/
-- media de salario de los jugadores
-- Anidar funciones meter función dentro de otra, Definición: round(num, dec)
select round(avg(salario_bruto),2) as "MEDIA" from jugadores;

-- mostrarme el nombre del jugador y salario que tiene el salario minimo
select round(min(salario_bruto),0) as "SALARIO MINIMO",
round(max(salario_bruto),0) as "SALARIO MAXIMO", sum(salario_bruto)
from jugadores;
-- count devuelve un numero que es el conteo de filas de la columna que se le pasa
select count(id_jugador) from jugadores;
-- all / distinct - contar los nombres distintos de los jugadores
select count(distinct nombre) from jugadores;
-- cuenta las filas que tiene la tabla jugadores;
select count(*) from jugadores;
select concat("Hola" ,nombre," ",apellido) as "SALUD" from jugadores;
-- funciones numericas con lista de valores
-- greatest(v1, v2, v3.....) devuelve el maximo
-- least(v1, v2, v3........) devuelve el valor minimo
select greatest(2,5,77,100,3,-2) as "VALOR MAXIMO";
select greatest(id_jugador, salario_bruto, id_equipo) as "VALOR MAXIMO" from
jugadores;
select least(2,3,4,-3,100,-40) as "VALOR MINIMO";
-- round(numero, numerodecimales)
select round(least(id_jugador, salario_bruto, id_equipo),0) as "VALOR MINIMO" from
jugadores;
-- Funciones con cadenas
-- upper(cadena): convertir a mayusculas
-- lower(cadena): convertir a minusculas
-- initcap en mysql no funciona, NO
select upper("hola") as "MAYSCULAS", lower("HOLA") as "MINUSCULAS";
select upper(nombre), upper(apellido), lower(puesto) from jugadores;
-- concat(c1,c2,c3.....) une cadenas
select concat (nombre," ", apellido, " tiene el puesto ",puesto) as "PRESENTACION
JUGADOR" from jugadores;
-- chr no y ascii no
-- lenght(cadena); devuelve la longitud de una cadena

select length(" hol ");
select nombre, length(nombre) as "Longitud nombre" from arbitros;
-- trim (eliminar los espacios de una cadena, de antes y después), Itrim, rtrim
select length(" hola ");
select length(trim(" hola "));
-- substr(cadena, posinicial, posfinal) corta una cadena
-- si omitimos las posicion final cortara toda la cadena desde las posicion inicial
indicada
select concat(upper(substr(nombre,1,1)),lower(substr(nombre,2))) as "NOMBRE
JUGADOR" from jugadores;
-- crea una consulta que muestre el resultado del equipo visitante
select position("-" in resultado) from partidos;
select locate("-",resultado) from partidos; -- 1 paso localizar la posicion del guion!!!
-- 2 cortar la cadena resultado hasta el guion porque eso sera el resultado del
visitante
select substr(resultado,1,locate("-",resultado)-1) as "RESULTADO VISITANTE" from
partidos;
-- replace(cadena, cad1, cadnueva)
select replace("Hola Mundo","Mundo","Pepe");
-- reemplazar el - del resultado por /
select replace(resultado,"-","/") from partidos;
-- funciones de fecha, necesitan un tipo date
-- now(), current_timestamp fecha y hora del sistema
select now();
select current_timestamp();
-- curent_date(), curdate() la fecha del sistema
select current_date(), curdate();
-- year(date) extrae el ano de una fecha
select year(now());
-- crea una consulta que muestre el nombre, apellido del jugador y los anos que
lleva de alta
select nombre, apellido, year(now())-year(fecha_alta) as "Anos de alta" from
jugadores;

-- month(date), hour(date), minute(date), day(date).....
select year(now()), month(now()), day(now());