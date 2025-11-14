create database GestiónInfluencers;

create table Influencers(
codInf int auto_increment,
dni varchar(9),
nombreReal varchar(30),
nombreArtistico varchar(40),
finicio date,
salario decimal(10,2),
telf varchar(20) null,
fnac date,
mayorEdad boolean,
nivelFama enum("Alto","Medio","Bajo"),
constraint pkInfluencers primary key(codInf),
constraint ukInfluencers unique(dni),
constraint ckSalario check(salario>=0),
constraint ckMayorEdad check(mayorEdad=1));

create table Marcas(
codM int auto_increment,
nombre varchar(50),
añoFundacion year,
web varchar(100),
constraint pkMarca primary key(codM),
constraint ckAñoFundacion check(añoFundacion>=1900 and añoFundacion<=2024));

create table Colaboran(
codInf int,
codM int,
fecha date,
NivelExito enum("Alto","Medio","Bajo"),
constraint PkColaboran primary key(codInf,codM,fecha));

create table RedesSociales(
codRed int auto_increment,
nombre varchar(50),
fCreacion date,
numSeguidores int,
constraint pkredes primary key(codRed));

create table trabajanEn(
codInf int,
codRed int,
fInicio date,
fFin date null,
constraint pkTrabajan primary key(codInf, codRed, fInicio));

alter table colaboran add constraint fk_colaboranInflu foreign key(codInf) references Influencers(codInf);



