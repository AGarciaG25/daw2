<?php

session_start();
if (empty($_SESSION['user_id'])) {
  header('Location: /login.html'); exit;
}
$db = mysqli_connect('localhost', 'root', '1234', 'web_canciones') or die('Fail');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $actual = $_POST['f_actual'] ?? '';
  $nueva1 = $_POST['f_nueva1'] ?? '';
  $nueva2 = $_POST['f_nueva2'] ?? '';

  if ($nueva1 === '' || $nueva2 === '' || $actual === '') {
    die('<p>Completa todos los campos.</p><p><a href="/change_password.php">Volver</a></p>');
  }
  if ($nueva1 !== $nueva2) {
    die('<p>Las contraseñas nuevas no coinciden.</p><p><a href="/change_password.php">Volver</a></p>');
  }


  $stmt = mysqli_prepare($db, "SELECT contraseña FROM tUsuarios WHERE id = ?");
  mysqli_stmt_bind_param($stmt, "i", $_SESSION['user_id']);
  mysqli_stmt_execute($stmt);
  $res = mysqli_stmt_get_result($stmt);
  $row = mysqli_fetch_assoc($res);
  if (!$row || !password_verify($actual, $row['contraseña'])) {
    die('<p>La contraseña actual no es correcta.</p><p><a href="/change_password.php">Volver</a></p>');
  }
  mysqli_stmt_close($stmt);

  
  $nuevo_hash = password_hash($nueva1, PASSWORD_DEFAULT);
  $stmt2 = mysqli_prepare($db, "UPDATE tUsuarios SET contraseña = ? WHERE id = ?");
  mysqli_stmt_bind_param($stmt2, "si", $nuevo_hash, $_SESSION['user_id']);
  mysqli_stmt_execute($stmt2) or die('Error al actualizar contraseña');
  mysqli_stmt_close($stmt2);

  mysqli_close($db);
  echo '<p>Contraseña cambiada correctamente.</p><p><a href="/main.php">Volver</a></p>';
  exit;
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Cambiar contraseña</title>
</head>
<body>
  <h1>Cambiar contraseña</h1>
  <form action="/change_password.php" method="post">
    <input type="password" name="f_actual" placeholder="Contraseña actual"><br>
    <input type="password" name="f_nueva1" placeholder="Nueva contraseña"><br>
    <input type="password" name="f_nueva2" placeholder="Repite nueva contraseña"><br>
    <input type="submit" value="Cambiar">
  </form>
  <p><a href="/main.php">Volver</a></p>
</body>
</html>
