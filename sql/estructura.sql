drop procedure if exists ``;
DELIMITER $$
create procedure ``()
begin

end$$
DELIMITER ;
-- ----------------------------
DROP function IF EXISTS ``;

DELIMITER $$
CREATE FUNCTION `` ()
RETURNS 
BEGIN

RETURN 
END$$
DELIMITER ;

set global log_bin_trust_function_creators=1;
signal sqlstate '45000' set message_text="";
select count(*) from information_schema.tables where table_schema="nombre_baseDatos" and table_name="nombre_tabla";

case
  where condicion then
       instruccion
  where cond then
      instruccion
  else 
  instruccion
end case;

while condicion do
  instruccion
end while;

INSERT INTO tabla (columnas) VALUES (datos);

drop temporary table if exists nom_tabla;

 alter table nom_tabla  add column nom_colum varchar(100);

update nom_tabla set nom_colum = dato where condicion;