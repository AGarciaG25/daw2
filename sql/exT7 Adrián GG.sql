CREATE DATABASE teatro;
USE teatro;

-- Tabla obras
CREATE TABLE obras (
    idobra INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    festreno DATE NOT NULL,
    entradas int not null
);

-- Tabla clientes
CREATE TABLE clientes (
    idcliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Tabla de Ventas
CREATE TABLE ventas (
    idobra INT NOT NULL,
    idcliente INT NOT NULL,
    fcompra DATETIME NOT NULL,
    cantidad int not null,
    constraint pk_ventas primary key(idobra, idcliente, fcompra)
);


INSERT INTO obras values
(0,'Concierto de Rock', '2024-06-05', 100),
(0,'Obra de Teatro Clásica', '2024-06-01', 50),
(0,'Festival de Jazz', '2024-05-20', 30);

INSERT INTO clientes (nombre, email) VALUES
('Ana López', 'ana.lopez@example.com'),
('Luis Martínez', 'luis.martinez@example.com'),
('Carmen Ruiz', 'carmen.ruiz@example.com');

alter table ventas add constraint fk_clientes_ventas foreign key(idcliente) references clientes(idcliente);
alter table ventas add constraint fk_obras_ventas foreign key(idobra) references obras(idobra);


-- Tabla necesaria para el ejercicio del evento
create table controlObras(
	idobra int not null primary key,
    estado varchar(255) null,
    fcontrol datetime not null
);

alter table controlObras add constraint fk_obras_control foreign key(idobra) references obras(idobra);

-- ejercicio 2

-- a
create user  'examen'@'localhost' identified by '1234';
rename user  'examen'@'localhost' to 'exameneval'@'localhost';
alter user 'exameneval'@'localhost' identified by '12345';

-- b
grant select, create, delete on teatro.* to 'exameneval'@'localhost';
show grants for 'exameneval'@'localhost'; 
select * from  mysql.user;
select * from  mysql.db;
-- c
grant alter (nombre,email) on teatro.clientes to 'exameneval'@'localhost';
select * from mysql.colum_priv;
show privileges;
-- d
grant create routine, alter routine, execute, event, index on teatro.* to 'exameneval'@'localhost';
-- e
grant create user on *.* to 'exameneval'@'localhost' with grant option;
-- f
revoke all privileges on *.* from 'exameneval'@'localhost';

-- 3
drop event if exists evexam;
delimiter $$
create event evexam on schedule every 15 minute starts '2025-06-06 10:48:00' ends '2025-06-16 10:00:00' do
begin
declare final int default 0;
declare id,num int;
declare c1 cursor for select idobra, entradas from obras;
declare continue handler for not found set final = 1;
open c1;
bucle: loop
    fetch c1 into id, num;
    if(final = 1) then
      leave bucle;
    end if;
    if(id not in (select  idobra from controlobras)) then
	    if(num<1) then
           insert into controlobras values(id,"Entradas agotadas",now());
		elseif(num > 30) then
               insert into controlobras values(id,"No hay problema de entradas",now());
			else
               insert into controlobras values(id,"Date prisa, quedan pocas entradas",now());
		end if;
	 end if;
     if((select count(*) from controlobras where idobra = id)>0) then
         if(num<1) then
           update controlobras set estado="Entradas agotadas",fcontrol=now() where idcontrol= id;
		elseif(num > 30) then
               update controlobras set estado="No hay problema de entradas",fcontrol=now() where idcontrol= id;
			else
               update controlobras set estado="Date prisa, quedan pocas entradas",fcontrol=now() where idcontrol= id;
		end if;
	 end if;
end loop;
close c1;
end$$
delimiter ;











