/* TABLA TEMPORALE
Es como una tabla normal pero.....
Su duracion es temporal, dura la session del usuario, hasta que el usuario se desconecte
Las operaciones, insert, update, delete se pueden hacer y las operacioners create, drop
Usos: para guardar datos temporales, como datos de consultas complejas o datos intermedios
nombres de las tablas temporales; cualquier nombre pero si puede ser no como la tabla original, temp_empleados
Sintaxis:
        create temporary table nombreTabla(
               columna tipodato restricciones,
               ........
               );
               
        copiando la estructura de una tabla ya creada
        create temporary table nombretabla like nombreTablaOriginal;
        
        con una consulta select
        create temporary table nombreTable as (consulta select)
*/


create temporary table temp_borrascas(
     codBorrascas int not null primary key,
     nomreBoarrasca varchar (100) not null
     );
     
/*en el explorador no hay apartado para ver las temporary tables!!*/

-- ver el contenido de una tabla temporal
select * from temp_borrascas;
-- insert, update, delete se pueden hacer sobre la tabla temporal

insert into temp_borrascas values(1, "Herminia");

-- 2 forma con like copiando la estructura de otra tabla

create temporary table temp_artistas like artistas;
select * from temp_artistas;


-- 3 forma creando una tabla a partir de una consulta select

-- creamos una tabla temporal con el nombre de los artistas que sean cantantes y llama a la tabla temp_cantantes

create temporary table temp_cantantes as (
    select a.nombre
    from artistas a join profesiones p using(codProfesion)
    where p.nombre = "cantante"
    );


-- 1ª forma. no se suele hacer asi
create temporary table tprueba(
cod int primary key,
valor varchar(100) );

show table; -- muestro listado de tablas y vistas
-- no existe instruccion para mostrar las tablas temporales
-- puedo hacer select, insert, update,delete, drop...alter
select * from tprueba;
insert into tprueba values(1,"hola");
update tprueba set valor="adios" where cod=1;
delete from tprueba where cod=1;
-- borra todas las filas de una tabla
truncate table tprueba;

-- 2ª froma copiando estructura de tabla ya creada
create temporary table tlibros like libros;
create temporary table ttmaticas like tematicas;
select * from tlibros;
select * from ttematicas;

-- 3ª forma. creat una tabla temporal atraves de una consulta select
-- tabla temporl llamada  tlibroscaros tendra todos los datos de libros que cuesten mas de 25
create temporary table tlibroscaros as (select * from libros where preciocompra>25); 

-- cread una tabla temporal llamada taccionRomance que contenga titulo libro, precio, y nombre de temática de los libros de acciónn y romance
create temporary table taccionromance as (select titulo, preciocompra, nombre from libros join tematicas using(codtem) where nombre in ("accion","romance"));

-- crea una tabla temporal llamada tLibrosporTematica que muestre el nombre de la temática y la cantidad de libros de cada temática
create temporary table tlibrosportematica as (select nombre, count(*) as conttematicas from librs join tematicas using(codtem) group by libros.codtem);

-- Vistas
-- es una tabla visual. no exixste por si misma; está asociada a una o varias tablas reales.
-- Esta creada através de una consulta SQL y se nutre de una o más tablas originales.
-- Diferencia con una tabla temporal:
--  Dura más que la sesion del usuario, es permanente, no se elimina al cerrar la sesión
-- En el apartado views del explorador apareceran las vistas creadas. show tables para listar las vistas y tablas
-- En la tabla temporal no hay retroalimentacion de cambios entre esta y la tabla original. En las vistas dependiendo de cómo se haya creado la vista sí existe retroalimentacion de los cambios(insert,update,etc)
-- Podemos realizar operaciones propias de las tablas: inser, update, detele, drop
-- nomenclatura: cualquier nombre pero intentamos que no se llamae igual que una tabla original
-- sintaxis: create view nombrevista as (consulta select...);
-- usos: guardas consultas complejas que se usen habitualmente

-- vista cnstruida a partir de una tabla
-- vista de aquellos libros que su titulo empiecen por e
create view  vlibrose as (select * from libros where titulo like "e%");

-- si inserto en la tabla original es posible? que pasa?
INSERT INTO libros (`titulo`, `autor`, `stock`, `precioCompra`,`codTem`) VALUES ('El título cualquiera', 'Autor cualquiera', '100', '15.50',"3");
-- deja insertar en la tabla original, y si la insercion coincide con la consulta de la vista tambien se insertaria
-- si inserto en la vista es posible? qué pasa??
insert into vlibrose values(0,"Un título","Un autor",100,10,1);

-- modificar algo en la tabla original. se puede y que pasa?
-- modificar puerto escondido por el puerto encondido
update  libros set titulo="el puerto escondido" where titulo="puerto escondido";
-- modificar en la vista es un titulo por teo va a la escuela
update vlibrose set titulo="teo va a la escuela" where titulo="es un titulo";
-- boorrado en la tabla original
-- borra el libro 6
delete from libros where codLi=6;