<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php
       $productos = array(array("producto"=>"Manzana","precio"=>0.5), array("producto"=>"Pan","precio"=>1.2));
    ?>
    <table>
        <tr>
            <td>Producto</td>
            <td>Precio</td>
        </tr>
        <?php foreach($productos as $dato){
            $total += $dato["precio"];
        echo "<tr>";
        echo "<td>" . $dato["producto"] . "</td>";
        echo "<td>" . number_format($dato["precio"],2) . "€" . "</td>";
        echo "</tr>";
        }
        ?>
        <tr>    
         <td>TOTAL</td>
         <td><?= number_format($total, 2) ?> €</td>
      </tr>
    </table>
</body>
</html>