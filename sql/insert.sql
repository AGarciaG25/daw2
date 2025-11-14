/*Tema 5. Manipulación Datos

Insertar: 
Insert basico
    Sintaxis:
    Insert into nombreTabla (nombrecol, nombreCol2,...) values (valor1, valor2,...);
    Insert into nombreTabla values(valor1,valor2,...);
Insert + select
Insert + set
Importar datos desde un archivo

*/

create database inserciones;
use inserciones;
create table cosasViejas(
idCosa int auto_increment primary key,
nombre varchar(500),
color varchar(20) null,
precio decimal(10,2),
estado enum("nuevo","viejo")
);
drop table cosas;

-- Cómo insertar datos en un auto_increment, hay  que indicar un 0 como valor
insert into cosas(idcosa,nombre,color,precio,estado) values (0,"mesa",null,200,"nuevo");
insert into cosas(nombre,precio,estado) values ("silla",100,"nuevo");
insert into cosas(estado,nombre,precio) values ("viejo","lampara",20);
insert into cosas values(0,"radiador","blanco",300,"nuevo");

-- Insert + select
-- insert into nombreTabla (col1,col2,...) select ....
insert into cosasViejas (idCosa,nombre,color,precio,estado) select * from cosas where estado="viejo";
insert into cosasnuevas (idCosa,nombre,color,precio,estado) select * from cosas where estado="nuevo";
insert into cosasnuevas (nombre,color,precio,estado) select nombre,color,precio,estado from cosas where estado="nuevo";

-- insert + clausula set
-- insert into nombreTabla set columna1=valor1, columna2=valor2, columna3= valor3;
insert into cosasnuevas set nombre="guantes", precio=3.95, estado="nuevo";
insert into cosasviejas set idcosa=0, nombre="balde", precio=5.95, color="negro", estado="viejo";

-- modificaciones: update
-- Siempre suele llevar un where porque sino se modifican tosas las filas de la tabla
-- Sintaxis:
-- update nombreTabla set columna1=valor1 where condicion
update cosasviejas set precio=4.95, color="rojo" where nombre=balde;

update cosasnuevas set color=(select color from cosasviejas where nombre="balde") where nombre="guantes";
-- modificar el precio de la silla al mismo que la mesa
update cosasnuevas set precio=(select precio from cosasnuevas where nombre="mesa") where nombre="silla";
-- da error porque hay 2 accesos a la misma tabla, uno de lectura y otro de escritura. Se soluciona con una tabla temporal, vistas o variables
-- delete: borra datos
-- sintaxis: delete from NombreTabla where condicion;
-- sin la condicion se elimina todo.
delete from cosasnuevas where colo="gris";

-- Reglas de integridad refeencial
-- reglas que tienen relacion y se contruyen con la clave foraea
-- Ayuda a que un usuario no pueda borrar/ modificar tabla relacionadas
-- alter table nombreTabla add constraint nombreFK foreing key(columna) references table(columna) on delete restrict on update cascade
-- hay 4 reglas:
-- restrict: + restrictiva, no permite borrar ni modificar columnas relacionadas mediante clave foranea
-- no acction: es igual a restrict e igual a no poner nada
-- set null: en el borrado permite borrar pero si hay columnas relacionadas en la otra tabla las pone a null de la clave foranea
-- 
-- cascade: cascada en el borrado, permite borrar pero si hay algo relacionado tb lo borra en cascada
-- cascada en la modificacion, permite modifica y si hay algo relacionado tb lo modifica
 
 create database restricciones;
 use restricciones;
 create table personas(
 idpersona int primary key,
 nombre varchar(100),
 idciudad int);
 create table ciudades(
 idciudad int primary key,
 nombre varchar(100)
 );
 
 insert into ciudades values(1,"madrid");
 insert into ciudades set idciudad=2, nombre="coruña";
 insert into ciudades (nombre,idciudad) values ("barcelona",3);
 
 insert into personas values (1,"Pepe",1);
 insert into personas set idpersona=2, nombre="Uxía", idciudad=2;
 insert into personas (idpersona, nombre, idciudad) values (3,"Juana",2);
 
 -- clave foranea + integridad referencial - en el borrado restrictivas, en la modificacion restrictivas
 alter table personas add constraint fkperosnnas_ciudades foreign key(idciudad) references ciudades(idciudad) on  delete restrict on update restrict;
 
 -- CASCADE:
 alter table personas add constraint fkperosnnas_ciudades foreign key(idciudad) references ciudades(idciudad) on  delete cascade on update cascade;
 -- set null
 alter table personas add constraint fkperosnnas_ciudades foreign key(idciudad) references ciudades(idciudad) on  delete set null on update set null;
 -- Puedo borrrar el registro de la persona pepe
 delete from personas where nombre="pepe";
 -- Si se puede borrar a Pepe, porque aunque vive en una ciudad y esa columna es la clase foranea que relaciona ciudades y personas
 -- la tabla principal que provee esa clave foranea es ciudades. Pede no tiene por que existir pero la ciudad sequira existiendo
 -- set null: 
 -- Puedo borrar el registro de la ciudad Coruña
 delete from ciudades where nombre="coruña";
 -- coruña no se puede eliminar porque hay personas que dependen de la ciudad coruña
 -- cascada: Puedo borrar la ciudad de la tabla original ciudades, pero se eliminaran los registros relacionados en la tabla persona
 
 -- Puedo borrar el registro de la ciudad Barcelona
 delete from ciudades where nombre="barcelona";
 -- SI, porque no hay ninguna persona que dependa de la tabla idciudad en la tabla persona
 
 -- Puedo modificar el nombre de juana por juan?
 update personas set nombre="juan" where nombre="juana";
 -- Lo deja mdificar, aunque ka modificacion sea restrict, la columna es independiente de la clave foranea
 
 -- Puedo modificar el idciudad de juan por el idciudad 1
 update personas set idciudad=1 where nombre="juan";
 -- si permite modificar, si la idciudad exixte en la tabla ciudad no hay problema
 
 -- puedo modificar el idciudad de coruña por idciudad 200
 update ciudades set idciudad=200 where nombre="coruña";
 -- No se puede modificar porque intento modificar el idciudad en la tabla ciudades y existe una columna relacionada que tiene idciudad igual al que intento modificar
 
 -- CASCADE:
 alter table personas add constraint fkperosnnas_ciudades foreign key(idciudad) references ciudades(idciudad) on  delete cascade on update cascade;
 
 -- Puedo borrrar el registro de la persona pepe
 
 -- Puedo borrar el registro de la ciudad Coruña
 -- Puedo borrar la ciudad de la tabla original ciudades, pero se eliminaran los registros relacionados en la tabla persona
 
 -- Puedo borrar el registro de la ciudad Barcelona
 -- si, porque no existe ninguna persona en la tabla persona con el mismo idciudad que el idciudad de barcelona
 
 -- Puedo modificar el nombre de pepe por pepe?
 -- si, porque nombre es una columna con relacion con la clave foranea
 
  -- Puedo modificar el idciudad de juan por el idciudad 2
  -- no se puede en este caso concreto porque el idciudad de pepe no existe en la tabla ciudades, y el idciudad debe tener datos coherentes con que haya en el idciudad de la tabla ciudades
  
  