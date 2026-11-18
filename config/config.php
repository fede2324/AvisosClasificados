<?php
// Array asociativo con los datos de la conexion
return [
    'host'    => 'localhost',
    'dbname'  => 'avisos_clasificados',
    'port'  => '3306',
    'charset' => 'utf8mb4',
    'cuentas' => [
        'visor'      => ['user' => 'visor',       'pass' => 'visor'],
        'publicador' => ['user' => 'publicador',  'pass' => 'publicador'],
        'admin'      => ['user' => 'adminAvisos', 'pass' => 'admin'],
    ],
];


