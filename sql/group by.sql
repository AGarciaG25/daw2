create database empresa;
use empresa;
create table empleado(
codem int primary key,
nombre varchar(100),
departamento enum("ventas","formacion","marketing"),
salario decimal(10,2)
);

create table proyectos(
codp int primary key,
nombre varchar(500),
codem int);
alter table proyectos add constraint fkproy_emp foreign key (codem) references empleado(codem);
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('1', 'Pepe', 'Ventas', '1500');
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('2', 'María', 'Ventas', '1600');
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('3', 'Lucía', 'Formación', '1200');
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('4', 'Mar', 'Formación', '1400');
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('5', 'Juan', 'Marketing', '1190');
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('6', 'Anselmo', 'Formación', '1900');
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('7', 'Mar', 'Formación', '1650');
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('8', 'Anselmo', 'Formación', '1550');
INSERT INTO `empresa`.`empleado` (`codEm`, `nombre`, `departamento`, `salario`) VALUES ('9', 'Anselmo', 'Formación', '1700');
/*Group by
agrupar columnas con valores que se repiten (podemos agrupar una columna o más de una) 
la finalidad es aplicar alguna funcion numerica de grupo: avg, min, mas, sum, count
se coloca en una consulta select, si hay where, despues y antes del order by
Sintaxis:
		select col1,col2, funcion de grupo(col) from tabla where (condicion) group by col1, col2 order by;
        La columna o columnas por las que agrupe en el group by deben estar normalmente proyectadas en el select
*/

select departamento, count(codem) from empreado group by departamento;

-- muestra la media de salario, el salario masx y min de cada departamento
select departamento, avg(salario), max(salario), min(salario) from empreado where departamento like "______%" group by departamento order by departamento desc;

-- Se puede agrupar por más de una columna
-- sintaxis: group by departamento, nombre
-- Para cada departamento muestra cuantos empleados hay con cada nombre de empleado
select departamento, nombre, count(codem) from empleado where departamento like "%e%" group by departamento, nombre;

-- Para cada empleado obtén el num de proyectos asignados
select empleado.nombre, count(codp)from proyectos join empleado using(codem) group by empleado.nombre;
-- numero de empleados por salario especifico en cada departamento
select departamento,salario, count(codem) from empleado group by salario, departamento;

-- numero de proyectos por departamento
select departamento, count(codp) from proyectos join empleado using(codem) group by departamento;

-- clausula having;
-- es similar al where, es un filtro de alguna condición
-- where:filtro en tabla original antes de hacer el group by
-- filtro pero de la tabla agrupada con group by

-- orden: despues del group by, si no hay group by no se puede poner having, y antes del order by
-- sintaxis: havinf condicion(esa condicion se rediere normalmente a la funcion numerica del grupo)

-- Para cada departamento que tenga más de dos empleados, muestra el nombre del departamento y num de empleados
select departamento, count(codem) from empleado group by departamento having count(codem)>2;

-- Muestra el nombre de departamento y la media de salario para aquellos departamentos con salario medio mayor a 1300
select departamento, avg(salario) from empleado group by departamento having avg(salario)>1300;
-- Salarios totales por departamento mayores a 3000 euros
select departamento, sum(salario) from empleado group by departamento having sum(salario)>3000;
-- Departamentos con al menos dos proyectos asignados
select departamento, count(codem) from empleado join proyectos using(codem) group by departamento having  count(codp)>=2;



/*funciones: diferencias con un procedimiento
solo tiene paramentros de entrada o no tiene parametros. no tiene out , ni inout
como solo tiene parametro de enstrada no hace falta escribir el in(da error)
siempre devuelve algun valor. lo devuelve dentro del begin/end con la palabra reservada return
valores que puede devolverse en el return: varchar, char, entero, decimal, boolean...
no puede devolver un select (el resultado de una consulta), un conjunto de valores
hay que indicar siempre el tipo de dato que se devuelve en una funcion con la palabra reservada returns
diferencia: 
return: es el valor devuelto (1,2, hola, true...)
returns es el tipo de valor devuelto(int, varchar,boolean...)
la suncion se llama dentro de un select o de un where con su nombre y parametros
ejem: select suma(2,4);
dentro de una funcion no podemos modificar, añadir, borrar datos sql(insert, update, delete)
*/

USE `procedimientos`;
DROP function IF EXISTS `new_function`;

DELIMITER $$
USE `procedimientos`$$
CREATE FUNCTION `new_function` ()
RETURNS INTEGER
BEGIN

RETURN "hola";
END$$

DELIMITER ;