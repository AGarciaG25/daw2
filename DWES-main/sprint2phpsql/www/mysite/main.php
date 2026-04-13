<?php 
 $db = mysqli_connect('localhost', 'root', '1234', 'mysitedb') or die('Fail'); ?> 

<html>
    <head>
        <style>
          body{
            font-style: italic;
            font-family: Georgia, 'Times New Roman', Times, serif;
            background-color: beige;
            font-weight:bold;
          }
          img{
            width: 150px;
            height: 200px;
          }
        </style>
    </head>
    <body>
        <h1>Conexión establecida</h1>
        <div>
          <?php 
            $query = 'SELECT * FROM tPeliculas'; 
            $result = mysqli_query($db, $query) or die('Query error');
            
             while ($row = mysqli_fetch_array($result)) { 
                echo '<a href="detail.php?id='.$row['id'].'">'. $row['id'].'</a>';
                echo '<br>';
                echo $row['nombre']; 
                echo '<br>';
                echo '<img src="' . $row['url_imagen'] . '" alt="Cartel">';
                echo '<br>';
                echo $row['director'];  
                echo '<br>';
                echo $row['anio'];
                echo '<br><br><br>';
            } 
            mysqli_close($db); 
          ?>
        </div>        
    </body>
</html>
