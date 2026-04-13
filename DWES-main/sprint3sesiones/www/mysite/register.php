<?php

$db = mysqli_connect('localhost', 'root', '1234', 'mysitedb') or die('Fail');

$nombre = $_POST['nombre'];
$apellido = $_POST['apellido'];
$email = $_POST['email'];
$contraseña = $_POST['contraseña'];
$contraseña2 = $_POST['contraseña2'];

if ($nombre === "" || $apellido === "" || $email === "" || $contraseña === "" || $contraseña2 === "") {
    echo '<p>Campos sin completar</p>';
} else {
   
    $query = $db ->prepare("SELECT *  FROM tUsuarios WHERE email = ?");
    $query ->bind_param("s",$email);
    $query ->execute();
    $count=$query->get_result();
    $query->close();

    if (mysqli_num_rows($count) > 0) {
        
        echo '<p>El correo ya está en uso</p>';
    } elseif ($contraseña != $contraseña2) {
    
        echo '<p>Las contraseñas no coinciden</p>';
    } else {
    
        $cifrado = password_hash($contraseña, PASSWORD_DEFAULT);

     
        $insertar = $db ->prepare("INSERT INTO tUsuarios (nombre, apellidos, email, contraseña) VALUES (?, ?, ?, ?)");
        $insertar ->bind_param("ssss", $nombre, $apellido, $email, $cifrado);
       
        if($insertar ->execute()){
            header('Location: main.php');
        exit();
        }else{
            echo '<p>Error al registrar el usuario.</p>';
        }
        $insertar->close();
    }
}

mysqli_close($db); 
?>
