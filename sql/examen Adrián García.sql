/*EXAMEN DE PROCEDIMIENTOS Y FUNCIONES*/
/*DATOS DE BASE DE DATOS, TABLAS, INSERCIONES Y CLAVES FORÁNEAS*/
create database examen25;
use examen25;

/*EJERCICIO 1*/
create table empleados(
	idE int not null primary key,
    nombre varchar(100) not null,
    fnac date not null,
    idP int null,
    fasignacion date null
);
create table proyectos(
	idP int not null primary key,
    nombre varchar(100) not null,
    finicio date not null,
    ffin date not null,
    presupuesto decimal(10,2) not null
);
INSERT INTO proyectos (idP, nombre, finicio, ffin, presupuesto) VALUES
(1, 'Desarrollo Web', '2024-01-10', '2025-06-30', 50000.00),
(2, 'App Móvil', '2024-02-15', '2025-08-20', 75000.00),
(3, 'Sistema de Inventario', '2024-03-05', '2025-09-15', 60000.00),
(4, 'Rediseño de Base de Datos', '2024-04-01', '2025-10-10', 40000.00);

INSERT INTO empleados (idE, nombre, fnac, idP,fasignacion) VALUES
(101, 'Juan Pérez', '1990-03-25', 1,"2024-01-10"),
(102, 'María López', '1985-07-12', 2,'2024-02-15'),
(103, 'Carlos Ramírez', '1993-11-30', 3,'2025-03-05'),
(104, 'Ana Torres', '1995-06-17', 1,"2024-01-10"),
(105, 'Pedro Castillo', '1988-02-22', 4,'2024-10-10'),
(106, 'Sofía Méndez', '1992-09-10', null,null),
(107, 'Carla Ortiz', '1996-01-14',null,null);

alter table empleados add constraint fk_empleados_proyectos foreign key(idP) references proyectos(idP);

/*EJERCICIO 2 Y 3*/
CREATE TABLE juegos (
    idJuego INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    genero VARCHAR(50) NOT NULL
);
CREATE TABLE jugadores (
    idJugador INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nickname VARCHAR(50) UNIQUE NOT NULL,
    nivel enum("Principiante","Intermedio","Avanzado") null
);
CREATE TABLE partidas (
    idPartida INT NOT NULL PRIMARY KEY,
    idJuego INT NOT NULL,
    idJugador INT NOT NULL,
    fechaInicio DATE NOT NULL,
    puntuacion DECIMAL(10,2) NOT NULL
);
CREATE TABLE TORNEOS(
	idTorneo INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(100)
);
CREATE TABLE inscripciones (
	idInscripcion INT NOT NULL auto_increment PRIMARY KEY,
    idJugador INT NOT NULL,
    idTorneo INT NOT NULL,
    fechaInscripcion DATE NOT NULL,
    nivel enum("Principiante", "Intermedio", "Avanzado") null
);

INSERT INTO juegos VALUES
(1, 'Dragon Ball FigtherZ', 'Pelea'),
(2, 'FIFA 24', 'Deportes');

INSERT INTO jugadores VALUES
(1, 'Carlos Pérez', 'ShadowNinja', NULL),
(2, 'María López', 'GamerQueen', NULL);

INSERT INTO torneos  VALUES (1, 'Torneo Smash Ultimate'),(2, 'FIFA Masters');

INSERT INTO partidas VALUES (1,1,1,"2025-03-01",4.00),(2,1,1,"2025-03-02",10.00),
(3,1,1,"2025-03-03",28.00),
(4,1,1,"2025-03-04",30.00),
(5,1,2,"2025-03-01",3.00),
(6,1,2,"2025-03-19",10.00),
(7,2,1,"2025-03-10",20.00),
(8,2,1,"2025-03-11",40.00),
(9,2,1,"2025-03-12",60.00);

alter table partidas add constraint fk_partida_juego foreign key(idJuego) references juegos(idJuego);
alter table partidas add constraint fk_partida_jugador foreign key(idJugador) references jugadores(idJugador);

/*ESTRUCTURA BÁSICA DEL PROCEDIMIENTO Y LA FUNCIÓN
DELIMITER $$
CREATE procedure `` ()
BEGIN
END$$
DELIMITER ;

set global log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE function `` ()
RETURNS 
BEGIN
END$$
DELIMITER ;

*/
drop procedure if exists `asignarProyecto`;
DELIMITER $$
CREATE procedure `asignarProyecto` (in ie int, in ip int)
BEGIN
declare finic date;
if(ie not in (select idE from empleados)) then
    signal sqlstate '45000' set message_text="El empleado no existe";
elseif(ip not in (select idP from proyectos)) then
        signal sqlstate '45000' set message_text="El proyecto no existe";
    elseif((select idP from empleados where idE= ie) is null) then
            update empleados set idP=ip, fasignacion=(select date(now())) where idE=ie;
         else
             set finic:= (select fasignacion from empleados where idE = ie);
             if(select datediff(date(now()),finic)>90) then
				  update empleados set idP=ip, fasignacion=(select date(now()))where idE=ie;
			 else
				  signal sqlstate '45000' set message_text="No se puede reasignar, fecha de asignación menor a 3 meses";
			 end if;
end if;
END$$
DELIMITER ;

call asignarProyecto(1,4);
call asignarProyecto(101,5);
call asignarProyecto(106,2);
call asignarProyecto(106,3);
call asignarProyecto(104,2);

-- -------------------------------------------------------------------
drop procedure if exists `realizarInscripcion`;
DELIMITER $$
CREATE procedure `realizarInscripcion` (in ij int, in it int, out sms varchar(100))
BEGIN
declare inscri, punt int;
declare lvl varchar(20);
if(ij not in (select idjugador from jugadores)) then
    set sms:= (select "El jugador no existe");
elseif(it not in (select idtorneo from torneos)) then
       set sms:= (select "El torneo no existe");
	else
        set inscri:= (select count(*) from inscripciones where idjugador=ij and idtorneo= it); 
    if(inscri > 0) then
        set sms:= (select "jugador ya inscrito en el torneo");
	else
        set punt:=(select sum(puntuacion) from partidas where idjugador=ij);
	    if(punt is null) then
            set punt:=0;
		end if;
        case
            when punt > 100 then
                 set lvl:= "Avanzado";
			when punt between 50 and 100 then
                 set lvl:= "Intermedio";
			else 
                 set lvl:= "Principiante";
		end case;
        insert into inscripciones values (0,ij,it,date(now()),lvl);
	 end if;
end if;
END$$
DELIMITER ;

call realizarInscripcion(3,1,@sms);
call realizarInscripcion(2,4,@sms);
call realizarInscripcion(1,2);
call realizarInscripcion(2,1);

select @sms;
-- ------------------------------------------------------------

drop function if exists `jugadorMaxPuntuacionPartida`;
DELIMITER $$
CREATE function `jugadorMaxPuntuacionPartida` (ij int)
RETURNS varchar(100)
BEGIN
declare sms,n,nn varchar(100);
if(ij not in (select idjugador from jugadores)) then
     set sms:= "El juego indicado no existe";
elseif((select count(*) from partidas where idjuego=ij)=0) then
          set sms:= "No hay partidas para ese juego";
	else
         set n:= (select nombre from jugadores where idjugador=(select idjugador from partidas where idJuego=1 and puntuacion=(select max(puntuacion) from partidas where idJuego=1 limit 1) limit 1));
         set nn:=(select nickname from jugadores where idjugador=(select idjugador from partidas where idJuego=1 and puntuacion=(select max(puntuacion) from partidas where idJuego=1 limit 1) limit 1));
         set sms:=concat();
end if;
 return sms;        
END$$
DELIMITER ;
select nickname from jugadores where idjugador=(select idjugador from partidas where idJuego=1 and puntuacion=(select max(puntuacion) from partidas where idJuego=1 limit 1) limit 1);

select nombre from jugadores where idjugador=(select idjugador from partidas where idJuego=1 and puntuacion=(select max(puntuacion) from partidas where idJuego=1 limit 1) limit 1);

select nombre from jugadores where idjugador=(select idjugador from partidas where idjuego=2 and puntuacion=(select max(puntuacion) from partidas where idjuego=2 limit 1));
 select sum(puntuacion), idjugador from partidas  where idjuego=2 group by idjugador;  
