create database musicote;
use musicote;

 create table cancion(
 id_cancion int auto_increment,
 nombre varchar(150),
 partitura varchar(300),
 letra varchar(2000),
 fecha_creacion date,
 idiomas varchar(3),
 censura boolean null,
 constraint pk_cancion primary key(id_cancion)
 );
 
 create table concierto(
 id_concierto int auto_increment,
 fecha_hora datetime,
 precio_entrada decimal(4,2),
 Web_entrada varchar(200),
 id_recinto int,
 constraint pk_concierto primary key(id_concierto)
 );
 
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

create table grupo_musical(
id_grupo int auto_increment,
nombre varchar(50),
fecha_creacion date,
fecha_dislucion date null,
pag_web varchar(100) null,
email varchar(50),
constraint pk_grupo_musical_grupo primary key(id_grupo)
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

insert into cancion values (0,"21 guns","carpeta/musica","Do you know what's worth fightin' for","01-01-09","EN",null);
insert into cancion values (0,"Californication","carpeta/musica","Psychic spies from China try to steal your mind's elation","1999-11-01","EN",null);
insert into cancion values (0,"thriller","D/music","It's close to midnight","1984-05-15","EN",null);
insert into cancion values (0,"photograph","D/music","Loving can hurt, loving can hurt sometimes","2010-05-10","EN",null);
insert into cancion values (0,"Dark Necessities","D/music","Comin' on to the light of day, we got","2016-05-15","EN",null);

insert into musico values (1,"Ed","Sheeran","1990-05-21",null,"11111111A","ed@gmail.com","vocalista");
insert into musico values (2,"Carlos","Perez","1943-11-11","2020-05-03","12345678B","Carlos@gmail.com","instrumental");
insert into musico values (3,"Martin","Garcia","1990-05-21",null,"22222222C","martin@gmail.com","vocalista");
insert into musico values (4,"Carla","Cambon","1975-07-12",null,"33333333D","carlagmail.com","instrumental");
insert into musico values (5,"Laura","Garcia","1996-12-13",null,"44444444E","laura@gmail.com","vocalista");
INSERT INTO `musicote`.`musico` (`nombre`, `apellidos`, `fecha_nacimiento`, `dni`, `email`, `tipo`) VALUES ('Juan', 'castro', '2000-05-14', '55555555H', 'juan@hotmail.com', 'instrumental');
insert into musico values(0,"pedro","smith","1986-12-25",null,"66666666J","pedro@gmal.com","vocalista");
insert into musico values(0,"jin","garcia","1996-07-15",null,"7777777L","jin@gmail.com","instrumental");
insert into musico values(0,"horus","lugo","1997-12-18",null,"48628614H","horus@gmail.com","instrumental");

INSERT INTO `musicote`.`grupo_musical` (`nombre`, `fecha_creacion`, `pag_web`, `email`) VALUES ('los ramones', '1985-10-05', 'losramones.com', 'losramones@gmail.com');
INSERT INTO `musicote`.`grupo_musical` (`nombre`, `fecha_creacion`, `fecha_dislucion`, `email`) VALUES ('el duo dinamico', '1999-05-15', '2005-12-20', 'duo@gmail.com');
INSERT INTO `musicote`.`grupo_musical` (`nombre`, `fecha_creacion`, `pag_web`, `email`) VALUES ('redhot', '1985-03-20', 'redhot.com', 'redhot@gmail.com');
INSERT INTO `musicote`.`grupo_musical` (`nombre`, `fecha_creacion`, `pag_web`, `email`) VALUES ('greenday', '1995-05-23', 'greenday.com', 'greenday@gmail.com');
INSERT INTO `musicote`.`grupo_musical` (`nombre`, `fecha_creacion`, `fecha_dislucion`, `pag_web`, `email`) VALUES ('merequetenge', '2023-12-15', '2024-01-01', 'merequetenge.com', 'merequetenge@gmail.com');

insert into concierto values(0,"2024-08-13 00:00:00",60.50,"entradas.con",1);
insert into concierto values(0,"2006-07-21 00:00:00",53.00,"ticket.com",3);
insert into concierto values(0,"2010-09-25 00:00:00",25.80,"entradas.con",2);
insert into concierto values(0,"2016-07-30 00:00:00",33.00,"ticketmaster.com",1);
insert into concierto values(0,"2023-06-15 00:00:00",45.00,"entradas.con",4);

insert into grupo_toca values(2,1,4);
insert into grupo_toca values(2,2,3);
insert into grupo_toca values(3,3,2);
insert into grupo_toca values(4,4,4);
insert into grupo_toca values(5,5,1);
insert into grupo_toca values(2,3,3);
insert into grupo_toca values(2,4,3);
insert into grupo_toca values(3,1,2);

insert into musico_toca values(8,1,1);
insert into musico_toca values(8,3,1);
insert into musico_toca values(5,4,3);
insert into musico_toca values(7,5,4);
insert into musico_toca values(8,4,1);
insert into musico_toca values(8,2,1);

-- -------------------------------------------------------- --

/*Se creará un procedimiento al que le aportaremos 2 valores, una palabra y su idioma, permitiendo solamente"EN" y "ES" en este.
Si el idioma no está entre los dos permitidos se mostrara el mensaje "El idioma introducido no está entre las opciones ES o EN" por consola.
Una vez hecho este  control se comprobara si la tabla palabras existe, de no existir se creará dicha tabla con 3 parametros(id,palabra e idioma).
Posteriormente se añadiran los parametros pasados al procedimiento a la tabla.
Si la palabra ya fue añadida anteriormente en la tabla palabras se mostrara el mensaje "La palabra Xpalabra ya existe en la tabla palabras, de lo contrario se insertara
en la tabla con su idioma. y mostrara el mensaje "La palabra xpalabra ha sido añadida con el idioma xidioma.".
Ahora se busca la palabra, una por una en cada letra de la tabla canción, comprobando que el idioma coincida y que la columna censura esté en null. Si cumple con todas las condiciones 
se pondrá en true en la columna censura de cada canción.
*/

drop procedure if exists `busquedaFrase`;
DELIMITER $$
create procedure `busquedaFrase`(pl varchar(20), idi varchar(3))
begin
declare exist,clet int;
declare cont int default 1;
set exist:=(select count(*) from information_schema.tables where table_schema="musicote" and table_name="palabras");
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
     set clet:=(select count(*) from cancion);
	 while cont <= clet do
            if(select locate(pl,(select letra from cancion where id_cancion=cont)) != 0 
            and (select censura from cancion where id_cancion=cont)is null 
            and (select idiomas from cancion where id_cancion=cont)=idi) then
				  update cancion set censura=true  where id_cancion=cont;
			end if;
			set cont:= cont+1;
	  end while;
	  select concat("La palabra ", pl," ha sido añadida con el idioma ", idi);
end if;
end$$
DELIMITER ;
select count(*) from cancion;
select locate("day",(select letra from cancion where id_cancion=5));
select censura from cancion where id_cancion=1;
select idiomas from cancion where id_cancion=1;
update cancion set censura=true  where id_cancion=5;
call busquedaFrase("day","en");
call busquedaFrase("know","en");
call busquedaFrase("close","en");
call busquedaFrase("casa","er");
call busquedaFrase("casa","es");

-- ----------------------------------------------------------- --
/*Se creara una función la que introduciendo 2 valores, el primero un nombre y el segundo un año.
Se comprobará si el nombre que se le ha pasado, existe en la tabla de músicos o de grupos musicales.
De no aparecer se returnará la cadena "El nombre xnombre no ha sido encontrado en la base de datos".
Si el nombre existe se comprobará si se ha realizado algún concierto en el año introducido, de no aparecer
se retornará la cadena "En el año xaño no se realizó ningun concierto". Realizadas estas  comprobaciones,
se sumarán las canciones que ha tocado el músico o el grupo con el nombre que se pasó, en el concierto del
año introducido. Dependiendo de si no se ha tocado ninguna, se han tocado algunas o se han tocado muchas,
se rotornará un mensaje diferente.
 
*/
DROP function IF EXISTS `SOTY`;
DELIMITER $$
CREATE FUNCTION `SOTY` (n varchar(50), an int)
RETURNS varchar(500)
BEGIN
declare retorno varchar(500);
declare idco,idn,cont int;
declare quien, plur varchar(10);
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
        if(cont>1) then
           set plur:= "canciones";
		else
           set plur:= "canción";
		end if;
        case
	  when cont=0 then
		set retorno:= concat("El ",quien," ",n," no cantó ninguna canción el año ",an," en el concierto ",idco);
	  when (cont>=1 and cont<3) then
		set retorno:= concat("El ",quien," ",n," tuvo un mal año ",an," cantando solo ",cont," ",plur," en el concierto ",idco);
	  else
	    set retorno:= concat("El ",quien," ",n," tuvo un buen año ",an," cantando con un total de ",cont," canciones en el concierto ",idco);
	end case;
        
  end if;     
RETURN retorno;
END$$

select SOTY("e",2024);
select SOTY("ed",50);
select SOTY("el duo dinamico",2016);
select SOTY("redhot",2006);
select SOTY("el duo dinamico",2010);
select SOTY("carlos",2006);
select SOTY("ed",2023);
select SOTY("horus",2024);

-- ----------------------------------------------------- --
drop database musicote;


