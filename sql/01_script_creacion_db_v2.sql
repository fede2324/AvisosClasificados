CREATE DATABASE IF NOT EXISTS avisos_clasificados;
USE avisos_clasificados;

CREATE TABLE IF NOT EXISTS rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre ENUM('administrador','publicador','visitante','respaldo') NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS permiso (
    id_permiso     INT AUTO_INCREMENT PRIMARY KEY,
    nombre_permiso VARCHAR(100) NOT NULL UNIQUE,
    desc_permiso   VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS rol_permiso (
    id_rol     INT NOT NULL,
    id_permiso INT NOT NULL,
    PRIMARY KEY (id_rol, id_permiso),
    FOREIGN KEY (id_rol)     REFERENCES rol(id_rol)         ON DELETE CASCADE,
    FOREIGN KEY (id_permiso) REFERENCES permiso(id_permiso) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario    INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    telefono    VARCHAR(20)  NOT NULL,
    passwd_hash VARCHAR(255) NOT NULL,
    id_rol      INT NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre       ENUM('Laboral','Producto','Inmobiliario') NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS aviso (
    id_aviso       INT AUTO_INCREMENT PRIMARY KEY,
    titulo         VARCHAR(255) NOT NULL,
    fecha_creacion DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    resaltado      BOOLEAN NOT NULL DEFAULT FALSE,
    id_categoria   INT NOT NULL,
    id_usuario       INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario)     REFERENCES usuario(id_usuario)         ON DELETE RESTRICT
);

-- Subentidades: la PK es también FK a aviso (relación 1 a 1)
CREATE TABLE IF NOT EXISTS aviso_laboral (
    id_aviso          INT PRIMARY KEY,
    empresa           VARCHAR(150) NOT NULL,
    descripcion_cargo TEXT NOT NULL,
    sueldo_mensual    DECIMAL(10,2) NULL,
    FOREIGN KEY (id_aviso) REFERENCES aviso(id_aviso) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS aviso_producto (
    id_aviso    INT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    precio      DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_aviso) REFERENCES aviso(id_aviso) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS aviso_inmobiliario (
    id_aviso        INT PRIMARY KEY,
    tipo_inmueble   ENUM('casa','apartamento') NOT NULL,
    operacion       ENUM('venta','alquiler')   NOT NULL,
    ubicacion       VARCHAR(255) NOT NULL,
    superficie_m2   DECIMAL(8,2),
    inmobiliaria    VARCHAR(150) NOT NULL,
    precio_venta    DECIMAL(12,2) NULL,
    precio_alquiler DECIMAL(10,2) NULL,
    gastos_comunes  DECIMAL(10,2) NULL,
    FOREIGN KEY (id_aviso) REFERENCES aviso(id_aviso) ON DELETE CASCADE,
    CHECK (
        (operacion = 'venta'
            AND precio_venta IS NOT NULL
            AND precio_alquiler IS NULL
            AND gastos_comunes IS NULL)
        OR
        (operacion = 'alquiler'
            AND precio_alquiler IS NOT NULL
            AND precio_venta IS NULL)
    )
);
