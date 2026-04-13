<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>Conversor de temperatura</h1>
    <?php
       if(isset($_POST["eleccion"])){
        if($_POST["eleccion"] == "Celsius"){
            $v_c = $_POST["Grados"];
            $v_f = $v_c*1.8+32; 
            echo $v_c . "ºC = ".$v_f."ºF";
        }elseif($_POST["eleccion"] == "Fahrenheit") {
             $v_f = $_POST["Grados"];
            $v_c = ($v_f-32)/1.8; 
            echo $v_f . "ºF = ".$v_c."ºC";
            
        }
       }
    ?>
    <form action="/temperatura.php" method="post">
    <label for="cantidad_rec">Grados:</label><br>
    <input type="text" id="cantidad_rec" name="Grados"></input><br>
    
    <input type="radio" id="Celsius" name="eleccion" value="Celsius">
    <label for="Celsius">Celsius</label><br>
    <input type="radio" id="Fahrenheit" name="eleccion" value="Fahrenheit">
    <label for="Fahrenheit">Fahrenheit</label><br>
    <input type="submit" value="Convertir">
    </form>
</body>
</html>