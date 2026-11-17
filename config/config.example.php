<?php
// Plantilla de configuración. Copiar a config.php y completar con las claves reales.
return [
    'host'    => 'localhost',
    'dbname'  => 'db_proyecto_v2',
    'charset' => 'utf8mb4',
    'cuentas' => [
        'visor'      => ['user' => 'visor',       'pass' => 'CAMBIAR_clave_visor'],
        'publicador' => ['user' => 'publicador',  'pass' => 'CAMBIAR_clave_publicador'],
        'admin'      => ['user' => 'adminAvisos', 'pass' => 'CAMBIAR_clave_admin'],
    ],
];
