<?php

session_start();

$db = mysqli_connect('localhost', 'root', '1234', 'mysitedb') or die('Fail');
?>
<html>
<body>
<?php
$peli_id = $_POST['pelicula_id'];
$comentario = $_POST['new_comment'];


$user_id = null;
if (!empty($_SESSION['user_id'])) {
    $user_id = intval($_SESSION['user_id']);
}

if ($peli_id <= 0 || $comentario === '') {
    echo '<p>Falta id de película o comentario vacío.</p>';
    echo '<a href="/detail.php?id=' . htmlspecialchars($peli_id) . '">Volver</a>';
    mysqli_close($db);
    exit;
}

if ($user_id === null) {
    $stmt = mysqli_prepare($db, "INSERT INTO tComentarios (comentario, Pelicula_id) VALUES (?, ?)");
    if (!$stmt) { die('Prepare error'); }
    mysqli_stmt_bind_param($stmt, 'si', $comentario, $peli_id);
} else {
    $stmt = mysqli_prepare($db, "INSERT INTO tComentarios (comentario, Pelicula_id, Usuario_id) VALUES (?, ?, ?)");
    if (!$stmt) { die('Prepare error'); }
    mysqli_stmt_bind_param($stmt, 'sii', $comentario, $peli_id, $user_id);
}

if (!mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    mysqli_close($db);
    die('Error al insertar comentario');
}

$insert_id = mysqli_insert_id($db);
mysqli_stmt_close($stmt);
mysqli_close($db);

echo '<p>Nuevo comentario ' . htmlspecialchars($insert_id) . ' añadido</p>';
echo '<a href="/detail.php?id=' . htmlspecialchars($peli_id) . '">Volver</a>';
?>
</body>
</html>