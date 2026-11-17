<?php
use function database\conn;
// Panel de administrador
require __DIR__ . '/includes/header.php';
require __DIR__ . '/../src/db.php';

try {
    $conexion = conn('admin');
    
    // Estadísticas rápidas
    $totalAvisos = $conexion->query('SELECT COUNT(*) as total FROM aviso')->fetch_assoc()['total'];
    $avisosResaltados = $conexion->query('SELECT COUNT(*) as total FROM aviso WHERE resaltado = 1')->fetch_assoc()['total'];
    $totalAutores = $conexion->query('SELECT COUNT(*) as total FROM usuario')->fetch_assoc()['total'];
    
} catch (mysqli_sql_exception $e) {
    http_response_code(500);
    error_log($e->getMessage());
    echo $e->getMessage();
    exit('Error al cargar datos del admin.');
}
?>

<div class="container py-4">
    <h1 class="mb-4 text-center">Panel de Administración</h1>
   
    <!-- Estadísticas -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card text-bg-primary">
                <div class="card-body">
                    <h5 class="card-title">Total Avisos</h5>
                    <p class="card-text display-6"><?= $totalAvisos ?></p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-bg-warning">
                <div class="card-body">
                    <h5 class="card-title">Avisos Resaltados</h5>
                    <p class="card-text display-6"><?= $avisosResaltados ?></p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-bg-success">
                <div class="card-body">
                    <h5 class="card-title">Autores Registrados</h5>
                    <p class="card-text display-6"><?= $totalAutores ?></p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Menú de gestión -->
    <div class="row">
        <div class="col-md-3">
            <div class="list-group">
                <a href="admin_avisos.php" class="list-group-item list-group-item-action">
                     Gestionar Avisos
                </a>
                <a href="admin_autores.php" class="list-group-item list-group-item-action">
                     Gestionar Autores
                </a>
                <a href="admin_categorias.php" class="list-group-item list-group-item-action">
                     Gestionar Categorías
                </a>
                <a href="admin_roles.php" class="list-group-item list-group-item-action">
                     Roles y Permisos
                </a>
                <a href="admin_backups.php" class="list-group-item list-group-item-action">
                     Backups
                </a>
                
            </div>
        </div>
        
        <div class="col-md-9">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Bienvenido al panel de administración</h5>
                    <p class="card-text">
                        Seleccioná una opción del menú para gestionar el sistema.
                    </p>
                </div>
            </div>
        </div>
        
    </div>
</div>

<?php require __DIR__ . '/includes/footer.php'; ?>
    </body>
</html>