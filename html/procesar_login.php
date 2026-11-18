<?php
require_once 'auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: login.php');
    exit;
}

$email    = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';

try {
    if (login($email, $password)) {
        switch ($_SESSION['usuario']['rol']) {
            case 'administrador':
                header('Location: admin.php');
                break;
            case 'publicador':
                header('Location: publicador.php');
                break;
            default:
                header('Location: clasificados.php');
        }
    } else {
        $_SESSION['error'] = 'Email o contraseña incorrectos, o el usuario no tiene rol asignado.';
        header('Location: login.php');
    }
} catch (mysqli_sql_exception $e) {
    error_log($e->getMessage());
    $_SESSION['error'] = 'Error de conexión. Intentá más tarde.';
    header('Location: login.php');
}
exit;
