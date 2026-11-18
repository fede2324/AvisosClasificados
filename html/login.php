<?php
// Panel de login
require_once 'auth.php';

$error = $_SESSION['error'] ?? null;
unset($_SESSION['error']);

if ($error): ?>
    <p style="color:red;"><?= htmlspecialchars($error) ?></p>
<?php endif; 

require __DIR__ . '/includes/header.php';
?>

<!-- Tarjeta del Formulario -->
    <div class="card shadow-sm border-0">
        <div class="card-body p-4 p-md-5">
            
            <div class="text-center mb-4">
                <h2 class="fw-bold fs-3">Bienvenido</h2>
                <p class="text-muted small">Ingresa tus datos para continuar</p>
            </div>
            <form action="procesar_login.php" method="POST" class="needs-validation">
                <div class="mb-3">
                    <label for="usuario" class="form-label">Correo o Usuario</label>
                    <input type="email" class="form-control" id="usuario" name="email" required>
                    <div class="invalid-feedback">
                        Por favor ingresa tu usuario o correo.
                    </div>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="password" name="password"  required>
                    <div class="invalid-feedback">
                        Por favor ingresa tu contraseña.
                    </div>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Iniciar Sesión</button>
                </div>
            </form>
        </div>
    </div>
<?php require __DIR__ . '/includes/footer.php';?>