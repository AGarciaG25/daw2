create database eval2;
create table cliente(
idcliente int auto_increment,
nombre varchar(20),
apellidos varchar(50),
constraint pk_cliente primary key(idcliente)
);
create table factura(
codF int auto_increment,
fecha date,
importe decimal(10,2),
idcliente int,
constraint pk_factura primary key(codf)
);
drop table factura;

INSERT INTO `eval2`.`cliente`  VALUES ('1', 'Pepe', 'López López');
INSERT INTO `eval2`.`cliente` VALUES ('2', 'Marta', 'Pérez Marín');
INSERT INTO `eval2`.`factura` VALUES ('1', '2025-01-01', '200', '1');
INSERT INTO `eval2`.`factura` VALUES ('2', '2025-01-02', '300', '1');
INSERT INTO `eval2`.`factura` VALUES ('3', '2025-01-01', '100', '2');
INSERT INTO `eval2`.`factura`  VALUES ('4', '2025-01-03', '400', '2');

alter table factura add constraint fk_f_cliente foreign key(idcliente) references cliente(idcliente);

-- join. asociación de tablas con relación 1:N
select * from cliente, factura; -- producto cartesiano, conbina las 2 tablas
select * from cliente, factura where cliente.idcliente=factura.idcliente;
select * from cliente c, factura f where c.idcliente=f.idcliente;

/*
join: varios tipos: inner join, left join, rigth join.
relaciona dos o más tablas
se usa en la clausula from
para crear un join se usa o using/on
using: solo se puede usar cuando la columna de la fk se llame = a la columna de la pk
on: se puede usar siempre, sintaxis: on(condición)
*/
-- de forma manual
select * from cliente c, factura f where c.idcliente=f.idcliente;
-- con join
select * from cliente join factura using(idcliente);
select * from cliente join factura on(cliente.idcliente=factura.idcliente);

-- Obtén el nombre del cliente y la fecha de compra de aquellas compras realizadas durante el año 2025
select nombre, fecha from cliente join factura using(idcliente) where year(fecha)= "2025";
-- Obten las fechas y su importe en las que ha realizado compras la clienta Marta
select fecha, importe from cliente join factura using(idcliente) where cliente.nobre="marta";
select fecha, importe from factura where idcliente=(select idcliente from cliente where nombre="marta");
-- Obtén el importe total de las facturas del cliente Pepe.
select sum(importe) from cliente join factura using(idcliente) where cliente.nombre="pepe";
select sum(importe) from factura where idcliente=(select idcliente from cliente where nombre="pepe");
-- Obtén el número de compras que ha hecho el cliente con apellido López
select count(codf) from cliente join factura using(idcliente) where cliente.apellidos like "%lópez%";
select count(codf) from factura where idcliente=(select idcliente where apellidos like "%lópez%");