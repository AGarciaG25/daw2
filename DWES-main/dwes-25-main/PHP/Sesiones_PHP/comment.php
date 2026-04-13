<?php
  session_start();
  $db = mysqli_connect('localhost', 'root', '1234', 'web_canciones') or die('Fail');

  $cancion_id = isset($_POST['cancion_id']) ? (int) $_POST['cancion_id'] : 0;
  $comentario = isset($_POST['new_comment']) ? $_POST['new_comment'] : '';

  $user_id_a_insertar = null;
  if (!empty($_SESSION['user_id'])) {
    $user_id_a_insertar = (int) $_SESSION['user_id'];
  }

  $stmt = mysqli_prepare($db,
    "INSERT INTO tComentarios(comentario, cancion_id, usuario_id) VALUES (?, ?, ?)"
  );
  mysqli_stmt_bind_param($stmt, "sii", $comentario, $cancion_id, $user_id_a_insertar);
  mysqli_stmt_execute($stmt) or die('Error al insertar comentario');

  $new_id = mysqli_insert_id($db);
  mysqli_stmt_close($stmt);
  mysqli_close($db);

  echo "<p>Comentario ".$new_id." añadido correctamente.</p>";
  echo "<a href='/detail.php?cancion_id=".$cancion_id."'>Volver</a>";
