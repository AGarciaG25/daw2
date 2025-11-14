/*Creo la base de datos: create, alter, drop!!!!!!*/
create database centro;
/*Selecciono la base de datos para realizar operaciones sobre ella*/
use centro;


/*  
  departamentos(PK codDep, nombre, FK dniProfJefe)
  profesores(PK dni, nombre, prApellido, sgApellido, telefono, sueldo,FK codDep)
  ciclos(PK codCi, nombre, siglas)
  asignaturas(PK codAsig, nombre, nh, b,FK  codCi)
  alumnos(PK dni, nombre, prApellido, sgApellido, bilingue)
  matricula(PKFK dni, PKFK codAsig, PK curso, nota)
  imparte(PKFK dni, PKFK codAsig, PK curso)
  alumbil(PKFK dni, fecha, lugar)
  */
  
/*Creo la tabla departamentos con sus atributos y su clave primaria*/
create table departamentos(
	codDep int not null auto_increment,
    nombre varchar(30) not null,
    dniProfJefe varchar(9) not null,
    constraint pk_dep primary key(codDep)
);

/*Creo la tabla profesores con sus atributos y su clave primaria*/
create table profesores(
  dni varchar(9) NOT NULL,
  nombre VARCHAR(20) NOT NULL,
  prApellido VARCHAR(30) NOT NULL,
  sgApellido VARCHAR(30) NULL,
  telefono varchar(9) not null, /*int, varchar, char*/
  sueldo DECIMAL(7,2) NOT NULL,
  codDep int not null,
  CONSTRAINT pk_prof PRIMARY KEY(dni)
  );
  
  /*Creo la tabla ciclos con sus atributos y su clave primaria*/
  CREATE TABLE ciclos(
  codCi INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  siglas VARCHAR(5) NOT NULL,
  CONSTRAINT pk_ciclo PRIMARY KEY (codCi)
  );
  
  /*Creo la tabla asignaturas con sus atributos y su clave primaria*/
  CREATE TABLE asignaturas(
  codAsig INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  nh INT NOT NULL,
  b VARCHAR(1) NOT NULL, /*no puede ser boolean porque sino sería 1, 0 y en la insercción de datos os pongo S, N*/
  codCi INT NOT NULL,
  CONSTRAINT pk_asig PRIMARY KEY (codAsig)
  );
  /*modificar una tabla y eliminar o añadir columna!!!!*/
  alter table asignaturas drop b; /*eliminas una columna*/
  alter table asignaturas add b char(1) not null;
  
  /*Creo la tabla alumnos con sus atributos y su clave primaria*/
  CREATE TABLE alumnos(
  dni varchar(9) NOT NULL,
  nombre VARCHAR(20) NOT NULL,
  prApellido VARCHAR(30) NOT NULL,
  sgApellido VARCHAR(30) null,
  bilingue VARCHAR(1) NOT NULL,
  CONSTRAINT pk_alum PRIMARY KEY (dni)
  );
  /*TIPOS DE DATOS relacionados con las fechas:
	date es una fecha 2023-11-09
    datetime es fecha y hora 2023-11-09 12:00:00
    year es un año 2023
    */
    /*varchar, char, decimal, int, enum, boolean, date, datetime, year*/
    
  /*Creo la tabla matricula con sus atributos y su clave primaria*/
  CREATE TABLE matricula(
  dni varchar(9) NOT NULL,
  codAsig INT NOT NULL,
  curso year not null, 
  nota decimal(3,1) not null, /*int o decimal*/
  CONSTRAINT pk_matri PRIMARY KEY (dni, codAsig, curso) /*es muy importante!!!!*/
  );
  
  /*Creo la tabla imparte con sus atributos y su clave primaria*/
  CREATE TABLE imparte(
  dni varchar(9) NOT NULL,
  codAsig INT NOT NULL,
  curso INT NOT NULL,
  CONSTRAINT pk_imparte PRIMARY KEY (dni, codAsig, curso)
  );

/*Creo la tabla alumbil con sus atributos y su clave primaria*/
CREATE TABLE alumbil(
  dni INT NOT NULL,
  fecha DATE NOT NULL,
  lugar VARCHAR(20) NOT NULL,
  CONSTRAINT pk_alumbil PRIMARY KEY (dni)
  );
  
/*2-Metemos los datos que nos indican en las tablas*/
INSERT INTO profesores (`dni`,`nombre`,`prApellido`,`sgApellido`,`telefono`,`sueldo`,`codDep`) VALUES (28900194,'David','Negro','Catalán',677777333,1700,1);
INSERT INTO profesores (`dni`,`nombre`,`prApellido`,`sgApellido`,`telefono`,`sueldo`,`codDep`) VALUES (29600501,'Dolores','Ramos','Cabrera',633345555,1250,1);
INSERT INTO profesores (`dni`,`nombre`,`prApellido`,`sgApellido`,`telefono`,`sueldo`,`codDep`) VALUES (44102321,'Antonio','Martínez','González',621112233,1300,1);
INSERT INTO profesores (`dni`,`nombre`,`prApellido`,`sgApellido`,`telefono`,`sueldo`,`codDep`) VALUES (48103100,'Miguel ','Martínez','Marín',632223344,1500,1);
INSERT INTO profesores (`dni`,`nombre`,`prApellido`,`sgApellido`,`telefono`,`sueldo`,`codDep`) VALUES (48300100,'Ian','Oxley',NULL,634551122,1400,2);
INSERT INTO profesores (`dni`,`nombre`,`prApellido`,`sgApellido`,`telefono`,`sueldo`,`codDep`) VALUES (84501495,'Iván ','Sánchez','Muñoz',633444444,1800,1);
INSERT INTO profesores (`dni`,`nombre`,`prApellido`,`sgApellido`,`telefono`,`sueldo`,`codDep`) VALUES (90100200,'Alejandro','Marín','Cantos',655009900,1900,1);

INSERT INTO imparte (`dni`,`codAsig`,`curso`) VALUES (29600501,1,2021);
INSERT INTO imparte (`dni`,`codAsig`,`curso`) VALUES (44102321,1,2021);
INSERT INTO imparte (`dni`,`codAsig`,`curso`) VALUES (84501495,1,2023);
INSERT INTO imparte (`dni`,`codAsig`,`curso`) VALUES (44102321,2,2022);
INSERT INTO imparte (`dni`,`codAsig`,`curso`) VALUES (90100200,3,2022);
INSERT INTO imparte (`dni`,`codAsig`,`curso`) VALUES (44102321,4,2022);
INSERT INTO imparte (`dni`,`codAsig`,`curso`) VALUES (48300100,5,2022);
INSERT INTO imparte (`dni`,`codAsig`,`curso`) VALUES (48103100,6,2021);

INSERT INTO departamentos (`codDep`, `nombre`, `dniProfJefe`) VALUES ('1', 'Informática y Comunicaciones', '48103100');
INSERT INTO departamentos (`codDep`, `nombre`, `dniProfJefe`) VALUES ('2', 'Administración y Finanzas', '48300100');

INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (13409827,1,2022,8);
INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (35143098,1,2021,3);
INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (35143098,4,2022,5);
INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (39099100,1,2022,4);
INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (51437206,1,2021,3);
INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (51437206,1,2022,9);
INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (51437206,6,2021,6);
INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (94392805,1,2022,4);
INSERT INTO matricula (`dni`,`codAsig`,`curso`,`nota`) VALUES (94392805,1,2023,8);

INSERT INTO asignaturas (`codAsig`,`nombre`,`nh`,`b`,`codCi`) VALUES (1,'Bases de datos',165,'S',1);
INSERT INTO asignaturas (`codAsig`,`nombre`,`nh`,`b`,`codCi`) VALUES (2,'Lenguaje de marcas',120,'N',1);
INSERT INTO asignaturas (`codAsig`,`nombre`,`nh`,`b`,`codCi`) VALUES (3,'Seguridad informática',90,'S',1);
INSERT INTO asignaturas (`codAsig`,`nombre`,`nh`,`b`,`codCi`) VALUES (4,'Despliegue de aplicaciones web',110,'N',1);
INSERT INTO asignaturas (`codAsig`,`nombre`,`nh`,`b`,`codCi`) VALUES (5,'Fundamentos de hardware',90,'N',2);
INSERT INTO asignaturas (`codAsig`,`nombre`,`nh`,`b`,`codCi`) VALUES (6,'Acceso a datos',189,'N',1);

INSERT INTO alumnos (`dni`,`nombre`,`prApellido`,`sgApellido`,`bilingue`) VALUES (13409827,'Ángel','Luque','Nieto','S');
INSERT INTO alumnos (`dni`,`nombre`,`prApellido`,`sgApellido`,`bilingue`) VALUES (35143098,'Dolores','García ','Ramos','N');
INSERT INTO alumnos (`dni`,`nombre`,`prApellido`,`sgApellido`,`bilingue`) VALUES (39099100,'Josefa','Muñoz','Marín','S');
INSERT INTO alumnos (`dni`,`nombre`,`prApellido`,`sgApellido`,`bilingue`) VALUES (51437206,'David','Chaparro','Gomez','N');
INSERT INTO alumnos (`dni`,`nombre`,`prApellido`,`sgApellido`,`bilingue`) VALUES (94342001,'Rosa','Blanco','Montero','S');
INSERT INTO alumnos (`dni`,`nombre`,`prApellido`,`sgApellido`,`bilingue`) VALUES (94392805,'Pilar','Cea','Ruiz','N');
INSERT INTO alumnos (`dni`,`nombre`,`prApellido`,`sgApellido`,`bilingue`) VALUES (98105401,'Pedro','Marín','Espinosa','N');

INSERT INTO ciclos (`codCi`,`nombre`,`siglas`) VALUES (0,'Desarrollo de aplicaciones web','DAW');
INSERT INTO ciclos (`codCi`,`nombre`,`siglas`) VALUES (0,'Administración sistemas informáticos en red','ASIR');
INSERT INTO ciclos (`codCi`,`nombre`,`siglas`) VALUES (0,'Desarrollo de aplicaciones multiplataforma','DAM');

INSERT INTO alumbil (`dni`,`fecha`,`lugar`) VALUES (39099100,'2019-06-10','Barcelona');
INSERT INTO alumbil (`dni`,`fecha`,`lugar`) VALUES (51437206,'2017-09-01','Madrid');
INSERT INTO alumbil (`dni`,`fecha`,`lugar`) VALUES (94342001,'2018-09-10','Sevilla');

-- Mostrar el nombre y los apellidos de los alumnos que son bilingües.
select nombre, prapellido, sgapellido from alumnos where bilingue="s";

-- Mostrar el nombre de los alumnos bilingües que obtuvieron su certificado en Barcelona.
select nombre from alumnos where dni=(select dni from alumbil where lugar="barcelona");

-- Mostrar el nombre y apellido de los profesores que imparten o han impartido la asignatura con código 1.
select nombre, prapellido from profesores where dni in (select dni from imparte where codasig="1");

-- Mostrar el nombre de las asignaturas de más de 100 horas que no son bilingües y que pertenecen al ciclo con código 1.
select nombre from asignaturas where nh>100 and b="n" and codCi="1";

-- Mostrar el nombre y los apellidos de los alumnos que son bilingües y su nombre empieza por A.
select nombre prapellido from alumnos where bilingue="s" and nombre like"a%";

-- Mostrar el dni de los alumnos bilingües que obtuvieron su certificado en ciudades que terminan por a o por d.
select dni from alumnos where bilingue="s" and dni in (select dni from alumbil where lugar like"%a" or lugar like"%d");

-- Mostrar el dni de los profesores cuyo nombre contiene una I, su primer apellido contiene la letra g y termina en n.
select dni from profesores where nombre like "%i%" and prapellido like "%g%" and prapellido like "%n";

-- Mostrar el nombre de las asignaturas de menos de 150 horas que pertenecen al ciclo con código 2 y cuyo nombre no contiene una j.
select nombre from asignaturas where nh<150 and codCi=2 and nombre not like "%j%";

-- Mostrar el dni de aquellos profesores que no tengan segundo apellido.
select dni from profesores where sgapellido is null;

-- Mostrar el dni de los profesores que se llamen Antonio, Dolores o Pepe y que no cobren 1600, 1250 o 1300 euros.
select dni from profesores where nombre like"antonio" or nombre like"dolores" or nombre like"pepe" and sueldo !=1600 and sueldo !=1250 and sueldo !=1300;

-- Mostrar las asignaturas impartidas por los profesores del departamento de Informática y Comunicaciones ordenados de mayor a menor número de horas.
select asignaturas.* from asignaturas join imparte using(codasig) join profesores using(dni) join departamentos using(coddep) where departamentos.nombre = "Informática y Comunicaciones" order by nh;

-- Mostrar el nombre y apellidos de los alumnos que tienen una calificación mayor o igual que 9, ordenados por el primer apellido.
select nombre, prapellido, sgapellido from alumnos where dni in (select dni from matricula where nota >= 9 order by prApellido);

-- Mostrar el nombre y apellidos de los profesores que imparten clases de las asignaturas Bases de datos.
select profesores.nombre, profesores.prapellido, profesores.sgapellido from profesores join imparte using(dni) join asignaturas using(codasig) where asignaturas.nombre="Bases de datos";
        
-- Mostrar el nombre de ciclo que tiene la asignatura de máxima duración.
select  ciclos.nombre from ciclos where codci = (select codci from asignaturas where nh = (select max(nh) from asignaturas));
            
-- Mostrar el nombre y apellidos de los alumnos bilingües que están matriculados en asignaturas bilingües de más de 150 horas y que son del ciclo con siglas DAM o DAW.
select alumnos.nombre, alumnos.prapellido, alumnos.sgapellido from  alumnos join matricula using(dni) join asignaturas using(codasig) join ciclos using(codci) 
where asignaturas.b = "s" and asignaturas.nh>150 and ciclos.siglas in("dam","daw");

-- Mostrar el nombre de las asignaturas que son bilingües y pertenecen al ciclo con siglas DAW o DAM y que son impartidas por profesores del departamento que empieza por I.
select asignaturas.nombre from departamentos join profesores using(coddep) join imparte using(dni) join asignaturas using(codasig) join ciclos using(codci) 
where asignaturas.b= "s" and ciclos.siglas in("dam","daw") and departamento.nombre like("i%");
                    
-- Muestra el nombre y los apellidos de los alumnos que tienen más nota en Bases de Datos que el que tiene menos nota en Acceso a Datos.
select alumnos.nombre, alumnos.prapellido from alumnos join matricula using(dni) join asignaturas using(codasig) where matricula.nota > 
-- Mostrar el dni de los profesores que pertenecen al departamento de Informática y Comunicaciones.


-- Mostrar el nombre y el primer apellido de los alumnos bilingües que han obtenido el certificado en Barcelona o en Madrid.

-- Nombre, apellidos y nombre de asignatura de los alumnos que se encuentren matriculados en Base de Datos y Acceso a Datos.
-- El nombre y apellidos solo se puede conseguir con subconsultas el nombre de la asignatura ya no necesitamos join


-- Mostrar el nombre, apellido, nombre de asignatura de los alumnos que han aprobado asignaturas del ciclo con siglas DAW.
-- Mostrar las distintas asignaturas de más de 100 horas que pertenecen al ciclo con siglas DAM, que ha sido impartido por algún profesor del departamento de Informática y que ha sido cursado por los alumnos en el curso 2022.

-- Mostrar el número de profesores que trabajan para el departamento de Informática.

-- Mostrar para cada asignatura y curso el número de alumnos matriculados.

-- Mostrar la nota media de cada alumno.

-- Mostrar la media de cada alumno por cada curso.

-- Mostrar para los alumnos bilingües su nota más alta.

-- Mostrar la nota más alta en cada curso de aquellas asignaturas del ciclo con siglas DAM.

-- Mostrar la media de aquellos alumnos que cursan asignaturas cuyo profesor que lo imparte pertenece al departamento de Administración y Finanzas.

