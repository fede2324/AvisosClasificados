<?php
    // 1. BLOQUE PHP DE LÓGICA (antes de cualquier HTML)
    use function database\conn;
    //    - Cargar la conexión (require de db.php con __DIR__)
    require __DIR__ . '/../src/db.php';

    try {
        $conexion = conn('visor');
        $avisos = $conexion->query('SELECT * FROM vw_avisos_visor ORDER BY categoria, fecha_creacion')->fetch_all(MYSQLI_ASSOC);

    } catch (mysqli_sql_exception $e) {
        http_response_code(500);
        error_log($e->getMessage());
        exit('No se pudo cargar los avisos.');
    }
    require __DIR__ . '/includes/header.php';
?>
<!-- 2. TÍTULO DE LA PÁGINA -->
    <header>
        <h1 class="text-center mt-2"> Avisos</h1>
    </header>
    <main>
        <?php
        // 3. CONTROL DE LO QUE SE MUESTRA
        if (!$avisos){echo 'No hay avisos para mostrar';}
        //    - Si $avisos está vacío: mensaje "No hay avisos publicados"
        //    - Si hay error (la variable de error está seteada): mensaje genérico
        //    - Si hay datos: recorrer con foreach
        ?>
        <div class="container py-4">
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-3">
                <?php foreach ($avisos as $a): ?>
                <div class="col">
                    <div class="card h-100 <?= $a['resaltado'] ? 'border-info border-2' : '' ?>">
                    <div class="card-body">
                        <h5 class="card-title"><?= htmlspecialchars($a['titulo']) ?></h5>
                        <h6 class="card-subtitle mb-2 text-muted"><?= htmlspecialchars($a['categoria']) ?></h6>

                        <!-- Datos específicos según la categoría (ver abajo) -->

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

        <!-- 4. RECORRIDO DE AVISOS (foreach dentro del HTML)
            Por cada aviso:
                - Mostrar la categoría (agrupar: si cambia, mostrar un <h2> nuevo)
                - Mostrar título, autor y teléfono
                - Si resaltado = 1, aplicar negrita o clase CSS
                - Mostrar el precio o sueldo según la categoría
                - Usar htmlspecialchars() en cada dato -->
        
<?php 
require __DIR__ . '/includes/footer.php';
?>