create database liga;
create table arbitro(
id_arbitro int,
nombre varchar(20),
apellido varchar(20),
constraint pk_arbitro primary key(id_arbitro)
);
create table equipo(
id_equipo int,
nombre_equipo varchar(40),
ciudad varchar(30),
web_oficial varchar(50),
id_capitan int,
constraint pk_equipo primary key(id_equipo)
);
create table jugador(
id_jugador int,
nombre varchar(20),
apellido varchar(20),
puesto enum("Escolta","Pivot","Alero","Base"),
fecha_alta date,
salario_bruto decimal(10,2),
id_equipo int,
constraint pk_jugador primary key(id_jugador)
);
create table partido(
e_visitante int,
e_local int,
fecha datetime,
resultado varchar(15),
id_arbitro int,
constraint pk_partido primary key(e_visitante,e_local,fecha)
);
insert into arbitro values ("1","Juan","López");
insert into arbitro values ("2","Mario","Martínez");
insert into arbitro values ("3","Alexa","Diéguez");
insert into arbitro values ("4","Ignacio","Castro");
insert into arbitro values ("5","Alma","Castrillón");
insert into arbitro  values ("6","Ángel","Cabana");
insert into arbitro  values ("7","José","Pérez");

insert into jugador values ("1","Juan Carlos","Navarro","Escolta","2010-01-10","130000","1");
insert into jugador values ("2","Felipe","Reyes","Pivot","2009-02-20","120000","2");
insert into jugador values ("3","Víctor","Claver","Alero","2009-03-08","90000","3");
insert into jugador values ("4","Rafa","Martínez","Escolta","2010-11-11","51000","3");
insert into jugador values ("5","Fernando","Emeterio","Alero","2008-09-22","60000","4");
insert into jugador values ("6","Mirza","Teletovic","Pivot","2010-05-13","70000","4");
insert into jugador values ("7","Sergio","Llull","Escolta","2011-10-29","100000","2");
insert into jugador values ("8","Víctor","Sada","Base","2012-01-01","80000","1");
insert into jugador values ("9","Carlos","Suárez","Alero","2008-10-12","60000","2");
insert into jugador values ("10","Xavi","Rey","Pivot","2012-01-21","95000","5");
insert into jugador values ("11","Carlos","Cabezas","Base","2010-05-13","105000","6");
insert into jugador values ("12","Pablo","Aguilar","Alero","2011-06-14","47000","6");
insert into jugador values ("13","Rafa","Hettsheimeir","Pivot","2008-04-15","53000","6");
insert into jugador values ("14","Sitapha","Savané","Pivot","2011-07-27","60000","5");

insert into equipo values ("1","Barcelona","Barcelona","www.fcbacelona.com","10");
insert into equipo values ("2","Real Madrid","Madrid","www.realmadrid.com","9");
insert into equipo values ("3","Valencia","Valencia","wwww.valenciabasket.com","11");
insert into equipo values ("4","Caja Laboral","Vitoria","www.baskonia.com","4");
insert into equipo values ("5","Gran Canaria","Las Palmas","www.acb.com","6");
insert into equipo values ("6","CAI Zaragoza","Zaragoza","www.basketzaragoza.net","14");

insert into partido values ("1","2","2011-10-10","100-100","4");
insert into partido values ("2","3","2011-11-17","90-91","5");
insert into partido values ("3","4","2011-11-23","88-77","6");
insert into partido values ("1","6","2011-11-30","66-78","6");
insert into partido values ("2","4","2012-12-01","90-90","7");
insert into partido values ("4","5","2012-01-19","79-83","3");
insert into partido values ("3","6","2012-02-22","91-88","3");
insert into partido values ("5","4","2012-04-27","90-66","2");
insert into partido values ("6","5","2012-05-30","110-70","1");

alter table equipo add constraint fk_equipo_jugador foreign key(id_capitan) references jugador(id_jugador);
alter table jugador add constraint fk_jugador_equipo foreign key(id_equipo) references equipo(id_equipo);
alter table partido add constraint fk_visitante foreign key(e_visitante) references equipo(id_equipo);
alter table partido add constraint fk_local foreign key(e_local) references equipo(id_equipo);
alter table partido add constraint fk_arbitro foreign key(id_arbitro) references arbitro(id_arbitro);

/*Modificar tablas - aler table nombre_table
modificar tabla añadiendo columna nueva*/
alter table arbitro add column telefono varchar(9) null;
-- modificar tabla borrando una columna
-- alter table arbitro drop column lefefono;
-- modificar tabla cambiando nombre columna
 alter table arbitro rename column telefono to telf;
 -- modificar tabla cambiando el tipo de dato de una columna. varchar a int
 alter table arbitro modify telf int;
 -- modificar una tabla y cambiar su nombre
 -- rename table arbitro to arbitros;
 /*clausura select permite realizar consultas en una base de datos
 En una consulta es obligatorio usar Selet y usar from
 Select: mostrar las columnas que se le piden. Las clumnas iran separadas por comas
 from: indica de que tabla o tablas quiero sacar los datos.*/
 select nombre, apellido from arbitro;
select * from arbitro; -- selecciona todas las columnas

-- alias de columna: darle un nombre a una columna, pero no modifica la tabla original. solo es para visualizar.alter
select id_arbitro as ID, nombre as NOMBRE, apellido as APELLIDO from arbitro;

-- all/ distinct
-- all es como si no ponemos nada, porque es el valor por defecto, muestra todos los datos aunque estén repetidos
-- distinct muestra solo los valores sin repetir
select distinct nombre from arbitro;

-- where filtra filas de datos, hay que pasarle una o varias condiciones. 
-- select col, col from tabla where condiciona1 operadorlog condicion...;
-- operadores: logicos(and, or, not, between, not between, in, not in) y aritmeticos(=,<,>,!=,)
select nombre from jugador where salario_bruto>=120000;
select nombre_equipo from equipo where id_capitan!=10;
select nombre,apellido,salario_bruto from jugador where salario_bruto>=100000 and salario_bruto<=120000;
-- where salario_bruto between 100000 and 120000;
select nombre_equipo, web_oficial from equipo where id_equipo not between 1 and 3 and nombre_equipo="caja laboral" or nombre_equipo="gran canaria";
-- in ("caja laboral", "gran canarias");
select resultado from partido where fecha not between "2011-01-01" and "2011-12-31" and id_arbitro=3;
-- operador like y not like compara cadenas pero utiliza el %,_ y permite que esa comparación no sea tan restritiva
select id_arbitro, nombre, apellido from arbitro where nombre like "juan"; -- = nombre="juan";
select * from arbitro where nombre like "j";
-- % indica que podria haber cualquier caracter
select * from arbitro where nombre like "j%";
-- _ indica que tiene que haber un caracter cuando se escribe un guión. cada guion indica un espacio.
select * from arbitro where nombre like "A__a";

-- order by: ordena el resultado de las consultas
-- Podemos ordenar asdendente asc(valor por defecto) desc descendente
-- se coloca despues del where si es que lo hay
-- podemos ordenar por cualquier columna/s de nuestra tabla y van entre comas. nombre, apellido
select * from jugador order by nombre desc;
-- podemos ordenar en lugar de por el nombre de la columna , por un numero
select nombre,apellido,puesto from jugador order by 1 desc;

-- Calculos en el select y en el where
-- muestra el nombre, apellido, salario, salario bruto anual de los jugadores
select nombre, apellido, salario_bruto, salario_bruto*12 as "salario anual" from jugador;
select nombre, apellido, puesto, salario_buro as "salario inicial", salariorio_bruto+200 as "salario con subida" from jugador where puesto like "pivot";
-- funciones numéricas, cadenas, de fechas
-- funciones númericas: nnúmeros simples, con un conjunto de valores(columnas), listado de valores
-- las funciones se llaman en el select
-- abs(num): devuleve el valor absoluto
-- ceil(num): devuelve el entero superior
-- floor(num): devuelve el entero inferior
-- round(num, dec):num es el numero que quereis redondear y dec son los decimales
-- sign(num): se le pasa un numero y comrpueba su simbolo. Si es negativo devuelve -1, si es positivo devuelve 1, si es 0 devuelve 0

-- Funciones numericas a las que se les pasa un conjunto de valores (columna) y van a devolver un unico valor
-- avg: media, min: del minimo, max: el maximo, sum: devuelve la suma de los valores, count: devuelve el conteo de filas.

select abs(-5);
select abs(id_arbitro) from arbitro;
select nombre, floor (salario_bruto) from jugador;
select nombre, round(salario_bruto,1) from jugador;
select sign(-4);
select round(sum(salario_bruto),0) from jugador;
select min(salario_bruto) as "salario minimo", max(salario_bruto) as"salario maximo" from jugador;
-- cuenta las filas que tiene la tabla jugador
select count(*) from jugador;
select count(distinct nombre) from jugador;

-- 1º
select * from equipo;

-- 2º
select nombre as "NOMBRE JUAGDOR" from jugador;

-- 3º
select nombre,apellido,puesto from jugador order by puesto desc;

-- 4º
select nombre,id_equipo,puesto from jugador order by 2,3;

-- 5º
select distinct puesto from jugador;

-- 6º
select * from jugador limit 5;

-- 7º
-- limit(3,5) 3 desde que registro quieres emezar y 5 es el num de registros que uieres visualizar
select * from jugador limit(3,5);

-- 8º
select upper(nombre), roundsalario_bruto*12 as "salario anual" from jugador;

-- 9º
select  nombre from jugador where puesto like "pivot";
select  nombre from jugador where puesto like in ("pivot");
select  nombre from jugador where puesto="pivot";

-- 10º
select * from jugador where id_equipo!=3;
select * from jugador where id_equipo<>3;
select * from jugador where id_equipo not like 3;
select * from jugador where id_equipo not in 3;

-- 11º
select * from equipo where web_oficial is null;

-- 12º
select * from equipo where ciudad not like "valencia" and ciudad not like "madrid";
select * from equipo where ciudad not in ("valencia","madrid");

-- 13º
select * from jugadores where puesto in ("pivot","escolta","base");

-- 14º
select * from jugador where id_equipo not in (1,2,3);

-- 15
select * from partido where fecha like "2012-02-%";
select * from partido where fecha  between "2012-02-01" and "2012-02-29";
select * from partido where year(fecha)=2012 and month(fecha)=2;

-- 16º
select * from jugador where nombre like "________%";

-- 17º
select * from jugador where nombre like "fe%";

-- 18
select * from arbitro where nombre like "%l";

-- 19


-- 20

-- 21º
select truncate(avg(salario_bruto),0) from jugador where salario_bruto > 85000;

-- 22º
-- count(pasarle un columna pk)
select count(id_jugador) from jugador where salario_bruto>90000; 

-- 23ºalter
select min(salario_bruto) as "min" ,max(salario_bruto) from ju

-- 24º
select * from jugador where salario_bruto>(
select salario_bruto from jugador where apellido="Teletovic");

-- 25º
select * from jugador where id_equipo=(select id_equipo from equipo where ciudad="las palmas");

-- 26º
select nombre, apellido from jugador where id_equipo=
(select id_equipo from equipo where id_capitan=(select id_jugador from jugador where nombre="Carlos" and apellido="Suárez"));

-- 27º
select count(*) from jugador where salario_bruto>(select avg(salario_bruto) from jugador);

-- 28º
select nombre, apellido, salario_bruto from jugador where salario_bruto between 
(select min(salario_bruto) from jugador where puesto="pivot") and
 (select max(salario_bruto) from jugador where puesto="pivot");
 
 -- 29º
 select apellido from jugador where puesto in (
 select puesto from jugador where id_equipo = "3");
 
 -- 30º
 select * from jugador where id_equipo= (select id_equipo from equipo where nombre_equipo="Zaragoza");
 
 -- 31º
 select nombre from jugador where salario_bruto> (select max(salario_bruto) from jugador where id_equipo="2");
 
 -- 32º
 select * from jugador where salario_bruto>(select max(salario_bruto) from jugador where id_equipo="5");
 
 -- 33º
 select count(*) from jugador where id_equipo=(select id_equipo from equipo where ciudad="Madrid");
 
 -- 34º
 
-- 35. Datos de equipo y número de partidos que han jugado como locales.
select equipo.*, count(partido.fecha) as jugados_local from equipo join partido on(id_equipo=e_local) group by e_local;
-- 36. Datos de los equipos con más de 2 jugadores registrados.
select nombre_equipo, count(id_jugador) from equipo join jugador using(id_equipo) group by nombre_equipo having count(id_jugador)>2;
-- 37. Nombre de todos los equipos y datos de sus partidos como locales en caso de haberlos.
select nombre_equipo,count(*) from equipo join partido on(id_equipo=e_local) group by nombre_equipo having count(e_local)>0 ;
-- 38. Datos de equipo y salario máximo entre sus jugadores.
select nombre_equipo, max(salario_bruto) from equipo join jugador using(id_equipo) group by id_equipo;
-- 39. Datos del partido con mayor puntuación.
select * from partido
where substr(resultado,1,locate("-",resultado)-1) + substr(resultado,locate("-",resultado)+1)=
(select max(substr(resultado,1,locate("-",resultado)-1) + substr(resultado,locate("-",resultado)+1)) from partido);

(select max(substr(resultado,1,locate("-",resultado)-1) + substr(resultado,locate("-",resultado)+1)) from partido);
-- 40. Nombre y número de victorias de cada equipo.
-- 41. Calcula el número de jugadores por equipo que cobra menos que el salario medio de todos los jugadores
select nombre_equipo, count(id_jugador) from equipo join jugador using(id_equipo)where salario_bruto<(select avg(salario_bruto) from jugador)group by nombre_equipo;
--  42. Mostrar ordenados por nombre, los nombres de los jugadores de los equipos 1 y 2 (es decir, primero se muestran los jugadores del equipo 1 y a continuación los del equipo 2 ordenados).
-- 43. Obtener el número de ciudades en las que hay equipos.
-- 44. Número de partidos ganados por equipos locales.
-- 45. Nombre de jugadores que empiecen por A y tengan al menos dos vocales.
-- 46. Datos del último partido incluyendo el nombre de los equipos y jugadores
-- 47. Datos del equipo y del capitán para equipos que hayan jugados más de 2 partidos como visitantes.
select nombre_equipo, jugador.nombre, count(*) from equipo join partido on (id_equipo=e_visitante) join jugador on (id_jugador=id_capitan) group by nombre_equipo,jugador.nombre having  count(*)>2; 
-- 48. Realizar una consulta para mostrar los equipos que no han jugado ningún partido como locales.