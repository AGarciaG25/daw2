create database sector_musical;
create table musico(
Id_musico int auto_increment,
nombre varchar(30),
apellidos varchar(50),
fecha_nacimiento date,
fecha_defuncion date null,
dni varchar(9),
email varchar(40),
tipo enum("vocalista","instrumental"),
constraint pk_musico primary key(id_musico,tipo)
);

create table telf_musico(
id_musico int,
telf varchar(9),
constraint pk_telf_musico primary key(id_musico)
);

create table vocalista(
id_musico int,
rango_vocal enum("Tenor","Barítono","Bajo","Soprano","Mezzosoprano","Contralto"),
constraint pk_vocalista primary key(id_musico)
);

create table instrumental(
id_musico int,
año_inicio int,
constraint pk_instrumental primary key(id_musico)
);

create table instrumento(
id_musico int,
instrumento varchar(40),
constraint pk_instrumento primary key(id_musico,instrumento)
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

 create table genero_musical_grupo(
 id_grupo int,
 genero_musical varchar(30),
 constraint pk_genero_musical_grupo primary key(id_grupo,genero_musical)
 );
 
 create table genero_musical_musico(
 id_musico int,
 genero_musical varchar(30),
 constraint pk_genero_musical_musico primary key(id_musico,genero_musical)
 );
 
 create table telf_grupo(
 id_grupo int,
 telf varchar(9),
 constraint pk_telf_grupo primary key(id_grupo,telf)
 );
 
 create table musico_grupo(
 id_musico int,
 id_grupo int,
 fecha_union date,
 constraint pk_musico_grupo primary key(id_musico,id_grupo)
 );
 
 create table cancion(
 id_cancion int auto_increment,
 nombre varchar(150),
 partitura varchar(300),
 letra varchar(2000),
 fecha_creacion date,
 constraint pk_cancion primary key(id_cancion)
 );
 
 create table musico_compone(
 id_musico int,
 id_cancion int,
 constraint pk_musico_compone primary key(id_musico,id_cancion)
 );
 
 create table grupo_compone(
 id_grupo int,
 id_cancion int,
 constraint pk_grupo_compone primary key(id_grupo,id_cancion)
 );
 
 create table concierto(
 id_concierto int auto_increment,
 fecha_hora datetime,
 precio_entrada decimal(4,2),
 Web_entrada varchar(200),
 id_recinto int,
 constraint pk_concierto primary key(id_concierto)
 );
 
 create table musico_toca(
 id_musico int,
 id_cancion int,
 id_concierto int,
 constraint pk_musico_toca primary key(id_musico,id_cancion,id_concierto)
 );
 
 create table grupo_toca(
 id_grupo int,
 id_cancion int,
 id_concierto int,
 constraint pk_grupo_toca primary key(id_grupo,id_cancion,id_concierto)
 );

create table recinto(
id_recinto int auto_increment,
ciudad varchar(30),
Pais varchar(30),
aforo varchar(5),
direccion varchar(50),
constraint pk_recinto primary key(id_recinto)
);

insert into cancion values (1,"21 guns","carpeta/musica","Do you know what's worth fightin' for","01-01-09");
insert into cancion values (2,"Californication","carpeta/musica","Psychic spies from China try to steal your mind's elation","1999-11-01");
insert into cancion values (3,"thriller","D/music","It's close to midnight","1984-05-15");
insert into cancion values (4,"photograph","D/music","Loving can hurt, loving can hurt sometimes","2010-05-10");
insert into cancion values (5,"Dark Necessities","D/music","Comin' on to the light of day, we got","2016-05-15");



insert into musico values (1,"Ed","Sheeran","1990-05-21",null,"11111111A","ed@gmail.com","vocalista");
insert into musico values (2,"Carlos","Perez","1943-11-11","2020-05-03","12345678B","Carlos@gmail.com","instrumental");
insert into musico values (3,"Martin","Garcia","1990-05-21",null,"22222222C","martin@gmail.com","vocalista");
insert into musico values (4,"Carla","Cambon","1975-07-12",null,"33333333D","carlagmail.com","instrumental");
insert into musico values (5,"Laura","Garcia","1996-12-13",null,"44444444E","laura@gmail.com","vocalista");
INSERT INTO `sector_musical`.`musico` (`nombre`, `apellidos`, `fecha_nacimiento`, `dni`, `email`, `tipo`) VALUES ('Juan', 'castro', '2000-05-14', '55555555H', 'juan@hotmail.com', 'instrumental');
insert into musico values(0,"pedro","smith","1986-12-25",null,"66666666J","pedro@gmal.com","vocalista");
insert into musico values(0,"jin","garcia","1996-07-15",null,"7777777L","jin@gmail.com","instrumental");
insert into musico values(0,"horus","lugo","1997-12-18",null,"48628614H","horus@gmail.com","instrumental");

INSERT INTO `sector_musical`.`grupo_musical` (`nombre`, `fecha_creacion`, `pag_web`, `email`) VALUES ('los ramones', '1985-10-05', 'losramones.com', 'losramones@gmail.com');
INSERT INTO `sector_musical`.`grupo_musical` (`nombre`, `fecha_creacion`, `fecha_dislucion`, `email`) VALUES ('el duo dinamico', '1999-05-15', '2005-12-20', 'duo@gmail.com');
INSERT INTO `sector_musical`.`grupo_musical` (`nombre`, `fecha_creacion`, `pag_web`, `email`) VALUES ('redhot', '1985-03-20', 'redhot.com', 'redhot@gmail.com');
INSERT INTO `sector_musical`.`grupo_musical` (`nombre`, `fecha_creacion`, `pag_web`, `email`) VALUES ('greenday', '1995-05-23', 'greenday.com', 'greenday@gmail.com');
INSERT INTO `sector_musical`.`grupo_musical` (`nombre`, `fecha_creacion`, `fecha_dislucion`, `pag_web`, `email`) VALUES ('merequetenge', '2023-12-15', '2024-01-01', 'merequetenge.com', 'merequetenge@gmail.com');

INSERT INTO `sector_musical`.`genero_musical_grupo` (`id_grupo`, `genero_musical`) VALUES ('2', 'rock');
INSERT INTO `sector_musical`.`genero_musical_grupo` (`id_grupo`, `genero_musical`) VALUES ('1', 'clasica');
INSERT INTO `sector_musical`.`genero_musical_grupo` (`id_grupo`, `genero_musical`) VALUES ('5', 'indie');
INSERT INTO `sector_musical`.`genero_musical_grupo` (`id_grupo`, `genero_musical`) VALUES ('2', 'pop');
INSERT INTO `sector_musical`.`genero_musical_grupo` (`id_grupo`, `genero_musical`) VALUES ('3', 'urban');

INSERT INTO `sector_musical`.`grupo_compone` (`id_grupo`, `id_cancion`) VALUES ('2', '2');
INSERT INTO `sector_musical`.`grupo_compone` (`id_grupo`, `id_cancion`) VALUES ('1', '1');
INSERT INTO `sector_musical`.`grupo_compone` (`id_grupo`, `id_cancion`) VALUES ('4', '5');
INSERT INTO `sector_musical`.`grupo_compone` (`id_grupo`, `id_cancion`) VALUES ('3', '3');
INSERT INTO `sector_musical`.`grupo_compone` (`id_grupo`, `id_cancion`) VALUES ('1', '4');

INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('1', 'rock');
INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('2', 'indie');
INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('3', 'clasica');
INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('4', 'urban');
INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('5', 'rock');
INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('6', 'rap');
INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('7', 'urban');
INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('8', 'trap');
INSERT INTO `sector_musical`.`genero_musical_musico` (`id_musico`, `genero_musical`) VALUES ('9', 'merengue');


alter table genero_musical_musico add constraint fk_genero_musical_musico foreign key(id_musico) references musico(id_musico);
alter table telf_musico add constraint fk_telf_musico foreign key(id_musico) references musico(id_musico);
alter table vocalista add constraint fk_vocalista_musico foreign key(id_musico) references musico(id_musico);
alter table instrumental add constraint fk_instrumental_musico foreign key(id_musico) references musico(id_musico);
alter table instrumento add constraint fk_instrumento_musico foreign key(id_musico) references musico(id_musico);
alter table genero_musical_grupo add constraint fk_genero_musical_grupo foreign key(id_grupo) references grupo_musical(id_grupo);
alter table telf_grupo add constraint fk_telf_grupo foreign key(id_grupo) references grupo_musical(id_grupo);
alter table musico_grupo add constraint fk_musico_grupo foreign key(id_grupo) references grupo_musical(id_grupo);
alter table musico_grupo add constraint fk_musico_grupo1 foreign key(id_musico) references musico(id_musico);
alter table musico_compone add constraint fk_compone_musico foreign key(id_musico) references musico(id_musico);
alter table musico_compone add constraint fk_compone_musico1 foreign key(id_cancion) references cancion(id_cancion);
alter table grupo_compone add constraint fk_compone_grupo foreign key(id_cancion) references cancion(id_cancion);
alter table grupo_compone add constraint fk_compone_grupo1 foreign key(id_grupo) references grupo_musical(id_grupo);
alter table grupo_toca add constraint fk_toca_grupo foreign key(id_grupo) references grupo_musical(id_grupo);
alter table grupo_toca add constraint fk_toca_grupo1 foreign key(id_cancion) references cancion(id_cancion);
alter table grupo_toca add constraint fk_toca_grupo2 foreign key(id_cancion) references concierto(id_concierto);
alter table musico_toca add constraint fk_toca_musico foreign key(id_musico) references musico(id_musico);
alter table musico_toca add constraint fk_toca_musico1 foreign key(id_cancion) references cancion(id_cancion);
alter table musico_toca add constraint fk_toca_musico2 foreign key(id_concierto) references concierto(id_concierto);
alter table concierto add constraint fk_concierto_recinto foreign key(id_recinto) references recinto(id_recinto);

select * from musico where tipo like "vocalista";
select * from musico where fecha_defuncion is not null;
select * from instrumento where instrumento like "guitarra";
select nombre from grupo_musical where fecha_creacion > "1999-12-31";
select id_concierto from concierto where id_recinto=1;
select pais,ciudad,direccion from recinto where aforo >=5000;
select round(avg(precio_entrada),2) as media_entrada from concierto;
select * from musico order by fecha_nacimiento desc;
select * from telf_grupo where id_grupo=2;
select max(aforo) as "aforo max" from recinto;
select min(precio_entrada) as "precio min", max(precio_entrada) as"precio max" from concierto;


drop procedure if exists `busquedaFrase`;
DELIMITER $$
create procedure `busquedaFrase`(pl varchar(20), idi varchar(3))
begin
declare exist,cont int;
set exist:=(select count(*) from information_schema.tables where table_schema="sector_musical" and table_name="palabras");
if(idi not in ("ES","EN")) then
     signal sqlstate '45000' set message_text="El idioma introducido no está entre las opciones ES o EN";
elseif(exist=0) then
    create table palabras(
    idPla int auto_increment primary key,
    palabra varchar(20),
    idioma enum("ES","EN"));
end if;
if(pl in (select palabra from palabras)) then
     select concat("La palabra ", pl," ya existe en la tabla palabras");
else
     insert into palabras values (0,pl,upper(idi));
     select concat("La palabra ", pl," ha sido añadida con el idioma ", idi);
      while cont > (select count(*) from cancion) do
     if(select locate(pl,(select letra from cancion where id_cancion=cont)) != 0) then
           if((select censura from cancion where id_cancion=cont)is null and (select idiomas from cancion where id_cancion=cont)=idi ) then
                update cancion set censura=true  where id_cancion=cont;
			end if;
	end if;
     set cont:= cont+1;
end while;
end if;
end$$
DELIMITER ;

call busquedafrase("day","EN");
call busquedafrase("casa","es");

drop procedure if exists `pegi18`;
DELIMITER $$
create procedure `pegi18`()
begin
declare cont int default 0;
while cont > (select count(*) from cancion) do
     if(select locate(pl,(select letra from cancion where id_cancion=cont)) != 0) then
           if((select censura from cancion where id_cancion=cont)is null and (select idiomas from cancion where id_cancion=cont)=idi ) then
                update cancion set censura=true  where id_cancion=cont;
			end if;
	end if;
     set cont:= cont+1;
end while;
end$$
DELIMITER ;

-- ------------------------------------------------------------- --
DROP function IF EXISTS `SOTY`;
DELIMITER $$
CREATE FUNCTION `SOTY` (n varchar(50), an int)
RETURNS varchar(100)
BEGIN
declare retorno varchar(100);
declare idco,idn,cont int;
declare quien varchar(10);
if(n not in(select nombre from musico) and n not  in(select nombre from grupo_musical)) then
      set retorno:= concat("El nombre ",n," no ha sido encontrado en la base de datos");
elseif(an not in (select year(fecha_hora)from concierto)) then
      set retorno:= concat("En el año ",an," no se realizó ningun concierto");
	else
         set idco:= (select id_concierto from concierto where fecha_hora=((select fecha_hora from concierto  where year(fecha_hora)=an)));
         if(n in(select nombre from musico)) then
               set idn:=(select id_musico from musico where nombre= n);
               set cont:= (select count(id_cancion) from musico_toca where id_concierto=idco and id_musico=idn);
               set quien:="musico";
		 else
               set idn:=(select id_grupo from grupo_musical where nombre= n);
               set cont:= (select count(id_cancion) from grupo_toca where id_concierto=idco and id_grupo=idn);
               set quien:="grupo";
		end if;
        case
	  when cont=0 then
		set retorno:= concat("El ",quien," ",n," no cantó ninguna canción el año ",an," en el concierto ",idco);
	  when (cont>=1 and cont<3) then
		set retorno:= concat("El ",quien," ",n," tuvo un mal año ",an," cantando solo ",cont," canciones en el concierto ",idco);
	  else
	    set retorno:= concat("El ",quien," ",n," tuvo un buen año ",an," cantando con un total de ",cont," canciones en el concierto ",idco);
	end case;
        
  end if;     
RETURN retorno;
END$$

select SOTY("e",2024);
select SOTY("ed",50);
select SOTY("el duo dinamico",2016);
select SOTY("carlos",2006);
select SOTY("ed",2023);