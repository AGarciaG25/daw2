 drop database m;
 create database m;
 use m;
 create table concierto(
 id_concierto int auto_increment,
 fecha_hora datetime,
 precio_entrada decimal(6,2),
 entradas_vend int,
 Web_entrada varchar(200),
 num_entradas int,
 recaudacion decimal(8,2),
 inicio_venta_ent datetime,
 fech_actualizacion_ent date null,
 constraint pk_concierto primary key(id_concierto)
 );
 
 create table musico_compone(
 id_musico int null,
 id_cancion int,
 id_musicoDEP int null,
 constraint pk_musico_compone primary key(id_cancion)
 );
 
 create table grupo_compone(
 id_grupo int,
 id_cancion int,
 constraint pk_grupo_compone primary key(id_grupo,id_cancion)
 );
 
  create table genero_musical_grupo(
 id_grupo int,
 genero_musical varchar(30),
 constraint pk_genero_musical_grupo primary key(id_grupo,genero_musical)
 );
 
 create table genero_musical_musico(
 id_musico int null,
 id_difunto int null,
 genero_musical varchar(30),
 constraint pk_genero_musical_musico primary key(genero_musical)
 );
 
 create table musico(
Id_musico int auto_increment,
nombre varchar(30),
apellidos varchar(50),
fecha_nacimiento date,
dni varchar(9),
email varchar(40),
tipo enum("vocalista","instrumental"),
constraint pk_musico primary key(id_musico,tipo)
);

create table grupo_musical(
id_grupo int auto_increment,
nombre varchar(50),
fecha_creacion date,
fecha_dislucion date null,
pag_web varchar(100) null,
email varchar(50),
constraint pk_grupo_musical_grupo primary key(id_grupo)
);

create table musico_grupo(
 id_musico int,
 id_grupo int,
 fecha_union date,
 constraint pk_musico_grupo primary key(id_grupo));
 
 create table cancion(
 id_cancion int auto_increment,
 nombre varchar(150),
 partitura varchar(300),
 letra varchar(2000),
 fecha_creacion date,
 constraint pk_cancion primary key(id_cancion)
 );
 
 INSERT INTO `m`.`concierto` (`id_concierto`, `fecha_hora`, `precio_entrada`, `entradas_vend`, `Web_entrada`, `num_entradas`, `recaudacion`, `inicio_venta_ent`) VALUES ('1', '2025-10-30 20:00:00', '30', '0', 'entradas.com', '5000', '0', '2025-10-01 00:00:00');
insert into concierto (fecha_hora, precio_entrada, entradas_vend, web_entrada, num_entradas, recaudacion, inicio_venta_ent, fech_actualizacion_ent)
values
('2019-05-20 20:00:00', 35.00, 500, 'https://entradas2019.com', 800, 17500.00, '2018-10-15', null),
('2020-07-15 21:30:00', 40.00, 600, 'https://entradas2020.com', 1000, 24000.00, '2019-12-20', null),
('2020-10-10 19:00:00', 45.00, 700, 'https://live2020.com', 1000, 31500.00, '2020-02-01', null),
('2021-03-05 22:00:00', 30.00, 400, 'https://musica2021.com', 700, 12000.00, '2020-06-05', null),
('2021-11-25 18:00:00', 50.00, 800, 'https://eventos2021.com', 900, 40000.00, '2021-01-20', null),
('2022-04-10 20:30:00', 60.00, 900, 'https://rock2022.com', 1000, 54000.00, '2021-07-15', null),
('2022-08-18 21:00:00', 55.00, 850, 'https://verano2022.com', 1000, 46750.00, '2021-10-10', null),
('2023-02-14 19:30:00', 38.00, 300, 'https://amor2023.com', 500, 11400.00, '2022-06-01', null),
('2023-09-29 22:00:00', 70.00, 950, 'https://mega2023.com', 1000, 66500.00, '2023-01-05', null),
('2024-06-12 20:00:00', 42.00, 600, 'https://junio2024.com', 800, 25200.00, '2023-08-10', null);
INSERT INTO `m`.`concierto` (`id_concierto`, `fecha_hora`, `precio_entrada`, `entradas_vend`, `Web_entrada`, `num_entradas`, `recaudacion`, `inicio_venta_ent`) VALUES ('12', '2025-09-12 20:00:00', '10', '0', 'https://junio2025.com', '1000', '0', '2025-03-10 00:00:00');

-- Inserts para la tabla cancion
insert into cancion (nombre, partitura, letra, fecha_creacion) values
('Amanecer Eterno', 'partituras/amanecer.pdf', 'Letra de Amanecer Eterno...', '2010-04-15'),
('Ritmo del Silencio', 'partituras/ritmo_silencio.pdf', 'Letra de Ritmo del Silencio...', '2008-11-03'),
('Eco del Mar', 'partituras/eco_mar.pdf', 'Letra de Eco del Mar...', '2015-06-22'),
('Sombras de Luz', 'partituras/sombras_luz.pdf', 'Letra de Sombras de Luz...', '2001-01-09'),
('Viaje Interior', 'partituras/viaje_interior.pdf', 'Letra de Viaje Interior...', '1999-09-30'),
('AAA', 'partituras/AAA.pdf', 'Letra de AAA...', '2001-09-30');
-- Inserts para la tabla musico
insert into musico (nombre, apellidos, fecha_nacimiento, dni, email, tipo) values
('Carlos', 'Sánchez', '1980-05-12', '12345678A', 'carlos@example.com', 'vocalista'),
('Ana', 'Martínez', '1975-03-22', '23456789B', 'ana@example.com', 'instrumental'),
('Luis', 'Pérez', '1990-08-14', '34567890C', 'luis@example.com', 'vocalista'),
('María', 'Gómez', '1988-01-30', '45678901D', 'maria@example.com', 'instrumental'),
('Pedro', 'López', '1992-12-05', '56789012E', 'pedro@example.com', 'vocalista');

-- Inserts para la tabla grupo_musical
insert into grupo_musical (nombre, fecha_creacion, fecha_dislucion, pag_web, email) values
('Los Armónicos', '2000-03-15', null, 'www.armonicos.com', 'info@armonicos.com'),
('Melodía Eterna', '1995-06-20', '2010-04-01', null, 'contacto@melodia.com'),
('Voces del Viento', '2003-11-11', null, 'www.vocesviento.org', 'voces@viento.org'),
('Sinfonía Urbana', '2012-09-05', null, 'www.sinfoniaurbana.com', 'info@sinfoniaurbana.com'),
('Notas Libres', '2007-01-01', null, 'www.notaslibres.com', 'libres@musica.com');

-- Inserts para musico_compone
insert into musico_compone values
(1, 1,null), (2, 2, null), (3, 3, null), (4, 4, null), (5, 5, null), (1, 6, null);

-- Inserts para grupo_compone
insert into grupo_compone (id_grupo, id_cancion) values
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- Inserts para genero_musical_grupo
insert into genero_musical_grupo (id_grupo, genero_musical) values
(1, 'Rock'), (2, 'Pop'), (3, 'Jazz'), (4, 'Clásica'), (5, 'Fusión');

-- Inserts para genero_musical_musico
insert into genero_musical_musico values
(1,null, 'Rock'), (2,null, 'Pop'), (3,null, 'Jazz'), (4,null, 'Clásica'), (5,null, 'Fusión');

-- Inserts para musico_grupo
insert into musico_grupo (id_musico, id_grupo, fecha_union) values
(1, 1, '2001-01-01'), (2, 2, '1996-05-01'), (3, 3, '2004-12-10'), (4, 4, '2013-03-03'), (5, 5, '2008-06-06');

create table musico_difunto (
  id_difunto int auto_increment primary key,
  id_musico int,
  nombre varchar(30),
  apellidos varchar(50),
  fecha_fallecimiento date
);

create table canciones_difunto (
  id int auto_increment primary key,
  id_difunto int,
  id_cancion int,
   nombre varchar(150),
  foreign key (id_difunto) references musico_difunto(id_difunto),
  foreign key (id_cancion) references cancion(id_cancion)
);


alter table genero_musical_grupo add constraint fk_genero_musical_grupo foreign key(id_grupo) references grupo_musical(id_grupo);
alter table musico_grupo add constraint fk_musico_grupo foreign key(id_grupo) references grupo_musical(id_grupo);
alter table musico_compone add constraint fk_compone_musico1 foreign key(id_cancion) references cancion(id_cancion);

-- --------------------------------------------------------------------------------------------
/*Este evento aumenta el precio de la entrada en un 5% cada mes desde el inicio de la venta de las entradas del concierto hasta que 
sea la fecha del concierto*/
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS aumentarPre;
DELIMITER $$
CREATE EVENT aumentarPre
ON SCHEDULE every 1 day starts '2025-05-08 22:27:00'
DO
BEGIN
UPDATE concierto
   SET precio_entrada = ROUND(precio_entrada * 1.05, 2),fech_actualizacion_ent = NOW()
   WHERE (fecha_hora > NOW() AND fech_actualizacion_ent IS NULL AND DATEDIFF(NOW(), inicio_venta_ent) >= 30)
   OR (fecha_hora > NOW() AND DATEDIFF(NOW(), fech_actualizacion_ent) >= 30);
END$$
DELIMITER ;
 select now();

 -- ------------------------------------------------------------------------------------------------------
 /*Se crea un trigger en el que antes de actualizar los campos de la tabla concierto se comprobara que:
 No se intente modificar la recaudación, el id del concierto, el precio de la entrada, la fecha  de actualización de la entrada.
 Y si se intenta modificcar la fecha del concierto y el inicio de la venta de entradas, solo se podra realizar si hay un margen de mas de 30 día previos a cada fecha.
 Si se intenta modificar el numero de entradas vendidas solo estara permitido si dpera al numero de entradas totales.
 Realizados todos estos controles se actualizara la recaudacion en relación al numero de ntradas vendias, y se sumaran las nuevas entradas vendidas al total.*/
drop trigger if exists BU_recaudacion;
delimiter $$
create trigger BU_recaudacion before update on concierto for each row
begin
if(new.recaudacion <> old.recaudacion) then
    signal sqlstate '45000' set message_text="No está permitido modificar manualmente la reacudación";
end if;
if(new.id_concierto <> old.id_concierto) then
    signal sqlstate '45000' set message_text="No está permitido modificar el id del concierto";
end if;
if (new.fecha_hora <> old.fecha_hora) then
     if(datediff(old.fecha_hora,now())<30) then
          signal sqlstate '45000' set message_text="El margen de tiempo para modificar la fecha del concierto es inferior a 30 días";
	 end if;
end if;
if(new.precio_entrada <> old.precio_entrada) then
    signal sqlstate '45000' set message_text="No está permitido modificar manualmente el precio de la entrada";
end if;
if(new.fech_actualizacion_ent <> old.fech_actualizacion_ent) then
    signal sqlstate '45000' set message_text="No está permitido modificar manualmente la fecha de actualizacion del precio";
end if;
if(new.inicio_venta_ent <> old.inicio_venta_ent) then
     if(datediff(old.inicio_venta_ent,now())<30) then
          signal sqlstate '45000' set message_text="El margen de tiempo para modificar la fecha del inicio de venta de etradas es menor a 30 días";
	end if;
end if;
if(new.num_entradas< old.entradas_vend + new.entradas_vend) then
	signal sqlstate '45000' set message_text="El numero de entradas vendidas no puede superar al numero de entradas totales";
end if;
set new.recaudacion = old.recaudacion + (new.precio_entrada * new.entradas_vend);
set new.entradas_vend = old.entradas_vend + new.entradas_vend;
end $$
delimiter ;
update concierto set recaudacion=50 where id_concierto = 1;
update concierto set id_concierto= 2 where id_concierto = 1;
update concierto set fecha_hora=now() where id_concierto = 2;
update concierto set precio_entrada =50 where id_concierto = 1;
update concierto set fech_actualizacion_ent=now() where id_concierto = 2;
update concierto set inicio_venta_ent=now() where id_concierto = 2;
update concierto set entradas_vend=9000 where id_concierto = 1;
update concierto set entradas_vend=50 where id_concierto = 1;

-- ---------------------------------------------------------------------------------------------

create table res_anual_recaudacion (
  id_resumen int auto_increment primary key,
  año int,
  id_concierto_top int,
  recaudacion_top decimal(8,2),
  recaudacion_anual decimal(8,2)
);
/*Al ejecutar este procedimiento insertaremos en la tabla de resultados anuales cada año que se han realizado conciertos, indicando que concierto optenio más recaudación 
dicho año y la suma de la recaudación de todos los conciertos ese año*/
drop procedure if exists `maxRecaudacion`;
DELIMITER $$
create procedure `maxRecaudacion`()
begin
declare final int default 0;
declare a, id int;
declare M_año, S_año decimal(8,2);
declare c1 cursor for select year(fecha_hora), max(recaudacion),sum(recaudacion) from concierto group by(year(fecha_hora));
declare continue handler for not found set final=1;
open c1;
bucle:loop
   fetch c1 into a, M_año, S_año;
   if(final=1) then
      leave bucle;
   end if;
      set id = (select id_concierto from concierto where recaudacion = M_año and year(fecha_hora)= a limit 1);
      
      delete from res_anual_recaudacion where año = a;
      
      insert into res_anual_recaudacion values(0,a,id,M_año,S_año);
      
end loop;
close c1;
end$$
DELIMITER ;
call maxrecaudacion;

-- -------------------------------------------------------------------------
/*Se crea un trigger AFTER DELETE sobre la tabla musico, que asume que la eliminación de un músico se debe a su fallecimiento. 
Al activarse, guarda algunos de sus datos en la tabla musico_difunto y registra los nombres de las canciones que compuso en 
la tabla canciones_difunto, asociándolos con su nuevo identificador como difunto (id_difunto). 
Dado que un trigger AFTER DELETE no permite acceder a claves foráneas activas del registro eliminado, 
fue necesario eliminar dichas restricciones en las tablas relacionadas, lo que obliga a actualizar manualmente los valores de id_musico, 
estableciéndolos a NULL y reemplazándolos con el id_difunto cuando sea necesario. Además, por cada grupo al que pertenecía el músico, 
se intenta buscar automáticamente un sustituto que no esté ya en ese grupo, que pertenezca al mismo género musical y que 
no sea el músico eliminado; si se encuentra uno, se asigna al grupo, y si no, se registra el intento fallido en una tabla de log para su seguimiento.*/

drop trigger if exists AD_DEPmusico;
delimiter $$
create trigger AD_DEPmusico after delete on musico for each row
begin
declare difunto_id int;
declare id_grupo_actual int;
declare id_sustituto int;
declare id_genero int;
declare fin int default 0;

declare c1 cursor for select id_grupo from musico_grupo where id_musico = old.id_musico;
declare continue handler for not found set fin = 1;

insert into musico_difunto values (0, old.id_musico, old.nombre, old.apellidos, current_date());

set difunto_id =(select id_difunto  from musico_difunto where id_musico = old.id_musico);

insert into canciones_difunto values(0,(select difunto_id, c.id_cancion, c.nombre
from musico_compone mc join cancion c on c.id_cancion = mc.id_cancion where mc.id_musico = old.id_musico));

update musico_compone set id_musicoDEP = difunto_id, id_musico = null where id_musico = old.id_musico;

update genero_musical_musico set id_difunto = difunto_id, id_musico = null where id_musico = old.id_musico;

set id_genero =(select id_genero  from genero_musical_musico where id_musico = old.id_musico limit 1);

open c1;
    repetir: loop
        fetch c1 into id_grupo_actual;
        if fin = 1 then
            leave repetir;
        end if;
        delete from musico_grupo where id_musico = old.id_musico and id_grupo = id_grupo_actual;

        select m.id_musico into id_sustituto from musico m join genero_musical_musico gm on gm.id_musico = m.id_musico
        where gm.id_genero = id_genero and m.id_musico != old.id_musico and m.id_musico not in 
        (select id_musico from musico_grupo where id_grupo = id_grupo_actual) limit 1;

        if id_sustituto is not null then
            insert into musico_grupo (id_musico, id_grupo)
            values (id_sustituto, id_grupo_actual);
        end if;

    end loop;
close c1;
end$$
delimiter ;

delete from musico where id_musico = 1;
           
