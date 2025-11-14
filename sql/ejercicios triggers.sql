-- Tablas Para los Ejercicios:
create database ejerciciosTriggers;
use ejerciciosTriggers;
CREATE TABLE recetas (
    IdReceta INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    IngredientePpal VARCHAR(20) NOT NULL,
    Descripción TEXT,
    Dificultad VARCHAR(200) NOT NULL,
    Coste DECIMAL(5,2)
);

create table conteoRecetas(
recetasFaciles int null,
recetasIntermedias int null,
recetasDificiles int null);

CREATE TABLE clientes (
    IdCliente INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Telefono VARCHAR(9) NOT NULL
);
CREATE TABLE pedidos (
    IdPedido INT NOT NULL PRIMARY KEY,
    fechaP DATE NOT NULL,
    IdCliente INT NOT NULL,
    Total DECIMAL(10,2) NOT NULL
);

alter table pedidos add constraint fk_clientes_pedidos FOREIGN KEY (IdCliente) REFERENCES clientes(IdCliente);

CREATE TABLE empleados (
    IdEmpleado INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Falta DATE NOT NULL,
    Salario DECIMAL(10,2) NOT NULL
);

CREATE TABLE ControlSalario (
    IdEmpleado INT NOT NULL,
    Fecha DATE NOT NULL,
    Salario DECIMAL(10,2) NOT NULL,
    constraint pk_controlSalario PRIMARY KEY (IdEmpleado, Fecha)
);

alter table ControlSalario add constraint fk_empleados_control FOREIGN KEY (IdEmpleado) REFERENCES empleados(IdEmpleado);

drop trigger if exists BI_verificacion_recetas;
delimiter $$
create trigger BI_verificacion_recetas BEFORE insert on recetas for each row
begin
   IF(new.dificultad not in("baja","media","alta"))then
        set new.dificultad:= "media";
    end if;
   if(new.coste < 1) then
        set new.coste:= 1;
	end if;
   if(length(new.IngredientePpal) > 10) then
      signal sqlstate '45000' set message_text="Ingrediente principal muy complejo";
   end if;
   case
      when new.dificultad = "baja" then
          update conteoRecetas set recetasFaciles= recetasFaciles + 1;
	  when new.dificultad = "media" then
          update conteoRecetas set recetasIntermedias= recetasIntermedias +1;
	  when new.dificultas = "alta" then
          update conteoRecetas set recetasDificiles = recetasDificiles +1;
	end case;
end$$
delimiter ;




-- Datos triggers exámen
create database repasoExamen;
use repasoExamen;
create table alumnos(
	id int not null primary key,
    nombre varchar(100) not null,
    total decimal(10,2) not null
);
insert into alumnos values (1, "Juan", 0), (2, "María", 0);

create table notas(
	idAlumno int not null primary key,
    evaluacion1 decimal(10,2) not null,
    evaluacion2 decimal(10,2) not null,
    evaluacion3 decimal(10,2) not null
);

create table productos(
	codigoarticulo int not null auto_increment primary key,
    nombrearticulo varchar(50) not null,
    precio int not null,
    stock int not null
);
insert into productos values (0,"Sofá", 300, 250), (0, "Televisor", 300, 150), (0, "Lámpara", 95, 190);

create table socios(
	id int not null primary key,
    nombre varchar(100) not null,
    falta date not null,
    abono varchar(100) not null,
	importe decimal(10,2) not null,
    fmodificación date null
);
insert into socios values (1,"Juan",'2022-01-01',"mini",22.50,null), (2,"María",'2022-01-01',"maxi",35.50,null);

create table regalos(
	idSocio int not null,
    fecha date not null,
    regalo varchar(200) not null,
    constraint pk_regalos PRIMARY KEY (Idsocio, Fecha));

insert into regalos values (1,'2022-01-01',"Clase Padel"), (2,'2022-01-01',"Acceso Spa");
-- ------------------------------------------------

drop trigger if exists BI_verificar_alumno;
delimiter $$
create trigger BI_verificar_alumno BEFORE insert on notas for each row
begin
    if(new.evaluacion1 <0)then
        set new.evaluacion1=0;
	end if;
    if(new.evaluacion1 >10)then
        set new.evaluacion1=10;
	end if;
    if(new.evaluacion2 <0)then
        set new.evaluacion2=0;
	end if;
    if(new.evaluacion2 >10)then
        set new.evaluacion2=10;
	end if;
    if(new.evaluacion3 <0)then
        set new.evaluacion3=0;
	end if;
    if(new.evaluacion3 >10)then
        set new.evaluacion3=10;
	end if;
    update alumnos set total=(new.evaluacion1+new.evaluacion2+new.evaluacion3)/3 where id= new.idalumno;
end$$
delimiter ;
insert into notas values(1,5,7,3);
insert into notas values(2,15,3,7);

drop trigger if exists BU_verificar_alumno;
delimiter $$
create trigger BU_verificar_alumno BEFORE update on notas for each row
begin
    if(new.evaluacion1 <0)then
        set new.evaluacion1=0;
	end if;
    if(new.evaluacion1 >10)then
        set new.evaluacion1=10;
	end if;
    if(new.evaluacion2 <0)then
        set new.evaluacion2=0;
	end if;
    if(new.evaluacion2 >10)then
        set new.evaluacion2=10;
	end if;
    if(new.evaluacion3 <0)then
        set new.evaluacion3=0;
	end if;
    if(new.evaluacion3 >10)then
        set new.evaluacion3=10;
	end if;
    update alumnos set total=(new.evaluacion1+new.evaluacion2+new.evaluacion3)/3 where id= new.idalumno;
end$$
delimiter ;
 
 update notas set idalumno=1,evaluacion1=7,evaluacion2=8,evaluacion3=9 where idalumno= 1;
 
 -- ------------------------------------------------
 
 create table mod_productos(
 codigoarticulo int not null auto_increment primary key,
    nombrearticulo varchar(50) not null,
    precio int not null,
    stock int not null,
    old_codigoarticulo int not null auto_increment primary key,
    old_nombrearticulo varchar(50) not null,
    old_precio int not null,
    old_stock int not null,
    empleado int,
    fecha datetime);
    
    
    
    drop trigger if exists BU_verificar_productos;
delimiter $$
create trigger BU_verificar_productos BEFORE update on productos for each row
begin
if() then
end$$
delimiter ;

-- --------------------------------------------------

drop trigger if exists BU_verificar_abono;
delimiter $$
create trigger BU_verificar_abono BEFORE update on socios for each row
begin
   if(new.abono != old.abono) then
     if((datediff(now(),old.fmodificación))>=30 or old.fmodificación is null) then
      case
         when new.abono= "mini" then
		     set new.importe=22.5; set new.fmodificación= now();
             insert regalos set idSocio= new.id, fecha= now(), regalo="clase padel";
         when new.abono= "familiar" then
			 set new.importe=40.5; set new.fmodificación= now();
             insert regalos set idSocio= new.id, fecha= now(), regalo="juegos en piscina";
         else
         set new.abono:="Maxi";
			 set new.importe=35.5; set new.fmodificación= now();
             insert regalos set idSocio= new.id, fecha= now(), regalo="acceso a spa";
	  end case;
	end if;
   end if;
end$$
delimiter ;

update socios set abono="mini" where id=2;

select datediff(now(),(select falta from socios where id=1));

-- -------------------------------------------------

create table usuarios(
    iduser int not null auto_increment primary key,
    email varchar(50) not null,
    totalPositivos int not null,
    totalNegativos int not null,
    totalComentarios int not null
 );
  create table comentarios(
    idcoment int not null auto_increment primary key,
    iduser int not null,
    fecha date not null,
    tipo char(1) not null, -- El tipo puede ser P o N, positivo o negativo
    texto varchar(1000)
 );

-- Inicialmente cuando se inserta el usuario por defecto los comentarios positivos y negativos son 0 
INSERT INTO `usuarios` (`iduser`, `email`, `totalPositivos`, `totalNegativos`, `totalComentarios`) VALUES ('1', 'iria@gmail.com', '0', '0', '0');
INSERT INTO `usuarios` (`iduser`, `email`, `totalPositivos`, `totalNegativos`, `totalComentarios`) VALUES ('2', 'pepe@gmail.com', '0', '0', '0');

-- Clave foránea
alter table comentarios add constraint fk_usuarioscomentarios foreign key(iduser) references usuarios(iduser);

    drop trigger if exists BI_insert_comentarios;
delimiter $$
create trigger BI_insert_comentarios BEFORE insert on comentarios for each row
begin
if(new.iduser not in (select iduser from usuarios)) then
    signal sqlstate '45000' set message_text="El usuario no existe";
end if;
if(new.tipo not in ("P", "N")) then
    signal sqlstate '45000' set message_text="Tipo de comentario erroneo";
end if;
if(new.fecha != current_date())then
    signal sqlstate '45000' set message_text="Las fecha no es valida";
end if;
if(new.tipo = "P") then
    update usuarios set totalcomentarios= totalcomentarios +1, totalPositivos= totalPositivos + 1 where iduser = new.iduser;
else
    update usuarios set totalcomentarios= totalcomentarios +1, totalNegativos= totalNegativos + 1 where iduser = new.iduser;
end if;
end$$
delimiter ;

insert into comentarios values(0,1,"2024-05-08","P","excelente");
insert into comentarios values(0,3,"2025-05-08","P","excelente");
insert into comentarios values(0,1,"2025-05-08","z","excelente");
insert into comentarios values(0,1,"2025-05-08","P","excelente");
