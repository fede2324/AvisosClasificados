<?php 
echo '<h2>Método: ' . $_SERVER['REQUEST_METHOD'] . '</h2>';

echo '<h3>$_POST</h3><pre>';
print_r($_POST);
echo '</pre>';

echo '<h3>Campos que llegaron con valor</h3><ul>';
foreach ($_POST as $campo => $valor) {
    echo '<li><b>' . htmlspecialchars($campo) . '</b> = '
       . htmlspecialchars(var_export($valor, true)) . '</li>';
}
echo '</ul>';

echo '<p><a href="publicador.php">Volver</a></p>';
