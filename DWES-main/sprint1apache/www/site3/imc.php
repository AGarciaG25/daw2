<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php
    $peso = $_GET['peso'];
    $altura = $_GET['altura'];

    function imc($peso, $altura){
        $imc=round(($peso/($altura*$altura)),2);
    

        if($imc<18.5){
           echo "$imc: Bajo peso";
        }elseif($imc >= 18.5 && $imc <= 24.9){
           echo "$imc: Normal";
        }else{
           echo "$imc: Sobrepeso";
        }
    }
    imc($peso, $altura);
    ?>
</body>
</html>