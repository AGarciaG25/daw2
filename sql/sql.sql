-- comentario en una linea
/* comentario 
en 
vraias
líneas
*/
/* Lenguaje SQL
DDL: create, alter, drop
DML: insert, update, delete
DCL: grant, revoke
*/
-- NORMAS PARA CREAER UNA BASE DE DATOS
/*
sintaxis:
create database nombre_baseDatos;
todas las instrucciones acaban con ;
da igual mayusculas y las minusculas, espcacios, saltos, lineas
los nombres de bd, tablas, sean representativos, no tengan más 30 caract, no símbolos espec, no tildes, no empiecen en número, 
no podemos usar palabras reservadas como nombre, tablas ... (create, alter, 
no podemos crear bd, tablas... con el mismo nombre, porque da error

*/
/*
crear BBDD
create database/schema nombre_base;
*/
/* eliminar bases de datos
drop database/schema nombre_base;
*/
/* mostrar todas las bases de datos que hay
show database;
*/
create database prueba;
create database escuela;
drop database escuela;
drop database new_schema;
drop database adrian;
create database prueba2;
create database prueba3;
drop database prueba3;
drop database prueba2;
drop database prueba;
create database ecuela;
-- posicionarse en una bd
use ecuela;
/* crear tabla
create table nombre_tabla(
atributo tipoDato restricciones,
atributo tipoDato restricciones,
atributo tipoDato restricciones
);
*/
/*
restricion deobligatoriedad, se indica con null o not null
*/
create table alumnos(
codigo int not null,
nombre varchar(20) not null
);
drop table alumnos;
create table alumnos(
codigo int not null primary key,
nombre varchar(20) not null);
-- segunda forma 
create table alumnos(
codigo int not null,
nombre varchar(20) not null,
constraint pk_alumnos primary key(codigo)
);
-- Tabla profesores: codigo entero clave primaria, dni varchar(9) clave candidata, nombre varchar(30), falta tipo fecha
-- departamento puede tener nulos varchar(20) (y por defecto el departamento es informática)
create table profesores(
codigo int not null auto_increment,
dni varchar(9) not null,
nombre varchar(30) not null,
falta date not null, -- YYYY/MM/DD
departamento varchar(20) null default "informatica",
constraint pk_profesores primary key(codigo),
constraint Uk_prefesores unique(codigo)
);

/* a veces queremos que sean autoincrementados, que cada vez que inserto una fila en la tabla el codigo se incremente*/
/*Tabla asignaturas: codigo int clave primaria, nombre varchar(20), ciclo solo puede ser DAM o DAW, 
horas entero, créditos decimal con 1 dígito decimal
decimal(total digitos, digitos decimales) 10.25 decimal(4,2)*/
create table asignaturas(
codigo int not null auto_increment,
nombre varchar(20) not null,
ciclo enum("DAM","DAW"),
horas int not null,
sueldo int not null,
creditos decimal(3.1) not null,
constraint pk_asignaturas primary key(codigo),
constraint sueldo check(sueldo>0)
);
/* restriccion check sobre una o varias columnas
crear una tabla formada por 2 colomnas*/
create table fichaMedica(
codFicha int not null,
codProfesor int not null,
alergias boolean not null,
grupoSaniguinea varchar(5)
constraint pk_fichaMedica primary key(codFicha, codProfesor)
);
-- Restricciones check de comprobación
-- el stock tiene que ser mayor que 0
-- el precio del material mayor a 0
create table material(
codMaterial int not null auto_increment,
nombre varchar(50) not null,
stock int not null check(stock>0),
precio decimal(6,2) not null, -- check(precio>0),
constraint ck_precio check(precio>0 and precio<=100), -- puedo poner más de una condición
constraint pk_material primary key(codMaterial)
);

