-- =====================================================================
-- Cuentas de MySQL de la aplicación (mínimo privilegio)
-- Ejecutar con root, DESPUÉS de crear tablas, vistas y datos.
-- =====================================================================

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
