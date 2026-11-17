<?php
// Plantilla de configuración. Copiar a config.php y completar con las claves reales.
return [
    'host'    => 'localhost',
    'dbname'  => 'avisos_clasificados',
    'charset' => 'utf8mb4',
    'cuentas' => [
        'visor'      => ['user' => 'visor',       'pass' => 'visor'],
        'publicador' => ['user' => 'publicador',  'pass' => 'publicador'],
        'admin'      => ['user' => 'adminAvisos', 'pass' => 'admin'],
    ],
];
