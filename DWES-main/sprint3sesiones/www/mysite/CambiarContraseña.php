<?php
session_start();

$db = mysqli_connect('localhost', 'root', '1234', 'mysitedb') or die('Fail');

function error_volver($msg) {
    echo '<p>' . htmlspecialchars($msg) . '</p>';
    echo '<p><a href="cambiarContraseña.html">Volver</a></p>';
    exit;
}


if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_SESSION['user_id'])) {
    header('Location: login.html');
    exit;
}

$user_id = intval($_SESSION['user_id']);
$old = isset($_POST['old_password']) ? $_POST['old_password'] : '';
$new = isset($_POST['new_password']) ? $_POST['new_password'] : '';
$new2 = isset($_POST['new_password2']) ? $_POST['new_password2'] : '';

if ($old === '' || $new === '' || $new2 === '') {
    error_volver('Campos incompletos.');
}
if ($new !== $new2) {
    error_volver('Las nuevas contraseñas no coinciden.');
}

$stmt = mysqli_prepare($db, "SELECT contraseña FROM tUsuarios WHERE id = ?");
if (!$stmt) { error_volver('Error interno.'); }
mysqli_stmt_bind_param($stmt, 'i', $user_id);
mysqli_stmt_execute($stmt);
mysqli_stmt_bind_result($stmt, $hash);
if (!mysqli_stmt_fetch($stmt)) {
    mysqli_stmt_close($stmt);
    error_volver('Usuario no encontrado.');
}
mysqli_stmt_close($stmt);

if (!password_verify($old, $hash)) {
    mysqli_close($db);
    error_volver('La contraseña actual no es correcta.');
}


$newHash = password_hash($new, PASSWORD_DEFAULT);
$upd = mysqli_prepare($db, "UPDATE tUsuarios SET contraseña = ? WHERE id = ?");
if (!$upd) { error_volver('Error interno.'); }
mysqli_stmt_bind_param($upd, 'si', $newHash, $user_id);
if (!mysqli_stmt_execute($upd)) {
    mysqli_stmt_close($upd);
    error_volver('Error al actualizar la contraseña.');
}
mysqli_stmt_close($upd);
mysqli_close($db);

header('Location: main.php?pass_changed=1');
exit;
?>