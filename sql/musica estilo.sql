create database musica;
use musica;
create table cancion (
codigo int NOT NULL,
nombre varchar (40) NOT NULL,
idioma varchar (10) NOT NULL,
genero varchar (10) NOT NULL,
album varchar (40) NOT NULL,
grupo varchar (25) NOT NULL,
fecha year NOT NULL,
constraint pk_canciON PRIMARY KEY (codigo)
);
create table generos(
    codigo int not null auto_increment,
    nombre varchar(20) not null,
    descripcion varchar(255) not null,
    constraint pk_generos primary key(codigo)
);
insert into cancion values ("1", "Antes de que cuente diez", "Español", "Rock", "Por la boca vive el pez", "Fito y Fitipaldis","2017");
insert into cancion values ("2", "Un violinista en tu tejado", "Español", "Pop", "Curiosa la cara de tu padre", "Melendi","2009");
insert into cancion values ("3", "Vogue", "Inglés", "Pop", "Celebration", "Madonna","2016");
insert into cancion values ("4", "Siamo", "Italiano", "Pop", "Vita ce n'e", "Eros Ramazzotti","2018");
insert into cancion values ("5", "Dulce introducción al caos", "Español", "Rock", "La ley innata", "Extremoduro","2008");

insert into generos values (0,"Pop","Estilo musical nacido en la década de 1960, que tiene elementos de la música rock y de la música popular británica");
insert into generos values (0,"Rock","Género musical de ritmo muy marcado, nacido a partir de la fusión de varios estilos del folclore estadounidense.");
insert into generos values (0,"Clásica","Corriente musical que se basa principalmente en la música producida o basada en las tradiciones de la música litúrgica y secular de Occidente");

alter table cancion add constraint fk_cancion_genero foreign key(genero) references generos(nombre); 
-- Crea una tabla temporal llamada TEspañolRock en la que guardes todas las canciones con idioma español de género Rock.
create temporary table TEspañolRock as (select * from cancion where idioma="español" and genero="rock");
select * from TEspañolRock;
-- Inserta un registro más en la tabla temporal creada con una canción en Español y género Rock.
insert into TEspañolRock values (0,"club de fans de johnboy","español","rock","1999","love of lesbian",2003);
-- Modifica la fecha de lanzamiento del registro de la tabla TEspañolRock que tenga como grupo a “Fito y Fitipaldis” y 
-- nombre de Albúm “Por la boca vive el pez”, indica que su fecha sea 2018.
update TEspañolRock set fecha=2018 where grupo="Fito y Fitipaldis" and album="Por la boca vive el pez";
-- Elimina de la tabla temporal el registro que tenga como fecha 2009 y nombre de grupo “Melendi”
delete from TEspañolRock where fecha=2009 and grupo="melendi";
-- Por último elimina la tabla temporal.
drop table TEspañolRock;
-- Modifica los registros correspondientes al atributo género en la tabla canciones con el comando adecuado. (Fijándote en la nueva tabla creada).

-- Crea una tabla temporal llamada CancionesPop en la que incluyas en nombre de la canción, el grupo, el nombre del género y su descripción.
create temporary table CancionesPop as (select cancion.nombre, grupo, genero, descripcion from generos join cancion on() )
-- Crea una tabla temporal llamada CancionesRock en la que incluyas las canciones de género rock que tengan fecha de lanzamiento posterior a la canción “Un violinista en tu tejado”
-- Crea una tabla temporal llamada NumeroCanciones en la que se incluya en nombre del género,
--  la descripción y el número de canciones que hay de cada uno de los tipos con el alias “Número canciones”.
-- Muestra la descripción de la tabla temporal CancionesRock.
-- Cierra la sesión, ábrela y comprueba que no existen ninguna de las tablas creadas.