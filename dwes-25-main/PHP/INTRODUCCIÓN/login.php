<html>
  <body>
    <h1>Login</h1>
    <?php
      if (isset($_POST["usuario"]) && isset($_POST["password"])) {
        $u = $_POST["usuario"];
        $p = $_POST["password"];

        if ($u == "admin" && $p == "1234") {
          echo "Acceso concedido";
        } else {
          echo "Acceso denegado";
        }
      }
    ?>

    <form action="/login.php" method="post">
      <label for="usuario">Usuario:</label><br>
      <input type="text" id="usuario" name="usuario"><br>

      <label for="password">Contraseña:</label><br>
      <input type="password" id="password" name="password"><br><br>

      <input type="submit" value="Entrar">
    </form>
  </body>
</html>