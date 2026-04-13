<html>
  <body>
    <h1>Carrito</h1>
    <?php
      $carrito = array(
        "Manzana" => 0.50,
        "Pan" => 1.20,
        "Lambo" => 1000000
      );

      $total = 0.0;

      echo "<table border='1'>";
      echo "<tr><th>Producto</th><th>Precio (€)</th></tr>";
$i =0;
      foreach ($carrito as $producto => $precio) {
        
        echo "<tr>";
        echo "<td>" . $producto . "</td>";
        echo "<td>" . $precio . "</td>";
        echo "</tr>";
        $total = $total + $precio;
      }

      echo "<tr><td><b>TOTAL</b></td><td><b>" . $total . "</b></td></tr>";
      echo "</table>";
    ?>
  </body>
</html>