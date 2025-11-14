/*cursores
Mecanismo de la programacion de base de datos, que va a tener asociada una consulta select.
el cusrsor apunta a las filas que devuelve la consulta y recorre una a una.
La consulta select asociada puede ser de la dificultad que queramos(join, group by...)
El cursor se crea dentro de un procedimiento o una funcion (mejor en procedimiento) porque las funciones no permiten modificar datos de tablas.
Podemos declarar tantos cursores como necesitemos dentro del procedimiento.
Utilidad: cuando queremos recorrer los datos fila a fila de una consulta y hacer alguna operacion sobre ellos.
Sintaxis:
declare nombre_cursor cursor for(consulta select asociada)
declare c1 cursor for select idE, nombre from empleados;

Orden de declaracion dentro del procedimiento:
1. declarar variables.
2. declarar cursor
3. manejador de errores y excepcones.

Manejador de errores/excepciones: 
el cursor recorre filas de la consulra asociada, pero llega un momento qe ya no hay mas filas que recorrer.
Por tanto en ese momento hay un error, el manejador de errores lo captura.
Nosotros le diremos que tiene que hacer, alguna instruccion, dejar el bucle etc...

sintaxis manejador de errores:
declare continue/exit handler for codigoerror/nombreerror/... accionesaseguir;
declare continue handler for not found set final = 1;

bucle loop: el bucle mueve el cursor para que apunte a las distintas filas de la consulta
sintaxis:
nomBucle: loop
  fetch
    if(final = 1) then
         leave bucle;
	end if;
end loop;

operaciones con los cursores:

open: abre el cursor, lo inicia.
   sintaxis: open c1;
   
fetch: situa al cursor apuntando a la primera fila de datos de la consultaselect asociada.
va dentor del loop.
   sintaxis: fetch nombre_cursor into variable1, variable2,... hay que declarar tantas variable coo consultas del select
             fetch c1 into vidE, vnombre; importante el orden
close: cierra el cursor y libera memoria. No es obligatoro pero se debe hacer. Se debe usar cuando ya hayamos usado los datos.
*/

/*Crea un procedimiento que use un cursor sobre la tabla empleados y saque por pantalla (select) para cada empleado un saludo
Hola María López.... */


drop procedure if exists `saludos`;
DELIMITER $$
create procedure `saludos`()
begin
declare final int default 0;
declare vnom varchar (50);
declare c1 cursor for select nombre from empleados;
declare continue handler for not found set final=1;
open c1;
bucle:loop
   fetch c1 into vnom;
   if(final=1) then
      leave bucle;
   end if;
      select concat("hola ", vnom);
end loop;
close c1;
end$$
DELIMITER ;

call saludos();


drop procedure if exists `saludosEncadenado`;
DELIMITER $$
create procedure `saludosEncadenado`()
begin
declare final int default 0;
declare vnom varchar (50);
declare nomConca varchar(500) default " ";
declare c1 cursor for select nombre from empleados;
declare continue handler for not found set final=1;
open c1;
bucle:loop
   fetch c1 into vnom;
   if(final=1) then
      leave bucle;
    end if;
      set nomConca:= concat(nomConca,vnom,", ");
end loop;
close c1;
select substr(concat("hola",nomconca),1,length(concat("hola",nomconca)-1));
end$$
DELIMITER ;

call saludosEncadenado();

/*Crea una función al que se le pase el nombre de un empleado. Debe comprobar que el
empleado existe,
si existe la función devolverá el total de ventas de ese empleado. Usa un cursor y sin usar
un cursor*/

set global log_bin_trust_function_creators=1;
DROP function IF EXISTS `ventastotales`;
DELIMITER $$
CREATE FUNCTION `ventastotales` (nom varchar (100))
returns decimal(10,2)
BEGIN
DECLARE idvendedor int;
DECLARE total decimal(10,2);
if (nom not in (select nombre from vendedores)) then
signal sqlstate '45000' set message_text="El empleado no existe";
else
set idvendedor:= (Select id from vendedores where nombre=nom limit 1); -- para
coger el primero con un nombre
set total:= (select sum(importe) from ventas where vendedor_id=idvendedor);
end if;
return total;
END$$
DELIMITER ;
Select ventastotales ("Iria");

-- CON CURSOR

DROP function IF EXISTS `ventastotales`;
DELIMITER $$
CREATE FUNCTION `ventastotales` (nom varchar (100))
returns decimal(10,2)
BEGIN
-- declarar las variables locales
declare final int default 0;
declare vvendedor_id, idvendedor int;
declare vimporte decimal(10,2);
declare total decimal(10,2) default 0;
-- declarar el cursor

declare c1 cursor for select vendedor_id, importe from ventas;
-- declarar el manejador de errores
declare continue handler for not found set final=1;
-- instrucciones
if (nom not in (select nombre from vendedores)) then
signal sqlstate '45000' set message_text="El empleado no existe";
else
select id into idvendedor from vendedores where nombre=nom;
OPEN c1;
bucle:loop
FETCH c1 into vvendedor_id, vimporte;
if (final = 1) then

leave bucle;
end if;
if (id_vendedor=vvendedor_id) then
set total = total + vimporte;

end if;
end loop;
end if;
return total;
CLOSE c1;
END$$
DELIMITER ;

