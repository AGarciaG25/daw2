drop database buscaTesoro;
create database buscaTesoro;
create table pirata(
idPirata int not null auto_increment,
Nombre varchar(20),
Apodo varchar(20),
edad int,
nivelMaldad enum("malísimo","buenísimo") default "malísimo",
barba varchar(10) null,
constraint pk_pirata primary key(idPirata),
constraint uk_apodo unique(apodo),
constraint ck_edad check(edad>16)
);
describe pirata;
-- show table; -- lista de la tabla creada
 create table isla(
 nombre varchar(20),
 coordY int,
 coordX int,
 ubicación varchar(20),
 constraint pk_isla primary key(coordX)
 );
 create table tesoro(
 idTesoro int auto_increment,
 nombre varchar(100),
 tipo enum("baratija","valioso"),
 precioActual decimal(10,2),
 idPirata int null,
 constraint ck_Precio check(precioActual>0),
 constraint pk_tesoro primary key(idTesoro)
  );
 -- constraint fk_idPirata foreign key()
 create table islaPirata(
 idPirata int,
 coordX int,
 Fecha date,
 constraint pk_islaPirata primary key(fecha,coordX,idPirata)
 );
 drop table islapirata;
 create table pirataTesoro(
 idPirata int,
 idTesoro int,
 constraint pk_pirataTesoro primary key(idpirata,idtesoro)
 );isla
 -- insertar datos
 
 -- modificar las tablas necesarias para crear/añadir claves foraneas
 -- alter modificamos tabla, alter table nombre_tabla
 alter table tesoro add constraint fk_pirata_tesoro foreign key(idPirata) references pirata(idPirata);
 alter table islapirata add constraint fk_islaPirata_pirata foreign key(idPirata) references pirata(idPirata);
 alter table islapirata add constraint fk_islaPirata_isla foreign key(coordX) references isla(coordX);
 alter table islapirata add constraint fk_islaPirata_isla2 foreign key(coordY) references isla(coordY);
 alter table islapirata 
 
 
