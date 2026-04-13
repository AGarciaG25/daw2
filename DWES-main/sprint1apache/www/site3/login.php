<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <form action="/login.php" method="post">
        <label for="usuario">Nombre de usuario</label>
        <input type="text" name="usuario" id="usuario">
        <br>
        <label for="contraseña">Contraseña</label>
        <input type="password" name="contraseña" id="contraseña">
        <br>
        <input type="submit" value="enviar">
    </form>

    <?php
        if (isset($_POST["usuario"]) &&  ($_POST["contraseña"])){
            $user = $_POST["usuario"];
            $pasw = $_POST["contraseña"];
            if($user === "admin" && $pasw === "1234"){
                echo "Acceso concedido";
            }else{
                echo "Acceso denegado";
            }
        }
    ?>
</body>
</html>