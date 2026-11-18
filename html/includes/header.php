<?php
  // Verificar si hay un usuario logeado para el header dinamico
  require_once __DIR__ . '/../../src/auth.php'; 
  require_once __DIR__ . '/../../config/config.php';
  $usuario = usuario_actual();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Avisos Clasificados</title>

    <!-- Bootstrap cargado correctamente por CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- <link rel="stylesheet" href="style.css"> -->
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="clasificados.php">Avisos Clasificados</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="clasificados.php">Inicio</a>
        </li>

        <!-- Si el usuario tiene el rol de Publicador vera el menu Mis Avisos -->
        <?php if ($usuario && $usuario['rol'] === 'publicador'): ?>
          <li class="nav-item">
            <a class="nav-link" href="publicador.php">Mis avisos</a>
          </li>
        <?php endif; ?>
        
         <!-- Si el usuario tiene el rol de Aministrador vera el menu Gestion -->
        <?php if ($usuario && $usuario['rol'] === 'administrador'): ?>
          <li class="nav-item">
            <a class="nav-link" href="admin.php">Gestión</a>
          </li>
        <?php endif; ?>
      </ul>
      <!-- En caso que no tenga ningun rol (es decir que no se logeo, solo aparecera INICIO) -->
      <ul class="navbar-nav ms-auto">
        <!-- Si un usuario esta logeado en el sisteama aparecera su nombre (usuario) y la opcion de cerrar la sesion (logout.php)-->
        <?php if ($usuario): ?>
          <li class="nav-item">
            <span class="nav-link text-light"><?= htmlspecialchars($usuario['nombre']) ?></span>
          </li>
          <li class="nav-item">
            <a class="nav-link text-warning fw-bold" href="logout.php">Cerrar sesión</a>
          </li>
        <!-- Por defecto si no hay un usuario logeado se mostrara el boton inicio de sesion (el cual redirige a el formulario de login.php ) -->
        <?php else: ?>
          <li class="nav-item">
            <a class="nav-link text-warning fw-bold" href="login.php">Iniciar sesión</a>
          </li>
        <?php endif; ?>
      </ul>
    </div>
  </div>
</nav>

<main class="container"></main>