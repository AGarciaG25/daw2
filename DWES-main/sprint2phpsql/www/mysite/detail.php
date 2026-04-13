<?php
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
         $peli_id = $_GET['id'];
         $query = 'SELECT * FROM tPeliculas WHERE id='.$peli_id;
         $result = mysqli_query($db, $query) or die('Query error');
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
         echo '<br><br><br>';
      ?>
      <h3>Comentarios:</h3>
      <ul>
        <?php
         $query2 = 'SELECT * FROM tComentarios WHERE Pelicula_id='.$peli_id;
         $result2 = mysqli_query($db, $query2) or die('Query error');
         while ($row = mysqli_fetch_array($result2)) {
             echo '<li><pre>'.$row['comentario'].'      Fecha:'.$row['fecha'].'</pre></li>';
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