-- ========================================
-- 					CREACION BASE DE DATOS  Y TABLAS
-- ========================================


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
--                 ----------------------------------


-- ========================================
-- 				            CARGA DE DATOS INICIALES
-- ========================================

-- Roles
INSERT IGNORE INTO rol (nombre) VALUES
  ('administrador'), ('publicador'), ('visitante'), ('respaldo');

-- Categorías
INSERT IGNORE INTO categoria (nombre) VALUES
  ('Laboral'), ('Producto'), ('Inmobiliario');

-- Permisos
INSERT IGNORE INTO permiso (nombre_permiso, desc_permiso) VALUES
  ('ver_avisos_publicados',  'Ver avisos publicados'),
  ('ver_avisos_propios',     'Ver avisos propios'),
  ('crear_aviso',            'Crear avisos'),
  ('modificar_aviso_propio', 'Modificar avisos propios'),
  ('borrar_aviso_propio',    'Borrar avisos propios'),
  ('ver_todos_los_avisos',   'Ver todos los avisos'),
  ('borrar_cualquier_aviso', 'Borrar cualquier aviso'),
  ('crear_usuario',          'Crear usuarios publicadores'),
  ('borrar_usuario',         'Borrar usuarios publicadores'),
  ('ejecutar_backup',        'Ejecutar respaldos'),
  ('ver_log_backups',        'Consultar log de respaldos');

-- Rol -> permisos
INSERT IGNORE INTO rol_permiso (id_rol, id_permiso)
SELECT r.id_rol, p.id_permiso
FROM rol r JOIN permiso p
  ON p.nombre_permiso IN ('ver_avisos_publicados')
WHERE r.nombre = 'visitante';

INSERT IGNORE INTO rol_permiso (id_rol, id_permiso)
SELECT r.id_rol, p.id_permiso
FROM rol r JOIN permiso p
  ON p.nombre_permiso IN ('ver_avisos_publicados','ver_avisos_propios','crear_aviso',
                          'modificar_aviso_propio','borrar_aviso_propio')
WHERE r.nombre = 'publicador';

INSERT IGNORE INTO rol_permiso (id_rol, id_permiso)
SELECT r.id_rol, p.id_permiso
FROM rol r JOIN permiso p
  ON p.nombre_permiso IN ('ver_avisos_publicados','ver_todos_los_avisos',
                          'borrar_cualquier_aviso','crear_usuario','borrar_usuario')
WHERE r.nombre = 'administrador';

INSERT IGNORE INTO rol_permiso (id_rol, id_permiso)
SELECT r.id_rol, p.id_permiso
FROM rol r JOIN permiso p
  ON p.nombre_permiso IN ('ejecutar_backup','ver_log_backups')
WHERE r.nombre = 'respaldo';


-- Creacion de usuario Hasheado (desde terminal y DEFAULT_HASH de PHP)  [password:admin123]
INSERT INTO usuario (nombre, email, telefono, passwd_hash, id_rol)
VALUES ('_Admin_', 'admin@test.com', '099000000', '$2y$10$yqFEsGk/T08pM8/JBEExDu5WruUqKtEk5fQCz8nc4FZIkjDC11DOm',
         (SELECT id_rol FROM rol WHERE nombre = 'administrador'));

-- Creacion de usuario "Publicador"   [password:admin123]
INSERT INTO usuario (nombre, email, telefono, passwd_hash, id_rol)
VALUES ('_publicador_', 'publicador@test.com', '099001001', '$2y$10$yqFEsGk/T08pM8/JBEExDu5WruUqKtEk5fQCz8nc4FZIkjDC11DOm',
        (SELECT id_rol FROM rol WHERE nombre = 'publicador'));


-- ============================================
-- 						CREACION DE VIEWS (VISOR Y GESTION)
-- ============================================


-- AVISOS_VISOR: usada en la pagina home (clasificados.php) para mostrar los avisos publicados hasta el momento
CREATE OR REPLACE VIEW vw_avisos_visor AS
SELECT a.id_aviso,
       a.titulo,
       a.fecha_creacion,
       a.resaltado,
       c.nombre              AS categoria,
       u.nombre              AS autor,
       u.telefono,
       l.empresa,
       l.descripcion_cargo,
       l.sueldo_mensual,
       p.descripcion         AS descripcion_producto,
       p.precio              AS precio_producto,
       i.tipo_inmueble,
       i.ubicacion,
       i.superficie_m2,
       i.inmobiliaria,
       i.operacion,
       i.precio_venta,
       i.precio_alquiler,
       i.gastos_comunes
FROM aviso a
JOIN categoria c               ON c.id_categoria = a.id_categoria
JOIN usuario u                 ON u.id_usuario     = a.id_usuario
LEFT JOIN aviso_laboral l      ON l.id_aviso     = a.id_aviso
LEFT JOIN aviso_producto p     ON p.id_aviso     = a.id_aviso
LEFT JOIN aviso_inmobiliario i ON i.id_aviso     = a.id_aviso;

-- AVISOS_GESTION: Esta view es usada para la gestion, siendo esta que cuenta con mas datos y se aplica en las paginas (admin.php y publicador.php) 
CREATE OR REPLACE VIEW vw_avisos_gestion AS
SELECT a.id_aviso,
       a.titulo,
       a.fecha_creacion,
       a.resaltado,
       a.id_usuario,
       a.id_categoria,
       c.nombre              AS categoria,
       u.nombre              AS autor,
       u.telefono,
       l.empresa,
       l.descripcion_cargo,
       l.sueldo_mensual,
       p.descripcion         AS descripcion_producto,
       p.precio              AS precio_producto,
       i.tipo_inmueble,
       i.ubicacion,
       i.superficie_m2,
       i.inmobiliaria,
       i.operacion,
       i.precio_venta,
       i.precio_alquiler,
       i.gastos_comunes
FROM aviso a
JOIN categoria c               ON c.id_categoria = a.id_categoria
JOIN usuario u                 ON u.id_usuario   = a.id_usuario
LEFT JOIN aviso_laboral l      ON l.id_aviso     = a.id_aviso
LEFT JOIN aviso_producto p     ON p.id_aviso     = a.id_aviso
LEFT JOIN aviso_inmobiliario i ON i.id_aviso     = a.id_aviso;


-- =============================================
--    CREACION DE USUARIOS Y PERMISOS PARA REALIZAR CONSULTAS
-- ============================================

-- Si existen de la versión anterior, se eliminan para empezar limpio
DROP USER IF EXISTS 'visor'@'localhost';
DROP USER IF EXISTS 'publicador'@'localhost';
DROP USER IF EXISTS 'adminAvisos'@'localhost';
DROP USER IF EXISTS 'respaldo'@'localhost';

CREATE USER 'visor'@'localhost'       IDENTIFIED BY 'visor';
CREATE USER 'publicador'@'localhost'  IDENTIFIED BY 'publicador';
CREATE USER 'adminAvisos'@'localhost' IDENTIFIED BY 'admin';
CREATE USER 'respaldo'@'localhost'    IDENTIFIED BY 'respaldo';

-- ---------------------------------------------------------------------
-- visor (visitante): solo lee la vista pública
-- ---------------------------------------------------------------------
GRANT SELECT ON avisos_clasificados.vw_avisos_visor TO 'visor'@'localhost';

-- ---------------------------------------------------------------------
-- publicador: lee la vista de gestión, crea/modifica/borra avisos.
-- El "solo mis avisos" se controla en PHP con WHERE id_autor = ?
-- ---------------------------------------------------------------------
GRANT SELECT ON avisos_clasificados.vw_avisos_gestion TO 'publicador'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON avisos_clasificados.aviso TO 'publicador'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON avisos_clasificados.aviso_laboral TO 'publicador'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON avisos_clasificados.aviso_producto TO 'publicador'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON avisos_clasificados.aviso_inmobiliario TO 'publicador'@'localhost';

-- Lectura necesaria para el formulario (categorías) y el login/RBAC (usuario, rol, permisos)
GRANT SELECT ON avisos_clasificados.categoria TO 'publicador'@'localhost';
GRANT SELECT ON avisos_clasificados.usuario TO 'publicador'@'localhost';
GRANT SELECT ON avisos_clasificados.rol TO 'publicador'@'localhost';
GRANT SELECT ON avisos_clasificados.permiso TO 'publicador'@'localhost';
GRANT SELECT ON avisos_clasificados.rol_permiso TO 'publicador'@'localhost';

-- ---------------------------------------------------------------------
-- adminAvisos: todo lo del publicador, más borrar cualquier aviso
-- y crear/borrar usuarios
-- ---------------------------------------------------------------------
GRANT SELECT ON avisos_clasificados.vw_avisos_gestion TO 'adminAvisos'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON avisos_clasificados.aviso TO 'adminAvisos'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON avisos_clasificados.aviso_laboral TO 'adminAvisos'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON avisos_clasificados.aviso_producto TO 'adminAvisos'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON avisos_clasificados.aviso_inmobiliario TO 'adminAvisos'@'localhost';

GRANT SELECT, INSERT, DELETE ON avisos_clasificados.usuario TO 'adminAvisos'@'localhost';
GRANT SELECT ON avisos_clasificados.categoria TO 'adminAvisos'@'localhost';
GRANT SELECT ON avisos_clasificados.rol TO 'adminAvisos'@'localhost';
GRANT SELECT ON avisos_clasificados.permiso TO 'adminAvisos'@'localhost';
GRANT SELECT ON avisos_clasificados.rol_permiso TO 'adminAvisos'@'localhost';

-- ---------------------------------------------------------------------
-- respaldo: permisos que necesita mysqldump para copiar toda la base
-- (la tabla backup_log, cuando exista, necesitará además INSERT)
-- ---------------------------------------------------------------------
GRANT SELECT, SHOW VIEW, LOCK TABLES, TRIGGER, EVENT
  ON avisos_clasificados.* TO 'respaldo'@'localhost';

FLUSH PRIVILEGES;


-- ============================================
-- 						      CARGA DE DATOS DE PRUEBAS
-- ============================================

SET @autor := (SELECT id_usuario FROM usuario WHERE email = 'admin@test.com');

-- Laboral (resaltado, para probar el borde destacado)
INSERT INTO aviso (titulo, resaltado, id_categoria, id_usuario)
VALUES ('Se busca panadero', TRUE,
        (SELECT id_categoria FROM categoria WHERE nombre = 'Laboral'), @autor);
SET @id := LAST_INSERT_ID();
INSERT INTO aviso_laboral (id_aviso, empresa, descripcion_cargo, sueldo_mensual)
VALUES (@id, 'Panadería El Trigo',
        'Panadero de turno mañana, experiencia mínima de un año', 45000.00);

-- Producto
INSERT INTO aviso (titulo, resaltado, id_categoria, id_usuario)
VALUES ('Vendo televisión 32"', FALSE,
        (SELECT id_categoria FROM categoria WHERE nombre = 'Producto'), @autor);
SET @id := LAST_INSERT_ID();
INSERT INTO aviso_producto (id_aviso, descripcion, precio)
VALUES (@id, 'Smart TV 32 pulgadas, HD, con control remoto', 8500.00);

-- Inmobiliario en venta
INSERT INTO aviso (titulo, resaltado, id_categoria, id_usuario)
VALUES ('Vendo casa', FALSE,
        (SELECT id_categoria FROM categoria WHERE nombre = 'Inmobiliario'), @autor);
SET @id := LAST_INSERT_ID();
INSERT INTO aviso_inmobiliario
  (id_aviso, tipo_inmueble, operacion, ubicacion, superficie_m2, inmobiliaria,
   precio_venta, precio_alquiler, gastos_comunes)
VALUES (@id, 'casa', 'venta', 'Barrio Ejemplo', 180.00, 'Inmobiliaria Sur',
        185000.00, NULL, NULL);

-- Inmobiliario en alquiler (prueba la otra rama del bloque de PHP)
INSERT INTO aviso (titulo, resaltado, id_categoria, id_usuario)
VALUES ('Alquilo apartamento', FALSE,
        (SELECT id_categoria FROM categoria WHERE nombre = 'Inmobiliario'), @autor);
SET @id := LAST_INSERT_ID();
INSERT INTO aviso_inmobiliario
  (id_aviso, tipo_inmueble, operacion, ubicacion, superficie_m2, inmobiliaria,
   precio_venta, precio_alquiler, gastos_comunes)
VALUES (@id, 'apartamento', 'alquiler', 'Centro', 60.00, 'Inmobiliaria Norte',
        NULL, 22000.00, 3500.00);
		
		
-- ============================================
-- 									FIN DE SCRIPT GENERAL
-- ============================================

