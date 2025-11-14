create database genshin_impact;
use genshin_impact;

CREATE TABLE personajes (
  id_personaje INT PRIMARY KEY,
  nombre VARCHAR(50),
  descripcion TEXT
);
INSERT INTO personajes VALUES
(1, 'Lumine',"Es una viajera interdimensional que proviene de otro mundo"),
(2, 'Albedo',"Es el Jefe Alquimista de los Caballeros de Favonius en Mondstadt");

CREATE TABLE misiones (
  id_mision INT PRIMARY KEY,
  nombre VARCHAR(100),
  dificultad varchar(100)
);
INSERT INTO misiones  VALUES
(1, 'Misión de la espada perdida', 'normal'),
(2, 'La gran tormenta de Mondstadt', 'dificil'),
(3, 'La aventura secreta de Inazuma', 'extrema');

CREATE TABLE elementos (
  id_elemento INT PRIMARY KEY,
  nombre VARCHAR(100),
  puntuacion INT
);
INSERT INTO elementos VALUES
(1, 'Cristales', 10),
(2, 'Cofres', 20),
(3, 'Artefactos', 30);


CREATE TABLE recolecta_elementos_mision (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_personaje INT,
  id_mision INT,
  cristales INT,
  cofres INT,
  artefactos INT
);

-- TABLA NECESARIA PARA EL EJERCICIO 1
CREATE TABLE puntuacion_mision (
  id_mision INT primary key,
  nombre varchar(100),
  puntos INT
);

-- TABLA NECESARIA PARA EL EJERCICIO 3
CREATE TABLE conteo_dificultad (
  dificultad ENUM('normal', 'dificil', 'extrema') PRIMARY KEY,
  cantidad INT
);
insert into conteo_dificultad values ('normal',1), ('dificil',1), ('extrema',1);

-- 1.
drop trigger if exists `BI_recoleccion`;
delimiter $$
create trigger `BI_recoleccion` before insert on recolecta_elementos_mision for each row
begin
declare pcris, pcof, part,tpunt int;
if(new.id_mision not in (select id_mision from misiones)) then
   signal sqlstate '45000' set message_text="La misión no existe";
end if;
if(new.id_personaje not in (select id_personaje from personajes)) then
   signal sqlstate '45000' set message_text="El personaje no existe";
end if;
if(new.cristales<0) then
   set new.cristales:= 0;
end if;
if(new.cofres<0) then
   set new.cofres:=0;
end if;
if(new.artefactos<0) then
   set new.artefactos:=0;
end if;

set pcris:= new.cristales*10;
set pcof:= new.cofres*20;
set part:= new.artefactos*30;
set tpunt:= (select pcris+pcof+part); 

if(new.id_mision not in (select id_mision from puntuacion_mision)) then
   insert into puntuacion_mision values(new.id_mision, (select nombre from misiones where id_mision=new.id_mision),tpunt);
else 
   update puntuacion_mision set puntos=puntos+tpunt;
end if;

end$$
delimiter ;

insert into recolecta_elementos_mision values(0,2,4,5,2,3);
insert into recolecta_elementos_mision values(0,3,3,5,2,3);
insert into recolecta_elementos_mision values(0,2,3,5,8,3);
insert into recolecta_elementos_mision values(0,1,3,5,10,3);
insert into recolecta_elementos_mision values(0,1,3,5,10,3);

-- 2

drop procedure if exists `recolectorDelMes`;
delimiter $$
create procedure `recolectorDelMes`()
begin
declare total,pj,pt,bpj int;
declare bpt int default 0;
declare c1 cursor for select id_personaje,sum(cristales)+sum(cofres)+sum(artefactos) from   recolecta_elementos_mision group by(id_personaje); 
declare continue handler for not found set total=1;

open c1;
bucle: loop
   fetch c1 into pj, pt;
   IF(total=1) then
      leave bucle;
   end if;
   if(pt>bpt) then
      set bpt:= pt;
      set bpj:= pj;
   end if;
   
end loop;
close c1;
select concat("El personaje con más elementos recolectados es ",(select nombre from personajes where id_personaje= bpj)," y ha conseguido ",bpt," elementos");
end$$
delimiter ;

call recolectorDelMes();

-- 3.
drop trigger if exists `BU_dificultad`;
delimiter $$
create trigger `BU_dificultad` before update on misiones for each row
begin
if(new.dificultad not in("dificil","extrema","normal")) then
    set new.dificultad:="normal";
end if;
if(new.id_mision <> old.id_mision or new.nombre <> old.nombre) then
   signal sqlstate '45000' set message_text="No se puede modificar esos campos";
end if;
update conteo_dificultad set cantidad= cantidad+1 where dificultad=new.dificultad;
update conteo_dificultad set cantidad= cantidad-1 where dificultad=old.dificultad;

end$$
delimiter ;
update misiones set nombre="mision1" where id_mision=1;
update misiones set id_mision=2 where id_mision=1;
update misiones set dificultad="facilon" where id_mision=2;