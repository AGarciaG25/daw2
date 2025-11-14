/*Triggers o disparadores:
bloques de código con instrucciones sql, se parecen a los procedimientos, la diferencia es que no hay que llamarlos, se disparan solos.
Se dispara automaticamente cuando sucede algo en una tabla: insert, update, delete
Se guarda dentro de la tabla asociada al trigger.

Sintaxis:
drop trigger if exists nombre_tigue;
delimiter $$
create trigger nombre_triguer [momento][evento] on nombre_tabla for each row
begin

end$$
delimiter;

nombre_trigger: BI_verificardatos
momento: cuando quereis que se lance el trigger, ante(before) o despues(alter). de cualquiera de las operaciones(insert, update, delete)
evento: es la operacion que provoca que se lance el trigger (insert, update, delete)
on nombre_tabla: nombre de la tabla en la que sucede la operacion del trigger.
for each row: se va a comprobar cada una de las filas de la tabla
puede haber triggers para cada momento y evento, no puede haber 2 triggers iguales para el mismo momento y evento

usos:
   combrobaciones antes de insertar, modificar o borrar (algunas cosas se prodrian hacer con check)
   auditoria de tablas: guardar informacion de que persona o fecha ha insertado datos, o borrando o modificando
   actualizacion de datos/operaciones: cuenta bancaria tras extraccion, ingreso
   
palabras new, old: sirven para acceder a los datos de las operaciones que lanza al trigger.

insert no podemos usar old, se usa new
insert into vendedores values(4,"luis");
sintaxis: 
new.id
 new.
 
 
 delete from productos where id=1;
 delete no podemos usar la palabra new, solo se usa old
 old.nmbrecolumna
 
 update vendedores set nombre = "pepe" where id=1;
 old.nombre accederia al valor del nombre del vendedor antes de modificar Carlos
  new.nombre accederia al valor del nombre del vendedor despues de modificar pepe
*/

create database tri;
    use tri;
    create table alumnos(
		id int not null primary key,
        nombre varchar(100) not null,
        edad int not null,
        telefono varchar(9) not null
    );
 
 /*Crea un trigger en la inserción que compruebe: 
		que el alumno sea mayor de 18 sino sms por consola "No mayor de edad"
        que no tenga más de 100 años sino sms "Edad no permitida"
        que el teléfono no esté repetido sino sms por consola "Telf repetido"
        que el nombre tenga la primera letra mayúscula*/

drop trigger if exists BI_verificar_alumno;
delimiter $$
create trigger BI_verificar_alumno before insert on alumnos for each row
begin
    if(new.edad<18) then
        signal sqlstate '45000' set message_text="El alumno no es mayor de edad";
	end if;
    if(new.edad>100) then
		signal sqlstate '45000' set message_text="edad no permitida";
	end if;
    if(new.telefono not in( select telefono from alumnos)) then
        signal sqlstate '45000' set message_text="telf repetido";
	end if;
    set new.nombre:= concat(upper(substr(new.nombre,1,1)),lower(substr(new.nombre,2)));
end$$
delimiter ;

-- pruebas
insert into alumnos values(1,"Pepe",10,"656777777");


/*crear un trigger en el borrado, que solo borre datos si el nombre de un alumno empieza por A*/

drop trigger if exists BD_verificar_alumno;
delimiter $$
create trigger BI_verificar_alumno BEFORE delete on alumnos for each row
begin
   IF(substr(old.nombre,1,1)!="a") then
               signal sqlstate '45000' set message_text="borrado no permitido";
	end if;
end$$
delimiter ;

CREATE TABLE Cuentas(
    idCuenta INT PRIMARY KEY,
    titular VARCHAR(100),
    saldo DECIMAL(15,2)
);

CREATE TABLE Movimientos(
    idMovimiento INT PRIMARY KEY AUTO_INCREMENT,
    idCuenta INT,
    tipoMovimiento VARCHAR(10), -- 'D' , 'R', 'C'
    cantidad DECIMAL(15,2), -- máximo 200 euros en la retirada
    fechaMovimiento datetime
);
alter table Movimientos add constraint fk_cuentas_movimientos foreign key(idCuenta) references Cuentas(idCuenta);

-- crear un trigger en la insert, que cada vez que se inserte un nuevo movimiento, actualice el saldod de la cuenta correspondiente:
-- comprobar el tipo de movimiento: d, r, c si no sms consola: movimiento erroneo.
-- que la cantidad sea mayo que cero si no sms consola: cuenta erronea.
-- si el tipo es "D" no hay cantidad maxima y se actualiza el saldo.
-- si el tipo es R comprobamos que no sea mas de 200, si no forzar la catidad a 200, y comprobar que haya saldo suficiente
-- si es C forzamos a cantidad a 0 y no actualiza el saldo.

drop trigger if exists BI_insertar_movimientos;
delimiter $$
create trigger BI_insertar_movimientos BEFORE insert on movimientos for each row
begin
   IF(new.tipoMovimiento not in("D","R","C")) then
	  signal sqlstate '45000' set message_text="movimiento erroneo";
   end if;
   if(new.idcuenta in(select idcuenta from cuenta)) then
       signal sqlstate '45000' set message_text="cuenta erronea";
	end if;
    if(new.cantidad <1) then
       signal sqlstate '45000' set message_text="cantidad erronea";
	end if;
    if(new.tipoMovimiento = "R" and (select saldo from cuenta)> new.cantidad) then
       if(new.cantidad <= 200) then
          update cuent set saldo= saldo-new.cantidad where idcuenta = new.idcuenta;
		elseif(new.cantidad>200) then
             set new.cantidad := 200;
		     update cuent set saldo= saldo-new.cantidad where idcuenta = new.idcuenta;
		end if;
	 end if;
	 if(new.tipoMovimiento = "C") then
        set new.cantidad := 0;
	 end if;
     if(new.tipoMovimiento = "D") then
         update cuent set saldo= saldo+new.cantidad where idcuenta = new.idcuenta; 
	 end if;
        
end$$
delimiter ;