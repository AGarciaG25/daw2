-- transacciones
-- commit: hacer una condirmacion en firme de una instrucción
-- rollback: revertir ua instrucción
-- En genreral si haceis commit no podremos echar atras ninguna instruccion.
-- pero si no hacemos commit podemos hacer rollback
-- DDL: create, drop, alter, truncate (no van a poder tener un rollback)
-- DML: insert, delete, update (si pueden tener rollback) 

-- variabes globales/ del sistema: @@version
show variables;
select @@version;
select @@autocommit; -- 1 o 0
set autocommit = 0; -- porque quiero que no se confirmen automaticamente los commits de las intrucciones

-- vamos a empezar a usar transacciones
start transaction; -- begin

create database transacciones;
use transacciones;
rollback; -- no se deshace la creacion de la base de datos porque create pertenece a ddl y lleva autocomit implicito
create table prueba(
id int primary key,
valor varchar(100));
rollback; -- no se deshace la creacion de la tabla porque create pertenece a ddl y lleva autocomit implicito

insert into prueba values (1,"hola");
insert into prueba values (2,"adios");
rollback; -- se borran los 2 insert porque pertenece a dml, no llevan commit implicito y yo no le he dado commit a ninguno de ellos
insert into prueba values (1,"hola");
commit;
insert into prueba values (2,"adios");
rollback; -- los rollback deshacen todo lo que ven hasta llegar a un commit
update prueba set valor="otro valor" where id=1;
rollback; -- se modifican porque petenece a dml no lleva un commit implementado y yo no le he dado commit a ninguno de ellos
delete from prueba where id=1;
rollback -- se deshace el delete
truncate table prueba;
rollback -- no deja revertir porque pertenece a ddl
drop table prueba;
drop database transacciones;
show databases like "liga";

/* Al iniciar sesión en MySql comprueba el valor de la variable autocommit. A
continuación cambia el valor por defecto para poder trabajar con
transacciones.*/
select @@autocommit
set autocommit=0;
/* Inicia una transacción, crea la siguiente tabla y a continuación realiza un
Rollback. ¿Qué pasa con la tabla creada?*/
start transaction;
create database libro;
use libro;
create table titulos(
id int auto_increment primary key,
titulo varchar(100),
autor varchar(100),
stock int,
precioCompra decimal(4,2));
rollback;

/* Inserta un par de registros en la tabla, a continuación realiza un rollback. ¿Qué
ocurre?*/
insert into titulos (0, "El hobit", "j.r.r. tolkien",200 ,25.50);
rollback; -- deshace los insert
/* Ahora inserta un registro y realiza un commit, inserta otro registro y realiza un
rollback. Observa qué ocurre.*/
insert into titulos (0, "El hobit", "j.r.r. tolkien",200 ,25.50);
commit;
rollback; -- no deshace nada
/* Modifica un registro de la tabla con UPDATE y a continuación realiza un
rollback. ¿Está permitido revertir un cambio en un registro?.*/
update titulos set titulo="El señor de los anillos" where id=1;
rollback; -- deshace el update porque es una instruccion dml
/* Renombra algún campo en la base de datos y realiza un rollback. ¿Se mantiene
el cambio?*/
alter table libros rename column id to idlib;
rollback; -- no modifica el nombre porque es alter pertenece a las ddl
/* Añade algún campo adicional a la tabla y realiza un rollback. ¿Qué ocurre?*/
ALTER TABLE titulos ADD COLUMN info varchar(100);
rollback; -- igual que antes
/* ¿Los comandos CREATE y DROP, permiten realizar un rollback? Elimina la tabla
y compruébalo.*/
drop table titulos;
rollback; -- igual que antes