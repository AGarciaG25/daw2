<html>
  <body>
    <h1>IMC</h1>
    <p>Ejemplo: imc.php?peso=70&altura=1.75</p>
    <p>
    <?php
      function calcular_imc($peso, $altura) {
        return $peso / ($altura * $altura);
      }

      if (isset($_GET["peso"]) && isset($_GET["altura"])) {
        $peso = $_GET["peso"];
        $altura = $_GET["altura"];
        $imc = calcular_imc($peso, $altura);

        if ($imc < 18.5) {
          echo "IMC: " . $imc . " → Bajo peso";
        } else if ($imc < 25) {
          echo "IMC: " . $imc . " → Normal";
        } else {
          echo "IMC: " . $imc . " → Sobrepeso";
        }
      } else {
        echo "Proporciona peso y altura por GET.";
      }
    ?>
    </p>
  </body>
</html>