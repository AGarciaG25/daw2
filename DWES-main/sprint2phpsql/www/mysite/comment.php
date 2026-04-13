<?php
$db = mysqli_connect('localhost', 'root', '1234', 'mysitedb') or die('Fail');
?>
<html>
<body>
<?php
$peli_id = $_POST['pelicula_id'];
$comentario = $_POST['new_comment'];
$query = "INSERT INTO tComentarios(comentario, pelicula_id, usuario_id)
VALUES ('".$comentario."',".$peli_id.",NULL)";
mysqli_query($db, $query) or die('Error');
echo "<p>Nuevo comentario ";
echo mysqli_insert_id($db);
echo " añadido</p>";
echo "<a href='/detail.php?id=".$peli_id."'>Volver</a>";

mysqli_close($db);
?>
</body>
</html>