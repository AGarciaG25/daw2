<?php
$db = mysqli_connect('localhost', 'root', '1234', 'mysitedb') or die('Fail');

$email = $_POST['email'];
$password = $_POST['contraseña'];
echo $password;
echo $email;

$query = $db->prepare("SELECT * FROM tUsuarios WHERE email = ?");
$query->bind_param("s", $email);
$query->execute();
$result = $query->get_result();
$query->close();


if (mysqli_num_rows($result) === 0) {
    echo '<p>Email no encontrado</p>';
} else {
    $row = $result->fetch_assoc();
    $hash = $row['contraseña'];

    if (!password_verify($password, $hash)) {
        echo '<p>Contraseña incorrecta</p>';
    } else {
        session_start();
        $_SESSION['user_id'] = $row['id'];
        header('Location: main.php');
        exit();
    }
}

mysqli_close($db);
?>