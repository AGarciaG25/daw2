<?php
session_start();
session_unset();      // limpia variables de sesión
session_destroy();    // destruye la sesión en servidor
header('Location: main.php');
exit;
?>