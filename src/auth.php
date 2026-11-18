<?php
// Archivo de autenticación de páginas privadas
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once __DIR__ . '/db.php';
use function database\conn;

/**
 * Valida email y contraseña. Si son correctos, guarda los datos en $_SESSION.
 */
function login(string $correo, string $contraseña){
    $conexion = conn('admin'); // cuenta de solo lectura

    $sql = "SELECT u.id_usuario, u.email,u.nombre, u.passwd_hash, r.nombre AS rol
            FROM usuario u
            INNER JOIN rol r ON r.id_rol = u.id_rol
            WHERE u.email = ?";

    try {
        $stmt = $conexion->prepare($sql);
        $stmt->bind_param('s', $correo);
        $stmt->execute();
        $usuario = $stmt->get_result()->fetch_assoc();
        $stmt->close();
    } finally {
        $conexion->close();
    }

    if (!$usuario || !password_verify($contraseña, $usuario['passwd_hash'])) {
        return false;
    }

    session_regenerate_id(true);

    $_SESSION['usuario'] = [
        'id'    => $usuario['id_usuario'],
        'nombre' => $usuario['nombre'],
        'rol'   => $usuario['rol'],
    ];

    return true;
}

function usuario_actual(){
    return $_SESSION['usuario'] ?? null;
}


function requerir_rol(array $roles_permitidos){
    $rol = $_SESSION['usuario']['rol'] ?? null;

    if ($rol === null || !in_array($rol, $roles_permitidos, true)) {
        $_SESSION['error'] = 'Debes iniciar sesión con un rol autorizado.';
        header('Location: login.php');
        exit;
    }
}