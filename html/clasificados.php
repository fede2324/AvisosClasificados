<?php
    require __DIR__ . '/../src/db.php';
    use function database\conn;

    // Realizar conexion con la base de datos, para traer los avisos cargados, para lo cual se utiliza el usuario "visor" el cual tiene los minimos privilegios para solo  obtener los registros cargados
    $conexion = conn('visor');

    try {
        // Intentar la consulta
        $avisos = $conexion->query('SELECT * FROM vw_avisos_visor ORDER BY categoria, fecha_creacion')->fetch_all(MYSQLI_ASSOC);

    } catch (mysqli_sql_exception $e) {
        // En caso de error, se indicara (500) y mostrara un mensaje simple al usuario
        http_response_code(500);
        error_log($e->getMessage());
        exit('No se pudo cargar los avisos.');
    } finally{
        // Para ambos casos se cierra la conexion previamente establecida
        $conexion->close();
    }

    // Colocar header (el cual tiene los CSS  y el header + Nav )
    require __DIR__ . '/includes/header.php';
?>
<!-- 2. TÍTULO DE LA PÁGINA -->
    <header>
        <h1 class="text-center mt-2"> Avisos</h1>
    </header>
    <main>
        <?php
        // 3. CONTROL DE LO QUE SE MUESTRA
        if (!$avisos){echo 'No hay avisos disponibles';}
        ?>
        <div class="container py-4">
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-3">
                <?php foreach ($avisos as $a): ?>
                <div class="col">
                    <div class="card h-100 <?= $a['resaltado'] ? 'border-info border-2' : '' ?>">
                    <div class="card-body">
                        <h5 class="card-title"><?= htmlspecialchars($a['titulo']) ?></h5>
                        <h6 class="card-subtitle mb-2 text-muted"><?= htmlspecialchars($a['categoria']) ?></h6>
                        <!-- Datos específicos según la categoría -->
                    </div>
                    <div class="card-footer small text-muted">
                        <?= htmlspecialchars($a['autor']) ?> · Tel: <?= htmlspecialchars($a['telefono']) ?>
                        · <?= date('d/m/Y H:i', strtotime($a['fecha_creacion'])) ?>
                    </div>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>        
<?php 
require __DIR__ . '/includes/footer.php';
?>