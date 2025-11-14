/*¿Qué es un índice?
Un índice en MySQL es una estructura de datos que permite localizar filas de forma rápida y eficiente sin tener que recorrer toda la tabla.
Funciona como el índice de un libro: te ayuda a encontrar la información sin leer página por página.

¿Pará que sirve? Principales usos
Acelerar consultas SELECT que usan WHERE, JOIN, ORDER BY.
Garantizar unicidad en columnas (PRIMARY KEY, UNIQUE).
Mejorar el rendimiento en grandes volúmenes de datos.
Sin índices, MySQL debe revisar fila por fila (búsqueda secuencial). Con índices, accede directamente a los datos relevantes (búsqueda indexada).

Tipos de índices
PRIMARY KEY: Clave principal. Identifica cada fila de forma única. No acepta nulos.
UNIQUE: Garantiza que no se repitan los valores.
INDEX (normal): Acelera consultas, permite duplicados.
FULLTEXT: Para búsquedas en texto completo (en columnas tipo TEXT, VARCHAR).
SPATIAL: Para datos geométricos (mapas, coordenadas).

¿Sintaxis de creación, modificación, borrado?
creación:
CREATE INDEX idx_nombre ON nom_tabla(nom_columna);
CREATE UNIQUE INDEX idx_unico ON nom_tabla(nom_columna1, nom_columna2);

modificación:
ALTER TABLE tabla ADD INDEX idx_nombre (columna);
ALTER TABLE tabla ADD UNIQUE idx_unico (columna);

borrado:
ALTER TABLE tabla DROP INDEX idx_nombre;
ALTER TABLE tabla DROP PRIMARY KEY;

¿Dónde se guardan, cómo se listan?
SHOW INDEX FROM nombre_tabla;

Ejemplos prácticos*/

CREATE DATABASE Indices;
USE Indices;
CREATE TABLE personas2 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(15)
);

INSERT INTO personas2 (nombre, apellido, telefono) VALUES
('Juan', 'Gómez', '600123456'),
('Ana', 'López', '600234567'),
('Carlos', 'Pérez', '600345678'),
('Laura', 'Martínez', '600456789'),
('José', 'Sánchez', '600567890'),
('María', 'Fernández', '600678901'),
('David', 'Ruiz', '600789012'),
('Lucía', 'Ramírez', '600890123'),
('Pedro', 'Torres', '600901234'),
('Sofía', 'Flores', '601012345'),
('Miguel', 'Díaz', '601123456'),
('Clara', 'Romero', '601234567'),
('Diego', 'Vega', '601345678'),
('Elena', 'Molina', '601456789'),
('Raúl', 'Ortiz', '601567890'),
('Natalia', 'Iglesias', '601678901'),
('Javier', 'Castro', '601789012'),
('Marta', 'Gil', '601890123'),
('Iván', 'Herrera', '601901234'),
('Patricia', 'Navarro', '602012345');

CREATE INDEX idx_nombre ON personas(nombre);
ALTER TABLE personas2 ADD INDEX idx_num_ap (apellido,telefono);
SELECT * FROM personas WHERE nombre = 'diego';
SELECT * FROM personas2 WHERE apellido = 'romero';
SHOW INDEX FROM personas;
SHOW INDEX FROM personas2;
ALTER TABLE personas2 DROP INDEX idx_num_ap;
EXPLAIN SELECT * FROM personas2 WHERE apellido = 'romero';
