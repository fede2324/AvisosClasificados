USE avisos_clasificados;

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
VALUES ('Admin', 'admin@test.com', '099000000', '$2y$10$yqFEsGk/T08pM8/JBEExDu5WruUqKtEk5fQCz8nc4FZIkjDC11DOm',
        (SELECT id_rol FROM rol WHERE nombre = 'administrador'));



