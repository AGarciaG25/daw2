<?php

session_start();

$db = mysqli_connect('localhost', 'root', '1234', 'mysitedb') or die('Fail');
?>
<html>
    <head>
        <style>
            img{
                width: 200px;
                height: 300px;
            }
        </style>
    </head>
   <body>
      <?php
         if (!isset($_GET['id'])) {
            die('No se ha especificado una pelicula');
         }

         
            if (!isset($_GET['id'])) {
                die('No se ha especificado una pelicula');
            }

            $peli_id = intval($_GET['id']);

            $user_id_a_insertar = null;
            if (!empty($_SESSION['user_id'])) {
                $user_id_a_insertar = intval($_SESSION['user_id']);
            }

            $query = 'SELECT * FROM tPeliculas WHERE id=' . $peli_id;
            $result = mysqli_query($db, $query) or die('Query error');
            if (!$result || mysqli_num_rows($result) === 0) {
                 die('Película no encontrada');
            }
            $only_row = mysqli_fetch_array($result);
            echo $only_row['id'];
         echo '<br>';
         echo $only_row['nombre']; 
         echo '<br>';
         echo '<img src="' . $only_row['url_imagen'] . '" alt="Cartel">';
         echo '<br>';
         echo $only_row['director'];  
         echo '<br>';
         echo $only_row['anio'];
         echo '<br>';
         if ($user_id_a_insertar !== null) {
             $queryUser = 'SELECT nombre FROM tUsuarios WHERE id=' . $user_id_a_insertar;
             $resultUser = mysqli_query($db, $queryUser);
             if ($resultUser && mysqli_num_rows($resultUser) > 0) {
                 $userRow = mysqli_fetch_array($resultUser);
                 echo htmlspecialchars($userRow['nombre']);
             } else {
                 echo "(usuario no encontrado)";
             }
         } else {
             echo "(anonimo)";
         }
         echo '<br><br>';
    
        if (!empty($_SESSION['user_id'])) {
            echo '<p><a class="enlace-sesion" href="cambiarContraseña.html">Cambiar contraseña</a> | <a class="enlace-sesion" href="logout.php">Cerrar sesión</a></p>';
        }
      ?>
      <h3>Comentarios:</h3>
      <ul>
        <?php
         $queryComments = 'SELECT c.comentario, c.fecha, c.Usuario_id, u.nombre AS usuario '
                         . 'FROM tComentarios c '
                         . 'LEFT JOIN tUsuarios u ON c.Usuario_id = u.id '
                         . 'WHERE c.Pelicula_id = ' . $peli_id . ' '
                         . 'ORDER BY c.fecha DESC';
         $resultComments = mysqli_query($db, $queryComments) or die('Query error');
         if ($resultComments && mysqli_num_rows($resultComments) > 0) {
             while ($row = mysqli_fetch_assoc($resultComments)) {
                 $nombreUsuario = (isset($row['usuario']) && $row['usuario'] !== null) ? htmlspecialchars($row['usuario']) : '(anonimo)';
                 echo '<li><pre>' . htmlspecialchars($row['comentario']) . '  Usuario: ' . $nombreUsuario . '  Fecha: ' . $row['fecha'] . '</pre></li>';
             }
         } else {
             echo '<li>No hay comentarios todavía.</li>';
         }
         mysqli_close($db);
        ?>
     </ul>
     <p>Deja un nuevo comentario:</p>
     <form action="/comment.php" method="post">
        <textarea rows="4" cols="50" name="new_comment"></textarea><br>
        <input type="hidden" name="pelicula_id" value="<?php echo $peli_id; ?>">
        <input type="submit" value="Comentar">
     </form>
    </body>
</html>