/*Tabla libros*/
create table libros(
	codLi int not null auto_increment,
    titulo varchar(30) not null,
    autor varchar(30) not null,
    stock int not null,
    precioCompra decimal(4,2) not null,
    codTem int null,
    constraint pk_libros primary key(codLi),
    constraint ck_stock check(stock>0)
);

/*Tabla temáticas*/
create table tematicas(
	codTem int not null auto_increment,
	nombre varchar(20) not null,
    descripcion varchar(100) not null,
    constraint pk_tematicas primary key(codTem)
);

/*Inserciones*/
INSERT INTO tematicas (`nombre`, `descripcion`) VALUES ('Acción', 'Género caracterizado por gran cantidad de escenas de lucha');
INSERT INTO tematicas (`nombre`, `descripcion`) VALUES ('Romance', 'Género caracterizado por tener escenas de amor');
INSERT INTO tematicas (`nombre`, `descripcion`) VALUES ('Miedo', 'Género caracterizado por disponer de escenas de terror, pánico');
INSERT INTO tematicas (`nombre`, `descripcion`) VALUES ('Thriller', 'Género caracterizado por disponer de escenas de suspense, intriga');

INSERT INTO libros (`titulo`, `autor`, `stock`, `precioCompra`,`codTem`) VALUES ('El señor de los Anillos', 'J. R. R. Tolkien', '200', '35.95',"1");
INSERT INTO libros (`titulo`, `autor`, `stock`, `precioCompra`,`codTem`) VALUES ('Harry Potter', 'J.K. Rowling', '350', '29.95',"1");
INSERT INTO libros (`titulo`, `autor`, `stock`, `precioCompra`,`codTem`) VALUES ('Puerto Escondido', 'María Oruña', '150', '19.50',"2");
INSERT INTO libros (`titulo`, `autor`, `stock`, `precioCompra`,`codTem`) VALUES ('The Ring', 'Gore Verbinski', '100', '15.50',"3");
alter table libros add constraint fk_libros_tematicas foreign key(codTem) references tematicas(codTem)
