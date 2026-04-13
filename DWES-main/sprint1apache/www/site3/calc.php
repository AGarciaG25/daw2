<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <form action="/calc.php" method="post">
        <label for="n1">Primer numero</label><br>
        <input type="text" name="n1" id="n1"><br>
        <label for="n2">Segundo numero</label><br>
        <input type="text" name="n2" id="n2">
        <label for="opcion"></label><br><br>
        <select name="opcion" id="opcion">
            <option value="suma">suma</option>
            <option value="resta">resta</option>
            <option value="division">division</option>
            <option value="multiplicacion">multiplicacion</option>
        </select>
        <input type="submit" value="Calcular">
    </form>
    <br>
    <?php
       if(isset($_POST["n1"]) && ($_POST["n2"])){
           $n1 = floatval($_POST["n1"]);
           $n2 = floatval($_POST["n2"]);
       
           switch($_POST["opcion"]){
                case "suma":
                    echo $n1." + ".$n2." = ".$n1 + $n2;
                    break;
                case "resta":
                    echo $n1." - ".$n2." = ".$n1 - $n2;
                    break;
                case "multiplicacion":
                    echo $n1." x ".$n2." = ".$n1 * $n2;
                    break;
                case "division":
                    echo $n1." : ".$n2." = ".$n1 / $n2;
            }

        }
        
    ?>
</body>
</html>