create database gim;
use gim;
create table socios(
	codSo int not null primary key,
    nombre varchar(100) not null,
    abono enum("mini", "maxi", "familiar") not null
);
create table actividades(
	codAct int not null primary key,
    nombre varchar(100) not null
);
create table registro_actividades(
	codSo int not null,
    codAct int not null,
    fecha datetime not null,
    constraint pk_registro primary key(codSo, codAct, fecha)
);

INSERT INTO `gim`.`actividades` (`codAct`, `nombre`) VALUES ('1', 'Zumba');
INSERT INTO `gim`.`actividades` (`codAct`, `nombre`) VALUES ('2', 'Bici');
INSERT INTO `gim`.`actividades` (`codAct`, `nombre`) VALUES ('3', 'Bodycombat');

INSERT INTO `gim`.`socios` (`codSo`, `nombre`, `abono`) VALUES ('1', 'Pepe López López', 'maxi');
INSERT INTO `gim`.`socios` (`codSo`, `nombre`, `abono`) VALUES ('2', 'Marta Pérez Marín', 'mini');
INSERT INTO `gim`.`socios` (`codSo`, `nombre`, `abono`) VALUES ('3', 'Luisa López Martínez', 'familiar');

INSERT INTO `gim`.`registro_actividades` (`codSo`, `codAct`, `fecha`) VALUES ('1', '1', '2025-01-01');
INSERT INTO `gim`.`registro_actividades` (`codSo`, `codAct`, `fecha`) VALUES ('2', '1', '2025-01-01');
INSERT INTO `gim`.`registro_actividades` (`codSo`, `codAct`, `fecha`) VALUES ('3', '2', '2025-01-01');


alter table registro_actividades add constraint fk_registro_socio foreign key(codSo) references socios(codSo);
alter table registro_actividades add constraint fk_registro_actividad foreign key(codAct) references actividades(codAct);


select * from actividades a join registro_actividades r using(codact) join socios s using(codso);

-- obten el nombre del socio y el nombre y la fecha de la actividad en las que han participado
select actividades.nombre, socios.nombre, fecha from  actividades  join registro_actividades  using(codact) join socios  using(codso);

-- obtener los nombres de los socios que han realizado en algún momento la actividad de zumba
select socios.nombre from actividades join registro_actividades using(codact) join socios using(codso) where actividades.nombre="zumba";

-- obten los nombres de las actividades que han realizado los socios con abono familiar
select actividades.nombre  from actividades join registro_actividades using(codact) join socios using(codso) where socios.abono like"familiar";

-- obtén los días de las fechas en las que pepe lópez participó en zumba
select day(fecha) from actividades join registro_actividades using(codact) join socios using(codso) where actividades.nombre="zumba" and socios.nombre like"pepe lópez%";