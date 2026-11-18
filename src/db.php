<?php
namespace database;
use mysqli;

function conn(string $usuario) : mysqli{
    // Se toma los datos desde el archivo de configuracion
    $config = require __DIR__ . '/../config/config.php';
    $datos  = $config['cuentas'][$usuario];

    //Convertir errores SQL en Excepciones
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

    //usar los datos para crear la conexion
    $conexion = new mysqli($config['host'], $datos['user'],$datos['pass'],$config['dbname']);
    $conexion->set_charset($config['charset']);
    return $conexion;

}