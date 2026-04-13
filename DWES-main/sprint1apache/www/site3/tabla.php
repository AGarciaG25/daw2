<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<html>
<body>
  <?php 
  $indice=0;
  $mult=7;
  
  ?>
    <table>
        <th>Tabla del 7</th>
        <?php for($indice =1;$indice<=10;$indice++) { ?>

        <tr>
            <td><?="$mult x $indice" ?></td>
            <td><?=$mult * $indice ?></td></td>
        </tr>

        <?php } ?>
    </table>

</body>
</html>