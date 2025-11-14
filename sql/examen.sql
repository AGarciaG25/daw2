create database recuperacion;
use recuperacion;
create table festivales(
    idF int not null primary key,
    nombre varchar(25) not null,
    lugar varchar(15) not null,
    acampada boolean not null
);
create table cantantes(
    idC int not null primary key,
    nombre varchar(25) not null,
    nacionalidad varchar(15) not null,
    edad int not null
);

create table participar(
    idC int not null,
    idF int not null,
    fecha date not null,
    salario decimal(10,2) null,
    constraint pk_participar primary key(idC, idF, fecha)
);

INSERT INTO `recuperacion`.`festivales` (`idF`, `nombre`, `lugar`, `acampada`) VALUES ('1', 'BBK Live', 'Bilbao', '1');
INSERT INTO `recuperacion`.`festivales` (`idF`, `nombre`, `lugar`, `acampada`) VALUES ('2', 'Portamérica', 'Pontevedra', '1');


INSERT INTO `recuperacion`.`cantantes` VALUES ('1', 'Rosalía', 'España', '30');
INSERT INTO `recuperacion`.`cantantes`  VALUES ('2', 'Sebastián Yatra', 'Colombia', '29');
INSERT INTO `recuperacion`.`cantantes`  VALUES ('3', 'Mclan', 'España', '50');
INSERT INTO `recuperacion`.`cantantes` VALUES ('4', 'Love of Lesbian', 'España', '40');


INSERT INTO `recuperacion`.`participar` (`idC`, `idF`, `fecha`, `salario`) VALUES ('1', '1', '2023-07-06', '30000');
INSERT INTO `recuperacion`.`participar` (`idC`, `idF`, `fecha`, `salario`) VALUES ('2', '2', '2023-07-14', '25000');
INSERT INTO `recuperacion`.`participar` (`idC`, `idF`, `fecha`, `salario`) VALUES ('3', '2', '2023-07-14', '15000');
INSERT INTO `recuperacion`.`participar` (`idC`, `idF`, `fecha`, `salario`) VALUES ('4', '1', '2023-07-06', '40000');
ALTER TABLE participar  ADD CONSTRAINT fk_participar_cantantes  FOREIGN KEY (idC) REFERENCES cantantes(idC);
ALTER TABLE participar  ADD CONSTRAINT fk_participar_festivales  FOREIGN KEY (idF) REFERENCES festivales(idF);

/*Obten el nombre del festival y el núm de cantantes que actúan en él para aquellos festivales en los que actúen al menos dos cantantes*/
select nombre, count(*) from festivales join participar using(idf) group by(nombre) having count(idc)>=2;  
-- para cada nacionalidad distinta de los cantantes, 
-- obten el total de salario que ganan al participar en los distintos festivales y el numero total de cantantes para cada nacionalidad
select  nacionalidad, sum(salario), count(idc) from cantantes join participar using(idc) group by(nacionalidad);

-- Crea una tabla temporal llamada t1 que guarde para cada nombre de temática, la cantidad total de libros
-- disponibles (stock) calculando la suma total de existencias.
create temporary table t1 as (select nombre, sum(stock) from libros join tematicas using(codtem) group by(nombre));

/*Crea una tabla temporal llamada t2 que muestre para cada autor el total de stock que tienen, sumando todos los
libros de cada autor. Incluye el nombre del autor y la cantidad total de ejemplares de aquellos que tienen más de
150 ejemplares*/
create temporary table t2 as (select autor, sum(stock) from libros group by(autor) having sum(stock)>150);
select * from t2;
-- Crea una vista llamada v1 que deberá mostrar los libros cuyo precio de compra sea mayor al promedio de precios
-- de todos los libros, incluye en la consulta el título, el autor y el precio de compra
create view v1 as (select titulo, autor, preciocompra from libros where preciocompra>(select avg(preciocompra) from libros));