<?php
use function database\conn;

require __DIR__ . '/../src/db.php';   // ajustar la ruta según tu carpeta

// MODO PRUEBA: sin login. Quitar cuando esté lista la sesión.
$emailPrueba = 'admin@test.com';

// Texto que resume los datos de cada categoría
function detalle(array $a): string {
    if ($a['categoria'] === 'Laboral') {
        $sueldo = $a['sueldo_mensual'] !== null
            ? '$' . number_format((float)$a['sueldo_mensual'], 2, ',', '.')
            : 'a convenir';
        return $a['empresa'] . ' · Sueldo: ' . $sueldo;
    }
    if ($a['categoria'] === 'Producto') {
        return $a['descripcion_producto'] . ' · Precio: $'
             . number_format((float)$a['precio_producto'], 2, ',', '.');
    }
    $precio = $a['operacion'] === 'venta'
        ? 'Venta: $' . number_format((float)$a['precio_venta'], 2, ',', '.')
        : 'Alquiler: $' . number_format((float)$a['precio_alquiler'], 2, ',', '.');
    return ucfirst($a['tipo_inmueble']) . ' en ' . $a['ubicacion'] . ' · ' . $precio;
}

// Consulta de los avisos del usuario de prueba
$conexion = conn('publicador');
$stmt = $conexion->prepare(
    'SELECT id_aviso, titulo, categoria, fecha_creacion, resaltado,
            empresa, sueldo_mensual,
            descripcion_producto, precio_producto,
            tipo_inmueble, ubicacion, operacion, precio_venta, precio_alquiler
     FROM vw_avisos_gestion
     WHERE id_usuario = (SELECT id_usuario FROM usuario WHERE email = ?)
     ORDER BY categoria, fecha_creacion DESC'
);
$stmt->bind_param('s', $emailPrueba);
$stmt->execute();
$misAvisos = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stmt->close();
// print_r($misAvisos);
$titulo_pagina = 'Avisos Clasificados: Mis avisos';
require __DIR__ . '/includes/header.php';
?>
<main class="container py-4">
        <h1>MIS AVISOS</h1>
        </main>
        <div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header text-white py-3">
                    <h4 class="mb-0 text-center">Publicar Nuevo Aviso</h4>
                </div>
                
                <div class="card-body p-4">
                    <!-- El action apunta a tu script PHP (ej: procesar_aviso.php) -->
                    <form action="procesar_aviso.php" method="POST">
                        
                        <!-- Campo oculto para el ID del usuario (se suele obtener de la sesión en PHP) -->
                        <input type="hidden" name="id_usuario" value="1">

                        <!-- ========================================== -->
                        <!-- SECCIÓN 1: DATOS GENERALES (Tabla: aviso)  -->
                        <!-- ========================================== -->
                        <h6 class="text-primary mb-3 border-bottom pb-2">Datos Generales</h6>
                        
                        <div class="mb-3">
                            <label for="titulo" class="form-label fw-semibold">Título del Aviso</label>
                            <input type="text" class="form-control" id="titulo" name="titulo" required placeholder="Ej: Se busca panadero / Vendo televisión">
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-8">
                                <label for="id_categoria" class="form-label fw-semibold">Categoría</label>
                                <select class="form-select" id="id_categoria" name="id_categoria" required onchange="mostrarCampos()">
                                    <option value="" selected disabled>-- Seleccione una categoría --</option>
                                    <option value="laboral">Laboral</option>
                                    <option value="producto">Producto</option>
                                    <option value="inmobiliario">Inmobiliario</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="resaltado" value="1" id="resaltado">
                                    <label class="form-check-label fw-semibold text-warning" for="resaltado">
                                         Resaltar aviso
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- ========================================== -->
                        <!-- SECCIÓN 2: DATOS LABORALES                 -->
                        <!-- ========================================== -->
                        <div id="seccion-laboral" class="seccion-especifica mt-4 p-3 bg-light rounded border">
                            <h6 class="text-primary mb-3">Detalles del Empleo</h6>
                            
                            <div class="mb-3">
                                <label for="empresa" class="form-label">Nombre de la Empresa</label>
                                <input type="text" class="form-control" id="empresa" name="empresa" placeholder="Ej: Panadería El Trigo">
                            </div>

                            <div class="mb-3">
                                <label for="descripcion_cargo" class="form-label">Descripción del Cargo</label>
                                <textarea class="form-control" id="descripcion_cargo" name="descripcion_cargo" rows="3" placeholder="Requisitos, tareas, experiencia..."></textarea>
                            </div>

                            <div class="mb-3">
                                <label for="sueldo_mensual" class="form-label">Sueldo Mensual</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="sueldo_mensual" name="sueldo_mensual" step="0.01" min="0" placeholder="0.00">
                                </div>
                            </div>
                        </div>

                        <!-- ========================================== -->
                        <!-- SECCIÓN 3: DATOS DE PRODUCTO               -->
                        <!-- ========================================== -->
                        <div id="seccion-producto" class="seccion-especifica mt-4 p-3 bg-light rounded border">
                            <h6 class="text-primary mb-3">Detalles del Producto</h6>
                            
                            <div class="mb-3">
                                <label for="descripcion_producto" class="form-label">Descripción del Producto</label>
                                <textarea class="form-control" id="descripcion_producto" name="descripcion" rows="3" placeholder="Ej: Smart TV 32 pulgadas, HD, con control remoto"></textarea>
                            </div>

                            <div class="mb-3">
                                <label for="precio_producto" class="form-label">Precio</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="precio_producto" name="precio" step="0.01" min="0" placeholder="0.00">
                                </div>
                            </div>
                        </div>

                        <!-- ========================================== -->
                        <!-- SECCIÓN 4: DATOS INMOBILIARIOS             -->
                        <!-- ========================================== -->
                        <div id="seccion-inmobiliario" class="seccion-especifica mt-4 p-3 bg-light rounded border">
                            <h6 class="text-primary mb-3">Detalles del Inmueble</h6>
                            
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label for="tipo_inmueble" class="form-label">Tipo de Inmueble</label>
                                    <select class="form-select" id="tipo_inmueble" name="tipo_inmueble">
                                        <option value="casa">Casa</option>
                                        <option value="apartamento">Apartamento</option>
                                        <option value="local">Local Comercial</option>
                                        <option value="terreno">Terreno</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="operacion" class="form-label">Tipo de Operación</label>
                                    <select class="form-select" id="operacion" name="operacion" onchange="togglePreciosInmobiliario()">
                                        <option value="venta">Venta</option>
                                        <option value="alquiler">Alquiler</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="ubicacion" class="form-label">Ubicación</label>
                                <input type="text" class="form-control" id="ubicacion" name="ubicacion" placeholder="Ej: Barrio Ejemplo, Centro">
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label for="superficie_m2" class="form-label">Superficie (m²)</label>
                                    <input type="number" class="form-control" id="superficie_m2" name="superficie_m2" step="0.01" min="0" placeholder="0.00">
                                </div>
                                <div class="col-md-6">
                                    <label for="inmobiliaria" class="form-label">Nombre de la Inmobiliaria</label>
                                    <input type="text" class="form-control" id="inmobiliaria" name="inmobiliaria" placeholder="Ej: Inmobiliaria Sur">
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="precio_venta" class="form-label">Precio de Venta</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control" id="precio_venta" name="precio_venta" step="0.01" min="0" placeholder="0.00">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="precio_alquiler" class="form-label">Precio Alquiler (mensual)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control" id="precio_alquiler" name="precio_alquiler" step="0.01" min="0" placeholder="0.00">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="gastos_comunes" class="form-label">Gastos Comunes</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control" id="gastos_comunes" name="gastos_comunes" step="0.01" min="0" placeholder="0.00">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- <hr> -->
                        <hr class="border border-primary border-3 opacity-75">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>Título</th>
                                        <th>Categoría</th>
                                        <th>Detalle</th>
                                        <th>Creado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (empty($misAvisos)): ?>
                                        <tr>
                                            <td colspan="4" class="text-center text-muted">No hay avisos para este usuario.</td>
                                        </tr>
                                    <?php endif; ?>

                                    <?php foreach ($misAvisos as $a): ?>
                                        <tr>
                                            <td class="<?= $a['resaltado'] ? 'fw-bold' : '' ?>">
                                                <?= htmlspecialchars($a['titulo']) ?>
                                            </td>
                                            <td><?= htmlspecialchars($a['categoria']) ?></td>
                                            <td><?= htmlspecialchars(detalle($a)) ?></td>
                                            <td><?= date('d/m/Y H:i', strtotime($a['fecha_creacion'])) ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                        <!-- Botón de Envío -->
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary btn-lg">Publicar Aviso</button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</main>

<script>
// Muestra solo la sección de la categoría elegida
function mostrarCampos() {
    const cat = document.getElementById('id_categoria').value;
    document.querySelectorAll('.seccion-especifica').forEach(s => s.classList.add('d-none'));
    const id = { laboral: 'seccion-laboral', producto: 'seccion-producto', inmobiliario: 'seccion-inmobiliario' }[cat];
    if (id) document.getElementById(id).classList.remove('d-none');
}

// Según venta o alquiler, muestra el precio que corresponde
function togglePreciosInmobiliario() {
    const esAlquiler = document.getElementById('operacion').value === 'alquiler';
    document.querySelectorAll('.precio-venta').forEach(e => e.classList.toggle('d-none', esAlquiler));
    document.querySelectorAll('.precio-alquiler').forEach(e => e.classList.toggle('d-none', !esAlquiler));
}
</script>

<?php require __DIR__ . '/includes/footer.php'; ?>