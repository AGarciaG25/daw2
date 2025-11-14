
/*variables:
globales o del sistema: se representa con el prefijo @@, @@autoconmit, @@version, @@max_connections, etc...
se muestran show variables
se puede cambiar su valor con set
puedo ver su valor con select*/

show variables;
set autocommit=0;
select @@autocommit;
select @@versions, @@max_connections;

/* Variables definidas por el usuario
Se representan con @, las tenemos que crear nosotros
para crear la variable utilizamos set. Sintaxis: set @nombre_variable:=valor;
nombres posibles: cualquier nombre representativo,no distingue entre mayusculas y minusculas,
@suma = @SUMA
En las variables no se indica el tipo de dato (cadena, entero,decimal...)
para ver el contenido de las variables select
duracion: duran hasta que se cierre la sesion, y cada usuario verá sus variables creadas
se puede cambiar su valor una vez creadas, con el set como en la creaccion
no hay una instruccion para listar las variables definidas por el usuario.
las variables pueden formr pasrte de una consulta select a una tabla*/

set @num1:=1;
set @num2:=2, @num3:=3;
select @num2:=2, @num3:=3;
set @num1:=30;
select @num2:=2 as "numero2", @num3:=3 as "numero3";
select @noexiste; -- su valor es null si no la creo con set

create database variable;
use variable;
create table prueba(
	id int not null primary key,
    nombre varchar(100) not null,
    edad int not null 
);
insert into prueba values(1,"Pepe",20),(2,"María",18);
set @edadMinima:=18;
select * from prueba where edad>@edadminima;

-- En una variable solo se puede guardar un valor
set @edadpepe:=(select edad from prueba where nombre="pepe");

-- varias columnas si puedo guardarlas en varias variables
(select nombre, edad into @nombre1, @edad1 from prueba where id=1);

create table empleados(
	idempleado int not null primary key,
    nombre varchar(100) not null,
    salario decimal(10,2) not null
);
insert into empleados values (1,"Pepe",2000),(2,"Juana",1500),(3,"Belén", 1200);
-- Quiero que me mostréis los datos de los empleados que cobren más
-- que el salario medio de todos los empleados, usa una variable para resolverlo
set @salariomedio:=(select avg(salario) from empleados);
select * from empleados where salario>@salariomedio;
-- En la tabla empleados muestra una consulta que contenga una columna llamada fila y que para cada empleado indique el número
-- de fila que ocupa, usa variables para ello
set @cont:=0;
select nombre, @cont:=@cont+1 from empleados;
-- Crea una variable que se llame bonus y valga 200, y a los empleados que cobren que cobren menos de 1600 que se lo aplique
set @bonus:=200;
select nombre, salario+@bonus as "+bonus" from empleados where salario<1600;

/*Rutinas (eexisten procedimientos y funciones)
Procedimiento: bloques de código que se guarda y podemos llamrlo cuando queramos. El bloque de codigo son instrucciones sql que van a realizar una o varias tareas.

Estructura de un procedimiento*/
DROP procedure IF EXISTS `hola mundo`; -- no existe un comando para modificar un procedimiento una vez creado, hay que eliminar el procedimiento y volverlo a crear con create

DELIMITER $$ -- delimitan las instruciones del procedimiento
CREATE PROCEDURE `holamundo` () -- create para crear el procedimiento
-- entre los parentesis iran los parametros que se les pase al procedimiento. Puede tener parametros IN(entrada), out(salida), INOUT(salida-entrada)
BEGIN -- inicio de las instrucciones del procedimiento
-- instruciones
END$$ -- final de las instrucciones del procedimiento
DELIMITER ; -- final 

drop procedure if exists `holamundo`;
DELIMITER $$
create procedure `holamundo`()
begin
select "hola mundo";
end$$
DELIMITER ;

call holamundo(); -- llamar al procedimiento

drop procedure if exists `fecha`;
DELIMITER $$
create procedure `fecha`()
begin
select current_date();
end$$
DELIMITER ;
call fecha();

/*variables locales
se crean dentro de las rutinas, procedimientos y funciones
solo existen dentro de las rutinas, fuera no existen
se crean con la palabra declare
declare nombrevariable tipodedato valorpor defecto
declare contador int default 0;
*/
drop procedure if exists `saludo`;
DELIMITER $$
create procedure `saludo`()
begin
declare saludo varchar(20) default "hola";
declare que_tal varchar(20);
set que_tal:="que tal";
select concat(saludo," ",que_tal);
end$$
DELIMITER ;

/*Parametros de entrada en los procedimientos
van entre paréntesis
el numero de parametros de entrada puede ser el que queramos
losparametros deentrada se pasan al proc para usarlos entre las instruciones begin y end
Sintaxis
IN nomparametro tipo de dato
IN nombre varchar(100), IN apellido varchar(100);*/

-- Crea un proc que tenga un parámetro de entrada (el nombre de la persona). El proc tiene que saludar a una persona.
drop procedure if exists `saludoPersona`;
DELIMITER $$
create procedure `saludoPersona`(IN nom varchar(50))
begin
select concat("hola",nombre);
end$$
DELIMITER ;
set @nomPersona := "Juana";
call saludoPersona(@nomPersona);
set @nomempleado := (select nombre from empleados where idempleado=2);
call saludoPersona(@nomempleado);

-- Tendrá tres parámetros de entrada, el id, el nombre y el salario
drop procedure if exists `insertarempleado`;
DELIMITER $$
create procedure `insertarempleado`(IN id int, IN nom varchar(50), in sal decimal(6,2))
begin
insert into empleados set idempleado=id, nombre=nom, salario=sal;
end$$
DELIMITER ;
call insertarempleado(4,"lucia",2000);

/*parametros de salida
uno o mas valores que se crean dentro del procedimiento y se podran utilizar fuera
puedo obtener tantos parametros de salida como queramos
sintaxis:
out nombreparametro tipodato
OUT nombre varchar(100), OUT apellido varchar(100)...*/

-- crea un procedimiento que optenga el salario max de los empleados y lo guarde en un paramentro de salida

drop procedure if exists `salm`;
DELIMITER $$
create procedure `salm`(OUT maxsal decimal(6.2))
begin
set salmax := (select max(salario) from empleados);
end$$
DELIMITER ;
call salm(@salariomax);

create table notas(
	codigo int not null primary key,
    nombre varchar(20) not null,
    nota decimal(3,1) not null
);
insert into notas values ("1","Diana","10"), ("2","Luis","1"), ("3","María","5.5"), ("4","Juan","7"), ("5","Esther","3");

-- Crea un procedimiento que muestre la nota y el nombre de las personas cuyo nombre acabe en la letra que introduzca el usuario

drop procedure if exists `nota`;
DELIMITER $$
create procedure `nota`(IN letra char(1))
begin
select nombre, nota from notas where nombre like concat("%",letra);
end$$
DELIMITER ;
call nota("");

-- Crea un procedimiento que muestre en variables de salida el nombre y nota  de la persona con más notas.
drop procedure if exists `notamax`;
DELIMITER $$
create procedure `notamax`(out nom varchar(50), out nm decimal(3,1))
begin
set nm:=(select max(nota) from notas);
set nom:=(select nombre from notas where nota=nm limit 1);
end$$
DELIMITER ;
call notamax(@nommax, @notmax);

/*Parametrros d entrada/salida
van entre los parentesis
puede haber losparametros que perais, se separan por comas
Sintaxis:
inout nombrepar tipodato*/
-- crear un procedimiento al que le pasemos un nombre de persona, y se le sume a esa persona una puntuacion  en la nota. Me tiene que devolver la
-- nota resultante tras sumarle la puntuacion, pero la puntuación tb se la pasamosdrop procedure if exists `notamax`;

drop procedure if exists `notasum`;
DELIMITER $$
create procedure `notasum`(in nom varchar(20), inout aumento decimal(3,1))
begin
set aumento:=aumento+(select nota from notas where nombre=nom);
update notas set nota=aumento where nombre=nom;
end$$
DELIMITER ;
set @nom :="maria";
set @notsum :=0.5;
call notasum(@nom,@notsum);
select @notsum;

create database procedimientos;
use procedimientos;
create table atletas(
	id int not null primary key,
    nombre varchar(10) not null,
    ape1 varchar(20) not null,
    ape2 varchar(20) not null,
    puesto int not null
);
INSERT INTO `procedimientos`.`atletas` (`id`, `nombre`, `ape1`, `ape2`, `puesto`) VALUES ('1', 'María', 'López', 'López', '2');
INSERT INTO `procedimientos`.`atletas` (`id`, `nombre`, `ape1`, `ape2`, `puesto`) VALUES ('2', 'Luis', 'Pérez', 'Pérez', '1');
INSERT INTO `procedimientos`.`atletas` (`id`, `nombre`, `ape1`, `ape2`, `puesto`) VALUES ('3', 'Juan', 'Martín', 'Martínez', '3');
INSERT INTO `procedimientos`.`atletas` (`id`, `nombre`, `ape1`, `ape2`, `puesto`) VALUES ('4', 'Cristiano', 'Ronaldo', 'Dosantos', '5');

/*Instruccion condicional
condicional simple:
if(condicion) then instrucciones;
end if;

compuestas:
if(condicion) then 
instrucciones;
else
instrucciones;
end if;

anidada
if(condicion)then
instrucciones
elseif(condicion)then
instrucciones;
else
instruccion;
end if;
*/
drop procedure if exists `condicion`;
DELIMITER $$
create procedure `condicion`(in numero int)
begin
if(numero>0)then
select concat("El numero ",numero," es positivo");
else(numero=0)then
select concat("El numero ",numero," es 0");
else
select concat("El numero ",numero," es negativo");
end if;
end$$
DELIMITER ;
call condicion(9);

/*Procedimiento al que se le pasa parámetro de entrada que sea el nombre del atleta y muestra por pantalla lo siguiente:
si ha quedado de puesto 1 -> Nombre del atleta ha quedado de número 1
sino -> Nombre del atleta ha perdido. comprobar el nombre del attleta exista*/
drop procedure if exists `vencedor`;
DELIMITER $$
create procedure `vencedor`(in nom varchar(30))
begin
declare hay int;
set hay:=(select count(nombre) from atletas where nombre=nom);
if(hay>0)then -- (nom in (select nombre from atletas))
if((select puesto from atletas where nombre=nom)=1)then
select concat(nom," ha quedado de primero");
else
select concat(nom," ha perdido");
end if;
else
select "No existe";
end if;
end$$
DELIMITER ;
call vencedor("Luis");
/*Procedimiento al que se le pasa parámetro de entrada que sea el nombre del atleta y muestra por pantalla lo siguiente:
si ha quedado de puesto 1 -> Nombre del atleta ha quedado de número 1
si ha quedado de puesto 2 -> Nombre del atleta ha quedado de número 2
si ha q
si ha quedado de puesto 3 -> Nombre del atleta ha quedado de número 3
sino -> Nombre del atleta ha perdido*/
drop procedure if exists `podio`;
DELIMITER $$
create procedure `podio`(in nom varchar(30))
begin
if((select puesto from atletas where nombre=nom)=1)then
   select concat(nom," ha quedado de primero");
elseif((select puesto from atletas where nombre=nom)=2)then
      select concat(nom," ha quedado de 2º");
     elseif((select puesto from atletas where nombre=nom)=3)then
         select concat(nom," ha quedado de 2º");
      else
         select concat(nom," ha perdido");
end if;
end$$
DELIMITER ;
call podio("Cristiano");
-- pruebas
call resultado("iria"); -- no existe
call resultado("juan"); -- recer puesto
call resultado("maria"); -- segundo puesto
call resultado(""); -- no existe

drop procedure if exists `podio2`;
DELIMITER $$
create procedure `podio2`(in nom varchar(30))
begin
declare pos int;
set pos:=(select puesto from atletas where nombre=nom);
case (pos)
    when 1 then
         select concat(nom," ha quedado de primero");
	when 2 then
         select concat(nom," ha quedado de 2º");
	when 3 then
         select concat(nom," ha quedado de 3º");
	else
         select concat(nom," ha perdido");
end case;
end$$
DELIMITER ;
call podio2("luis");

/*while (condicion) do
instrucciones;
end while;
*/

/*Crea un proc que se le pase un parámetro de entrada, será un número. Y el procedimiento tiene imprimir números del 1 al num 
pasado como parámetro*/
drop procedure if exists `suma`;
DELIMITER $$
create procedure `suma`(in n int)
begin
declare s int default 1;
while (s<=n) do
select concat("el numero es", s);
set s:=s+1;
end while;
end$$
DELIMITER ;
call suma(5);
/*Crea un procedimiento al que se le pase un parámetro de entrada. Este parámetro es un número, deberéis comprobar que sea un
número positivo mayor que 0 sino teneis que indicar el sms "El número es negativo o 0". Si es mayor que cero tenéis que 
insertar en una tabla llamada Aleatorios (en cada fila) tantos números aleatorios del 1 al 10 como indique el parámetro de entrada. */

drop procedure if exists `tipo`;
DELIMITER $$
create procedure `tipo`(in n int)
begin
declare con int default 1;
if(n<=0)then
     select concat("El número", n, "es negativo o 0");
else
create table aleatorios(
     al int);
    while (con<n) do
     insert into al values ((rand()*10)+1);
     set con:=con+1;
     end while;
     select aleatorios;
     drop table aleatorios;
end if;
end$$
DELIMITER ;
call tipo(5);

/*Crea un procedimiento que se llame “youtubers” y se le pase un parámetro de
entrada que sea un char. En caso de que el char sea una C se creará una tabla
&quot;youtubers&quot; con la siguiente estructura:
En caso de que el char sea E se eliminará la tabla youtubers y en caso de que sea
cualquier otra letra mostrará un mensaje por pantalla indicando que no reconoce
la acción solicitada.*/
select count(*) from information_schema.tables where table_schema="procedimientos" and table_name="jutube";

drop procedure if exists `influ`;
DELIMITER $$
create procedure `influ`(in letra char)
begin
declare existyou int;
set existyou:=(select count(*) from information_schema.tables where table_schema="procedimientos" and table_name="jutube");
if(letra="c")then
    IF (existyou=0) THEN
    
     create table jutube(
     pos2023 int primary key,
     nombre varchar(50),
     seguidores_2023 int,
     variacion decimal(4,2));
     end if;
elseif(letra="e")then
if(exisyou=1) then
     drop table jutube;
     end if;
     else
         select "no reconoce la acción solicitada";
         end if;
end$$
DELIMITER ;
call influ("c");

use information_schema;
show tables;
select * from tables;
-- table_schema, table_name
select count(*) from information_schema.table where table_schema="procedimientos" and table_name="jutube";

/*Crea un procedimiento que inserte registros en la tabla “youtubers”; se le pasarán
tantos parámetros de entrada como columnas tenga la tabla creada. Con la
llamada al procedimiento call inserta las siguientes filas.*/

drop procedure if exists `añadir`;
DELIMITER $$
create procedure `añadir`(in p int, n varchar(30), s int, v decimal(4,2))
begin
insert into jutube values(p,n,s,v);
end$$
DELIMITER ;
call añadir(1,"elrubiusOMG",40400000,(0,00));

-- ---------------------------------------------------------------------------------
/*Crea un procedimiento llamado “SeguidoresMasDe” a la que se le pase un
parámetro de entrada en el que el usuario indica el número de seguidores y que
nos devuelva el número de youtubers que tienen más de los seguidores indicados.
Muestra el resultado por pantalla llamando a la función con el alias “Youtubers con
más de seguidores”*/
-- ---------------------------------------------------------------------------------
drop procedure if exists `llenaryou`;
DELIMITER $$
create procedure `llenaryou`(in n int)
begin
declare con int default 1;
if(n<=0)then
     select concat("El número", n, "es negativo o 0");
else
create table aleatorios(
     al int);
    while (con<n) do
     insert into al values ((rand()*10)+1);
     set con:=con+1;
     end while;
     select aleatorios;
     drop table aleatorios;
end if;
end$$
DELIMITER ;


/*funciones: diferencias con un procedimiento
solo tiene paramentros de entrada o no tiene parametros. no tiene out , ni inout
como solo tiene parametro de enstrada no hace falta escribir el in(da error)
siempre devuelve algun valor. lo devuelve dentro del begin/end con la palabra reservada return
valores que puede devolverse en el return: varchar, char, entero, decimal, boolean...
no puede devolver un select (el resultado de una consulta), un conjunto de valores
hay que indicar siempre el tipo de dato que se devuelve en una funcion con la palabra reservada returns
diferencia: 
return: es el valor devuelto (1,2, hola, true...)
returns es el tipo de valor devuelto(int, varchar,boolean...)
la suncion se llama dentro de un select o de un where con su nombre y parametros
ejem: select suma(2,4);
dentro de una funcion no podemos modificar, añadir, borrar datos sql(insert, update, delete)
*/

DROP function IF EXISTS `new_function`;

DELIMITER $$
CREATE FUNCTION `new_function` ()
RETURNS INTEGER
BEGIN

RETURN
END$$

DELIMITER ;

DROP function IF EXISTS `saludos`;

DELIMITER $$
CREATE FUNCTION `saludos` ()
RETURNS varchar(30)
BEGIN
-- declare sms(varchar(100));
-- set:="hola mundo";
RETURN "hola mundo";
END$$

DELIMITER ;

select saludos();
-- hayque poner a 1 para que las funciones sea menos segura.
select @@log_bin_trust_function_creators;
set global log_bin_trust_function_creators=1;

-- crear una función que se llame suma, a la que se le pasen dos números enteros devuelva el resultado de la suma
DROP function IF EXISTS `suma`;

DELIMITER $$
CREATE FUNCTION `suma` (n1 int, n2 int)
RETURNS INTEGER
BEGIN
declare suma int;
set suma:= n1+n2;
RETURN suma;
END$$

DELIMITER ;

select suma(5,8);
-- función que calcule el doble de un número entero


DROP function IF EXISTS `doble`;

DELIMITER $$
CREATE FUNCTION `doble` (nx2 int)
RETURNS int
BEGIN

RETURN nx2 * 2;
END$$

DELIMITER ;
select doble(25) as doble;

-- realiza una consulta sobre la tabla aleatoria que muestre el valor del número y su doble
insert into aleatorios values (1),(2),(8),(5),(12);
DROP function IF EXISTS `valdob`;

DELIMITER $$
CREATE FUNCTION `valdob` (nu int)
RETURNS INTEGER
BEGIN

RETURN 2* nu;
END$$

DELIMITER ;
select valdob(al) as  "doble", al from aleatorios;
-- función que se le pase un número entero y devuelva una cadena indicando "El número x es par" o "El número x es impar"
DROP function IF EXISTS `par`;

DELIMITER $$
CREATE FUNCTION `par` (par int)
RETURNS varchar(30)
BEGIN
declare cad varchar(20);
if(par%2=0) then
set cad:= concat("EL número ",par," es par");
else
set cad:= concat("EL número ",par," es impar");
end if;
RETURN cad;

END$$

DELIMITER ;

select par(15);


create database examen;
use examen;
create table productos(
	idprod int not null primary key,
    producto varchar(50) not null,
    precio decimal(5,2) not null,
    tipo int null
);
create table tipos(
	idtipo int not null primary key,
    nombre varchar(15) not null,
    ubicacion varchar(30) not null
);

INSERT INTO `examen`.`tipos` (`idtipo`, `nombre`, `ubicacion`) VALUES ('1', 'lácteos', 'pasillo a');
INSERT INTO `examen`.`tipos` (`idtipo`, `nombre`, `ubicacion`) VALUES ('2', 'cárnicos', 'pasillo b');
INSERT INTO `examen`.`tipos` (`idtipo`, `nombre`, `ubicacion`) VALUES ('3', 'pescados', 'pasillo c');
INSERT INTO `examen`.`tipos` (`idtipo`, `nombre`, `ubicacion`) VALUES ('4', 'vegetales', 'pasillo d');

INSERT INTO `examen`.`productos` (`idprod`, `producto`, `precio`, `tipo`) VALUES ('1', 'queso', '4.95', '1');
INSERT INTO `examen`.`productos` (`idprod`, `producto`, `precio`, `tipo`) VALUES ('2', 'chuleta', '7.95', '2');
INSERT INTO `examen`.`productos` (`idprod`, `producto`, `precio`, `tipo`) VALUES ('3', 'leche', '1.30', '1');
INSERT INTO `examen`.`productos` (`idprod`, `producto`, `precio`, `tipo`) VALUES ('4', 'lechuga', '0.85', '4');
INSERT INTO `examen`.`productos` (`idprod`, `producto`, `precio`, `tipo`) VALUES ('5', 'sardina', '2.55', '3');

alter table productos add constraint fk_productos_tipo foreign key(tipo) references tipos(idtipo);

/*Crea una función CONTAR_PRODUCTOS_PRECIO para contar productos que tengan
un precio superior a un valor dado. El parámetro de entrada será un precio
decimal(5,2) y el valor que retorna la función es un número entero contando los
productos con precio superior al indicado. Hay que comprobar que el precio indicado
no sea un número negativo o 0 porque en tal caso se devolverá un 0*/

DROP function IF EXISTS `CONTAR_PRODUCTOS_PRECIO`;

DELIMITER $$
CREATE FUNCTION `CONTAR_PRODUCTOS_PRECIO` (prec decimal(5,2))
RETURNS decimal
BEGIN
declare conteo int;
set conteo:=(select count(*) from productos where precio>prec);
RETURN conteo;
END$$

DELIMITER ;
select CONTAR_PRODUCTOS_PRECIO(4);

/*Crea un procedimiento INFO_TIPO al que se le pase un parámetro de entrada y uno de
salida. El parámetro de entrada será el número del tipo de producto, el parámetro de
salida será una cadena con la información del tipo de la siguiente forma.*/

drop procedure if exists `INFO_TIPO`;
DELIMITER $$
create procedure `INFO_TIPO`(in n int, out info varchar(100))
begin
    declare tip varchar(30);
    declare pas varchar(30);
    declare pr decimal(5,2);
    if ( select count(*) from productos where idprod=n>0)then
        set tip:=(select nombre from tipos where idtipo=n);
        set pas:=(select ubicacion from tipos where idtipo=n);
        set pr:=(select sum(precio) from productos where tipo=n);
       set  info=concat("El tipo ", tip,", está ubicado en el ", pas," y el total de productos es ", pr, " euros");
	else
	   set info="el id del tipo no existe.";
    end if;
    

end$$
DELIMITER ;

set @info:="";
call INFO_TIPO(4,@info);
select @info;
-- ------------------------------------------------
create database examenTema6;
use examenTema6;
create table espectadores(
	idE int not null auto_increment primary key,
    nombre varchar(15) not null,
    ap1 varchar(25) not null,
    ap2 varchar(25) not null,
    edad int null
);
create table peliculas(
	idP int not null primary key,
    titulo varchar(50) not null,
    genero varchar(25) not null,
    nominaciones int not null
);
create table asisten(
	idE int not null,
    idP int not null,
    fecha date not null,
    precio decimal(4,2) not null,
    puntuacion decimal(3,1) not null,
    constraint pk_asisten primary key(idE, idP, fecha)
);

INSERT INTO `examentema6`.`peliculas` (`idP`, `titulo`, `genero`, `nominaciones`) VALUES ('1', 'As Bestas', 'Suspenso', '3');
INSERT INTO `examentema6`.`peliculas` (`idP`, `titulo`, `genero`, `nominaciones`) VALUES ('2', 'El cuarto pasajero', 'Romance', '0');
INSERT INTO `examentema6`.`peliculas` (`idP`, `titulo`, `genero`, `nominaciones`) VALUES ('3', 'El menú', 'Terror', '2');
INSERT INTO `examentema6`.`peliculas` (`idP`, `titulo`, `genero`, `nominaciones`) VALUES ('4', 'Sonríe', 'Terror', '0');
INSERT INTO `examentema6`.`peliculas` (`idP`, `titulo`, `genero`, `nominaciones`) VALUES ('5', 'Fall', 'Suspenso', '1');
INSERT INTO `examentema6`.`peliculas` (`idP`, `titulo`, `genero`, `nominaciones`) VALUES ('6', 'Sin novedad en el frente', 'Acción', '1');

INSERT INTO `examentema6`.`espectadores` (`idE`, `nombre`, `ap1`, `ap2`, `edad`) VALUES ('1', 'Luis', 'López', 'López', '18');
INSERT INTO `examentema6`.`espectadores` (`idE`, `nombre`, `ap1`, `ap2`, `edad`) VALUES ('2', 'Pepe', 'Suárez', 'Pérez', '35');
INSERT INTO `examentema6`.`espectadores` (`idE`, `nombre`, `ap1`, `ap2`, `edad`) VALUES ('3', 'María', 'López', 'Rodríguez', '22');
INSERT INTO `examentema6`.`espectadores` (`idE`, `nombre`, `ap1`, `ap2`, `edad`) VALUES ('4', 'Juana', 'Martínez', 'López', '45');
INSERT INTO `examentema6`.`espectadores` (`idE`, `nombre`, `ap1`, `ap2`, `edad`) VALUES ('5', 'Javier', 'Lema', 'Lema', '66');

INSERT INTO `examentema6`.`asisten` (`idE`, `idP`, `fecha`, `precio`, `puntuacion`) VALUES ('1', '1', '2023-03-01', '8.75', '7.5');
INSERT INTO `examentema6`.`asisten` (`idE`, `idP`, `fecha`, `precio`, `puntuacion`) VALUES ('1', '2', '2023-03-03', '8.75', '8');
INSERT INTO `examentema6`.`asisten` (`idE`, `idP`, `fecha`, `precio`, `puntuacion`) VALUES ('1', '3', '2023-03-04', '8.75', '9');
INSERT INTO `examentema6`.`asisten` (`idE`, `idP`, `fecha`, `precio`, `puntuacion`) VALUES ('2', '4', '2023-03-05', '7.50', '7');
INSERT INTO `examentema6`.`asisten` (`idE`, `idP`, `fecha`, `precio`, `puntuacion`) VALUES ('2', '5', '2023-03-06', '4.50', '9.6');
INSERT INTO `examentema6`.`asisten` (`idE`, `idP`, `fecha`, `precio`, `puntuacion`) VALUES ('2', '6', '2023-03-07', '6.95', '5.5');


alter table asisten add constraint fk1 foreign key(idE) references espectadores(idE);
alter table asisten add constraint fk2 foreign key(idP) references peliculas(idP);



-- Creamos la tabla "alimentos"
CREATE TABLE alimentos (
  idAli INT not null PRIMARY KEY,
  nombreAli VARCHAR(50) not null,
  idtipo int not null,
  calorias decimal(6,2) not null
);
CREATE TABLE tipos (
  idtipo INT not null PRIMARY KEY,
  nombreTipo VARCHAR(50) not null,
  descripcion varchar(1000) null
);

-- Insertamos algunos datos en la tabla "alimentos"
INSERT INTO alimentos (idAli, nombreAli, idtipo, calorias) VALUES
  (1, 'Bollycao', 1, 500),
  (2, 'Pipas', 2, 410),
  (3, 'Limón', 3, 100);
  
  INSERT INTO tipos (idTipo, nombreTipo) VALUES
  (1, 'Dulce'),
  (2, 'Salado'),
  (3, 'Amargo');

alter table alimentos add constraint fk3 foreign key(idtipo) references tipos(idtipo);

/*Dada las tablas “espectadores”, “películas” y “asisten”, se pide crear una función en la que el usuario pase como
parámetros el nombre, apellidos del espectador y el número de mes y que la función devuelva una cadena de la
siguiente forma: “El espectador Luis López López no ha ido al cine en el mes de Febrero” o “El espectador Luis
López López ha gastado 26.25 euros en el mes de Marzo” o “El mes indicado es erróneo”. (3 PTOS)*/

drop procedure if exists `capitalismo`;
DELIMITER $$
create procedure `capitalismo`(in n varchar(30), in a1 varchar(30),a2 varchar(30), in mes int)
begin
declare meslet varchar(20);
declare ind int;
declare tot decimal(5,2);
set meslet:= (select substr("-1 enero-2 febrero-3 marzo-4 abril-5 mayo-6 junio-7 julio-8 agosto-9 septiembre-10 octubre-11 noviembre-12 diciembre-13-",
(select (locate(concat("-",mes,"-"),"-1-enero-2-febrero-3-marzo-4-abril-5-mayo-6-junio-7-julio-8-agosto-9-septiembre-10-octubre-11-noviembre-12-diciembre-13-")+3)),
(select(locate(concat("-",(mes+1),"-"),"-1-enero-2-febrero-3-marzo-4-abril-5-mayo-6-junio-7-julio-8-agosto-9-septiembre-10-octubre-11-noviembre-12-diciembre-13-"))-
(select (locate(concat("-",mes,"-"),"-1-enero-2-febrero-3-marzo-4-abril-5-mayo-6-junio-7-julio-8-agosto-9-septiembre-10-octubre-11-noviembre-12-diciembre-13-")+3)))) as "meses");
set ind:= ( select idE from espectadores where nombre= n and ap1 = a1 and ap2 = a2);
set tot:= (select sum(precio) from asisten where idE = ind);

if (mes between 1 and 12) then
     if((select count(idE) from asisten where idE = ind and fecha=(select fecha from asisten where month(fecha)= mes))>0) then
           select concat("El espectador ",m," ",ap1," ",ap2," ha gastado ",tot," euros en el mes de ",meslet);
     else
		select concat("El espectador ",m," ",ap1," ",ap2," no ha ido al cine en el mes de ",meslet);
      end if;     
else
     select "El mes indicado es erróneo";
end if;
end$$
DELIMITER ;

call capitalismo("Luís","López","López",3);



DROP function IF EXISTS `capitalismo`;

DELIMITER $$
CREATE FUNCTION `capitalismo` (n varchar(30),a1 varchar(30),a2 varchar(30), mes int)
RETURNS varchar(100)
BEGIN
declare meslet varchar(500);
declare sms varchar(100);
declare m int;
declare ind int;
declare tot decimal(5,2);
set meslet:= (select substr("-1 enero-2 febrero-3 marzo-4 abril-5 mayo-6 junio-7 julio-8 agosto-9 septiembre-10 octubre-11 noviembre-12 diciembre-13-",
(select (locate(concat("-",mes,"-"),"-1-enero-2-febrero-3-marzo-4-abril-5-mayo-6-junio-7-julio-8-agosto-9-septiembre-10-octubre-11-noviembre-12-diciembre-13-")+3)),
(select(locate(concat("-",(mes+1),"-"),"-1-enero-2-febrero-3-marzo-4-abril-5-mayo-6-junio-7-julio-8-agosto-9-septiembre-10-octubre-11-noviembre-12-diciembre-13-"))-
(select (locate(concat("-",mes,"-"),"-1-enero-2-febrero-3-marzo-4-abril-5-mayo-6-junio-7-julio-8-agosto-9-septiembre-10-octubre-11-noviembre-12-diciembre-13-")+3)))) as "meses");
set m:= (select month(fecha) from asisten where month(fecha)=mes);
set ind:= ( select idE from espectadores where nombre= n and ap1 = a1 and ap2 = a2);
set tot:= (select sum(precio) from asisten where idE = ind);

	 set sms:= (select concat("El espectador ",m," ",ap1," ",ap2," ha gastado ",tot," euros en el mes de ",meslet));

RETURN sms;
END$$

DELIMITER ;
select capitalismo("Luís","López","López",3);
-- -------------------------------------------------------- 

/*Crea un procedimiento que se base en las tablas “Alimentos” y “Tipos”. El procedimiento deberá sumar 100kcal a
los alimentos que sean de tipo dulce, una vez sumadas las calorías deberá comprobar las calorías de todos los
alimentos y cubrir un campo de la tabla Alimentos que se llamará info. Si el alimento supera las 500kcal entonces la
info será: &quot;Alimento no sano&quot;, si las calorías están entre 200 y 500 la info será: &quot;Alimento poco sano&quot; y si las calorías
son menores que 200 la info &quot;Alimento muy sano&quot; (3 PTOS)*/

alter table alimentos add column info varchar(100);
drop procedure if exists `obesidad`;
DELIMITER $$
create procedure `obesidad`(in kcal int)
begin
    if(kcal>0) then
       drop temporary table if exists temalimentos;
       create temporary table temalimentos as (select * from aliemntos);
       alter table temalimentos  add column info varchar(100);
       update temalimentos set calorias= calorias+kcal where idtipo=(select idtipo from tipos where nombreTipo="dulce");
       update temalimentos set info=
       case
       when calorias>500 then "alimento no sano" 
       when calorias between 200 and 500 then "alimento no sano" 
       else  "alimento sano"
       end;
    else
	   signal sqlstate '45000' set message_text="Las calorias a sumar deben ser mayores que 0";
	end if;
end$$
DELIMITER ;
call obesidad(100);
select * from alimentos
-- -------------------------------------------------------

/*Crea un procedimiento al que se le pasen dos parámetros de entrada que serán dos géneros de películas
y devuelva un parámetro de salida que será una cadena indicando cuál de los dos géneros tiene más
nominaciones.(3 PTOS)*/

drop procedure if exists `winer`;
DELIMITER $$
create procedure `winer`(in nominado1 varchar(30),in nominado2 varchar(30), out ganador varchar(100))
begin
 declare n1 int;
 declare n2 int;
 set n1:=(select sum(nominaciones) from peliculas where genero=nominado1);
set n2:=(select sum(nominaciones) from peliculas where genero=nominado2);
if((select count(genero) from peliculas where genero=nominado1 or genero=nominado2)=2) then

    if(n1>n2) then
         set ganador:=(select concat("El género ",nominado1," tiene más nominaciones que el género ",nominado2));
    else
         set ganador:=(select concat("El género ",nominado2," tiene más nominaciones que el género ",nominado1));
     end if;
else
      set ganador:=(select "Alguno de los géneros indicados no es correcto");
end if;

end$$
DELIMITER ;
set @g:="";
call winer("suspenso","terror",@g);
select @g;
-- --------------------------------------------------------
/*sigmal: instruccion que permite enviar errore por consola, podedmos usar en procedimientos y funciones
signal sqlstate '45000' set message_text="El mensaje a enviar";
sqlstate 45000: nos permite crear nuestros propios erroeres dentro de la rutina
message_text es la variable que guarda el mensaje a enviar por consola
cuando el programa encuentra un signal sqlstate '45000' se para la ejecucion de la rutina(procedimiento o un funcion)
que las instrucciones siguientes no se ejecutan*/

drop procedure if exists `mayor`;
DELIMITER $$
create procedure `mayor`(in edad int)
begin
   if(edad<18) then
      signal sqlstate '45000' set message_text="La persona es menor de edad";
	else
       select "La persona es mayor de edad";
      end if;
end$$
DELIMITER ;
call mayor(17);

DROP function IF EXISTS `par`;

DELIMITER $$
CREATE FUNCTION `mayor` (edad int)
RETURNS varchar(50)
BEGIN
 if(edad<18) then
      signal sqlstate '45000' set message_text="La persona es menor de edad";
	else
       return "La persona es mayor de edad";
      end if;
END$$

DELIMITER ;
-- --------------------------------------------
create table puntuacion(
	id_equipo int not null primary key,
    nombre varchar(100) not null,
    ronda1 decimal(6,2) not null,
    ronda2 decimal(6,2) not null,
    ronda3 decimal(6,2) not null,
    ronda4 decimal(6,2) not null
);
INSERT INTO `puntuacion` (`id_equipo`, `nombre`, `ronda1`, `ronda2`, `ronda3`, `ronda4`) VALUES ('1', 'Los coruñeses', '100.50', '20.50', '35.50', '40');
INSERT INTO `puntuacion` (`id_equipo`, `nombre`, `ronda1`, `ronda2`, `ronda3`, `ronda4`) VALUES ('2', 'Los boleros', '200', '100', '20', '10');
INSERT INTO `puntuacion` (`id_equipo`, `nombre`, `ronda1`, `ronda2`, `ronda3`, `ronda4`) VALUES ('3', 'Los jefes', '150', '20', '25', '35.50');
INSERT INTO `puntuacion` (`id_equipo`, `nombre`, `ronda1`, `ronda2`, `ronda3`, `ronda4`) VALUES ('4', 'Los de siempre', '150', '20', '24', '35.5');

DROP function IF EXISTS `torneo`;

DELIMITER $$
CREATE FUNCTION `torneo` (eq1 int, eq2 int)
RETURNS varchar(100)
BEGIN
declare gana varchar(100);
declare resultado1 decimal(5,2);
declare resultado2 decimal(5,2);
declare nom1 varchar(20);
declare nom2 varchar(20);

if(eq1 not in (select id_equipo from puntuacion) or eq2 not in (select id_equipo from puntuacion)) then
 signal sqlstate '45000' set message_text="algunos de los ids de los equipos es erroneo";
else 
set resultado1:=(select (ronda1 + ronda2 + ronda3 + ronda4)/4 from puntuacion where id_equipo=eq1);
set resultado2:=(select (ronda1 + ronda2 + ronda3 + ronda4)/4 from puntuacion where id_equipo=eq2);
set nom1:=(select nombre from puntuacion where id_equipo=eq1);
set nom2:=(select nombre from puntuacion where id_equipo=eq2);
if(resultado1>resultado2) then
     set gana:= (select concat("El equipo ganador es: ",nom1," y su puntuación media es: ",resultado1));
elseif(resultado1>resultado2) then
     set gana:= (select concat("El equipo ganador es: ",nom2," y su puntuación media es: ",resultado2));
    else
     set gana:= (select concat("Los equipos: ",nom1," y ",nom2," han empatado y su puntuación media es: ",resultado1," puntos"));
    end if;
    end if;
RETURN gana;
END$$
DELIMITER ;
select torneo(100,1);
select torneo(4,1);
create table partido(
	id_equipo1 int not null,
    id_equipo2 int not null,
    fecha date not null,
    resultado varchar(5) not null,
    constraint pk_partido primary key(id_equipo1, id_equipo2, fecha)
);
INSERT INTO `partido` (`id_equipo1`, `id_equipo2`, `fecha`, `resultado`) VALUES ('1', '2', '2022-03-01', '3-1');
INSERT INTO `partido` (`id_equipo1`, `id_equipo2`, `fecha`, `resultado`) VALUES ('1', '2', '2022-03-02', '4-0');
INSERT INTO `partido` (`id_equipo1`, `id_equipo2`, `fecha`, `resultado`) VALUES ('1', '2', '2022-03-03', '5-0');
INSERT INTO `partido` (`id_equipo1`, `id_equipo2`, `fecha`, `resultado`) VALUES ('1', '3', '2002-03-02', '5-2');
INSERT INTO `partido` (`id_equipo1`, `id_equipo2`, `fecha`, `resultado`) VALUES ('2', '3', '2022-03-02', '2-1');

drop procedure if exists `tongo`;
DELIMITER $$
create procedure `tongo`()
begin
declare eqlocal int;
declare eqvisist int;
update partido set resultado=(concat(substr(resultado,1,(locate("-",resultado)-1)+1),"-",substr(resultado,(locate("-",resultado)+1))
where (substr(resultado,1,(locate("-",resultado)-1)) from partido)<5;

UPDATE partido
    SET resultado = CONCAT((SUBSTR(resultado, 1, LOCATE('-', resultado) - 1) + 1), '-', SUBSTR(resultado, LOCATE('-', resultado) + 1))
    WHERE SUBSTR(resultado, 1, LOCATE('-', resultado) - 1) < 5;


update partido set resultado=(concat(substr(resultado,(select locate("-",resultado)+1)-1)  
where (select substr(resultado,(select locate("-",resultado)+1)) from partido)>0;


UPDATE partido
    SET resultado = CONCAT(SUBSTR(resultado, 1, LOCATE('-', resultado) - 1), '-', SUBSTR(resultado, LOCATE('-', resultado) + 1) - 1)
    WHERE SUBSTR(resultado, LOCATE('-', resultado) + 1) > 0;
end$$
DELIMITER ;



create database internet;
use internet;
CREATE TABLE usuarios (
    idus INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    alias VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    fregistro DATE NOT NULL,
    ncomentarios int DEFAULT 0
);
CREATE TABLE comentarios (
    idco INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idus INT NOT NULL,
    juego VARCHAR(50)  NOT NULL,
    comentario VARCHAR(1000) NULL,
    valoracion int
);
alter table comentarios add constraint fk_comentarios_usuarios foreign key(idus) references usuarios(idus);
INSERT INTO `internet`.`usuarios` (`idus`, `nombre`, `alias`, `email`, `fregistro`, `ncomentarios`) VALUES ('1', 'Iria', 'iriacastri', 'iriacastrillon@gmail.com', '2024-01-01', '0');
INSERT INTO `internet`.`usuarios` (`idus`, `nombre`, `alias`, `email`, `fregistro`, `ncomentarios`) VALUES ('2', 'Pepe', 'pepedepura', 'pepedepura@gmail.com', '2024-02-02', '1');
INSERT INTO `internet`.`comentarios` (`idco`, `idus`, `juego`, `valoracion`) VALUES ('1', '2', 'Fortnite', '5');

/*Crea un procedimiento al que se le pase como entrada el id de un usuario, un nombre de juego y una valoración e
inserte el comentario en la tabla comentarios comprobando previamente que:
a. El idusuario existe si no existe se enviará un mensaje por consola &quot;El ID de usuario proporcionado no existe&quot;.
b. El nombre de juego existe, solo pueden ser estos tres &quot;Fortnite&quot;, &quot;League of Legends&quot;, &quot;Minecraft&quot; sino
mensaje por consola &quot;El juego que quieres comentar no es válido&quot;.
c. La valoración está entre 0 y 10, sino &quot;La valoración debe estar entre 0 y 10&quot;
d. El usuario que existe no ha comentado previamente ese juego válido, sino &quot;El juego ya ha sido comentado
por el usuario”

Además de insertar el comentario en la tabla comentarios debe actualizar la tabla usuarios con el número de comentarios del
usuario (3 PTOS)*/

drop procedure if exists `game`;
DELIMITER $$
create procedure `game`(in id int, in nom varchar(50), in val int)
begin
if((select count(idus) from usuarios where idus=id)=0) then
    signal sqlstate '45000' set message_text="El ID de usuario proporcionado no existe";
end if;
 if(nom not in ("Fortnite","League of Legends","Minecraft")) then
	      signal sqlstate '45000' set message_text="El juego que quieres comentar no es válido";
end if;
if(val not between 1 and 10) then
	signal sqlstate '45000' set message_text="La valoración debe estar entre 0 y 10";
end if;
if((select count(*) where idus=id and juego= nom) >0) then
	signal sqlstate '45000' set message_text="El juego ya ha sido comentado por el usuario";
else
	insert  into comentarios values(0,id,nom,null,val);
    update usuarios set ncomentarios=ncomentarios+1 where idus=id;
end if;
end$$
DELIMITER ;

call game(5,"lol",9);

-- ---------------------------------------
/*Para las tablas anteriores, crea una función a la que se le pasen dos parámetros de entrada que serán dos juegos y
devuelva una cadena. Hay que comprobar si los juegos existen en la tabla comentarios, si existen hay que conseguir la
media de todas sus valoraciones. La cadena que se devolverá será una comparacion de las valoraciones de los
juegos. si el juego 1 tiene mejor valoración, &quot;El juego Fortnite tiene mejor valoración que el juego League of
Legends&quot; sino &quot;El juego League of Legends tiene mejor valoración que el juego Fortnite&quot; y sino “El juego
Fortnite tiene la misma valoración que el juego League of Legends”. En el caso de que alguno de los juegos no
exista “Alguno de los juegos no existe” (2,5 PTOS)*/

DROP function IF EXISTS `GOTY`;

DELIMITER $$
CREATE FUNCTION `GOTY` (j1 varchar(50), j2 varchar(50))
RETURNS varchar(200)
BEGIN
declare retorno varchar(200);
declare mj1 decimal(3,1);
declare mj2 decimal(3,1);
if(j1 not in (select juego from comentarios) or j2 not in (select juego from comentarios)) then
    set retorno:= "Alguno de los juegos no existen";
else
    set mj1:= (select avg(valoracion) from comentarios where juego=j1);
	set mj2:= (select avg(valoracion) from comentarios where juego=j2);
    if(mj1>mj2) then
        set retorno:= concat("El juego ",j1," tiene mejor valoración que el juego ",j2);
	elseif (mj2>mj1) then
        set retorno:= concat("El juego ",j2," tiene mejor valoración que el juego ",j1);
        else
        set retorno:= concat("El juego ",j1," tiene la misma valoración que el juego ",j2);
        end if;
end if;
RETURN retorno;
END$$
select goty("lol","csgo");

-- ----------------------------------------------
/*Crea una función a la que se le pase como parámetro el nombre o apellido de un tenista y hay que comprobar si existe
en la tabla de tenistas. Luego, contaremos las veces que el tenista ha quedado en las posiciones 1, 2 y 3 en los
torneos en los que ha participado y devolveremos una cadena con esa información. Ej: “El tenista Novak Djokovik
ha quedado de primero en 1 torneo, de segundo en 1 torneo y de tercero en 0 torneos” (3 PTOS)*/

DROP function IF EXISTS `podio`;

DELIMITER $$
CREATE FUNCTION `podio` (n varchar(30))
RETURNS varchar(100)
BEGIN
declare i int;
declare p1 int;
declare p2 int;
declare p3 int;
set i:=(select idtenista from tenistas where nombre like concat("%",n,"%"));
if(i is null) then
    signal sqlstate '45000' set message_text="El tenista no existe";
else
     set p1:=(select count(posicion) from compiten where posicion=1 and idtenista=i);
     set p1:=(select count(posicion) from compiten where posicion=2 and idtenista=i);
     set p1:=(select count(posicion) from compiten where posicion=3 and idtenista=i);
end if;
RETURN concat("El tenista ",nom," ha quedado de primero en ",p1," torneo, de segundo en ",p2," torneo y de tercero en ",p3," torneos");
END$$
