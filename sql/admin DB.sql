/*Tema 7: tareas de administracion de base de datos
creacion de usuarios:
select user()/current_user();

create user 'nombre_usuario'@'localhost' identified by 'contraseña';
create user 'nombre_usuario'@127.0.0.1 identified by '1234';
*/
create user 'prueba'@'localhost' identified by '1234';
-- eliminar usuario
drop user 'prueba'@'localhost';
-- renombrar usuario
RENAME USER 'usuario_antiguo'@'localhost' TO 'usuario_nuevo'@'localhost';
-- cambiar contraseña de usuario
ALTER USER 'usuario'@'localhost' IDENTIFIED BY 'nueva_contraseña';
-- listar usuarios
select * from mysql.user;

/*5 niveles de privilegios
Nivel gobal o general: cuando el privilegio es sobre todo el conjunto de bases de datos y de tablas *.*(todas las bases de datos y todas las tablas)
Nivel de base de datos: cuando el privilegio es sobre una base de datos en concreto base_datos.*
Nivel de tabla: cuando el privilegio es sobre una base de datos concreta y una tabla concreta base_datos.tabla
Nivel de columna: cuando el privilegio es sobre una base de datos concreta , una tabla concreta y una columna concreta 
Nivel de procedimiento/funcion(rutinas) cuando el privilegio es sobre una rutina en concreto
*/


-- dar todos los privilegios a un usuario (all privileges)
create user 'prueba'@'localhost' identified by '1234';
grant all privileges on *.* to 'prueba'@'localhost'; -- otorgar privilegios a un usuario
-- permite dar un privilegio y a su vez que otorgue este mismo privilegio a otro usuario
grant create view on *.* to 'prueba'@'localhost' with grant option;
show grants for 'prueba'@'localhost'; -- comprobar permisos de un usuario
-- eliminar privilegios a un usuario
revoke drop on *.* from 'prueba'@'localhost';
revoke select, alter on empresa.* from 'prueba'@'localhost';
revoke update(nombre, apelidos) on empresa.empleados from 'prueba'@'localhost';
-- tabla en la que se ven los permisos a nivel bd
select * from mysql.bd;
select * from mysql.colums_priv;
-- listado de privilegios
show privileges;
-- eliminar todos los privilegios
revoke all privileges on *.* from 'prueba'@'localhost';

-- eventos: tarea programada porque hay un dia/hora para que se ejecute; está formado por instrucciones sql qie resuelven una tarea.
-- usos: actualizar datos, enviar reportes, realizar copias de seguridad...
/*sintaxis
drop event if exists nom_eventeo
delimiter $$
create event nom_evento
on schedule horario
on schedule at '2025-05-21 10:27:00'
every 
[on completion [not]preserve]
do
begin
-- instruc
end$$
delimiter;*/ 
/*
AT 'fecha-hora'	Ejecuta el evento una sola vez en esa fecha y hora.
EVERY intervalo	Ejecuta el evento repetidamente cada cierto intervalo. (intervalo: day, minute, hour, year...)
EVERY intervalo STARTS 'fecha'	Empieza a ejecutar el evento en esa fecha, y luego lo repite cada intervalo.
EVERY intervalo ENDS 'fecha'	Ejecuta el evento repetidamente hasta una fecha específica.
EVERY intervalo STARTS 'f' ENDS 'f'	Define un rango de tiempo para la ejecución repetida.*/

select @@event_scheduler;
set global enent_scheduler='on';

create database eventos;
use eventos;
create table comentarios(
	id int primary key,
    texto text not null,
    usuario varchar(100) not null,
    fecha datetime not null
);
create table comentariosOld like comentarios;
-- interval: cantidad unidad de tiempo
-- Crea un evento que se ejecute cada día a las 11 de la noche, y su función sea borrar los comentarios de más de 30 días de antigüedad 
-- y guardarlos en otra tabla que se llame comentarios antiguos

drop event if exists nom_eventeo
delimiter $$
create event nom_evento
on schedule every 1 day	 starts '2025-05-21 23:00:00'
do
begin
     insert into comentariosOld select * from comentarios where fecha < now()- interval 30 day;
     delete from comentarios where fecha < now()- interval 30 day;
end$$
delimiter ;

-- Privilegios
create user 'juan'@'localhost' identified by '1234';
rename user 'juan'@'localhost' to 'paco'@'localhost';
alter user 'paco'@'localhost' identified by '1234';
drop user 'paco'@'localhost';

create user 'tengoPermisos'@'localhost' identified by '1234';
grant create user on *.* to 'tengoPermisos'@'localhost';
grant update(articulo, cantidad) on privilegios.stock to 'tengoPermisos'@'localhost';
grant alter, references on privilegios.* to 'tengoPermisos'@'localhost';
grant create routine, alter routine, execute on privilegios.* to 'tengoPermisos'@'localhost';

revoke create routine, alter routine, execute on privilegios.* from 'tengoPermisos'@'localhost';
revoke all privileges on *.* from 'tengoPermisos'@'localhost';

select * from mysql.procs_priv;

drop event if exists acutalizarPelis;
delimiter $$
create event acutalizarPelis
on schedule every 5 hour starts '2025-05-28 12:20:00' ends '2025-06-01 12:20:00'
do
begin
declare final int default 0;
declare vidp int;
declare vfe date;
declare c1 cursor for select idp, festreno from peliculas;
declare continue handler for not found set final=1;
open c1;
    bucle:loop
        fetch c1 into vidp, vfe;
        if(final=1)then
             leave bucle;
        end if;
        if(vfe > current_date()) then
              update peliculas set estado = "Proximanente" where idp=vidp;
		elseif(vfe=current_date() and vef>=current_date()-interval 2 month) then
	          update peliculas set estado = "Proximanente" where idp=vidp;
		    else
	            update peliculas set estado = "Proximanente" where idp=vidp;
        end if;
    end loop;
close c1;
end$$
delimiter ;