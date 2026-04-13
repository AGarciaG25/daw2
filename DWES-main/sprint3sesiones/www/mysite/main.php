<?php 
session_start();
 $db = mysqli_connect('localhost', 'root', '1234', 'mysitedb') or die('Fail'); ?> 

<html>
    <head>
        <style>
          body{
            font-style: italic;
            font-family: Georgia, 'Times New Roman', Times, serif;
            background-color: beige;
            font-weight:bold;
            padding: 20px;
          }
          .pelis{
            display: grid;
            grid-template-columns: repeat(auto-fill, 220px);
            gap: 18px;
            justify-content: start;
            align-items: start;
          }
          .pelicula{
            background: #fff8e6;
            border-radius: 8px;
            padding: 12px;
            text-align: center;
            transition: transform 240ms ease, box-shadow 240ms ease, opacity 240ms ease;
            opacity: 0.95;
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            transform: translateY(0) scale(1);
          }
          .pelicula:hover{
            transform: translateY(-8px) scale(1.03);
            opacity: 1;
            box-shadow: 0 8px 18px rgba(0,0,0,0.16);
          }
          .pelicula img{
            width: 150px;
            height: 200px;
            display: block;
            margin: 0 auto 8px;
            border-radius: 4px;
            object-fit: cover;
          }
          .titulo{
            font-size: 17px;
            margin: 4px 0;
            color: #333;
          }
          .datos{
            font-size: 14px;
            color: #555;
          }
          .enlace-sesion{
            display: inline-block;
            padding: 6px 10px;
            border-radius: 6px;
            background: rgba(255,255,255,0.9);
            transition: transform 200ms ease, box-shadow 200ms ease, background 200ms ease;
            color: #222;
            text-decoration: none;
            margin-left: 6px;
          }
          .enlace-sesion:hover{
            transform: translateY(-3px);
            box-shadow: 0 6px 14px rgba(0,0,0,0.12);
            background: #fff;
          }
          .cabecera{
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
          }
          .cabecera .acciones{
            display: flex;
            align-items: center;
            justify-content: flex-end;
          }
        
          img{
            width: 150px;
            height: 200px;
          }
        </style>
    </head>
    <body>
    <div class="cabecera">
      <h1>Conexión establecida</h1>
      <div class="acciones">
      <?php if (!empty($_SESSION['user_id'])): ?>
        <a class="enlace-sesion" href="cambiarContraseña.html">Cambiar contraseña</a>
        <a class="enlace-sesion" href="logout.php">Cerrar sesión</a>
      <?php else: ?>
        <a class="enlace-sesion" href="login.html">Iniciar sesión</a>
        <span style="margin:0 8px;">|</span>
        <a class="enlace-sesion" href="register.html">Registrarse</a>
      <?php endif; ?>
      </div>
    </div>
        <div class="pelis">
          <?php 
            $query = 'SELECT * FROM tPeliculas'; 
            $result = mysqli_query($db, $query) or die('Query error');
            
             while ($row = mysqli_fetch_array($result)) { 
                echo '<div class="pelicula">';
                echo '<a href="detail.php?id='.$row['id'].'">';
                echo '<img src="' . $row['url_imagen'] . '" alt="Cartel">';
                echo '</a>';
                echo '<div class="titulo">' . htmlspecialchars($row['nombre']) . '</div>';
                echo '<div class="datos">ID: ' . $row['id'] . ' | ' . htmlspecialchars($row['director']) . ' (' . $row['anio'] . ')</div>';
                echo '</div>';
            } 
            mysqli_close($db); 
          ?>
        </div>        
    </body>
</html>
