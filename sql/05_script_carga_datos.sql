-- SCRIPT para carga de datos de pruebas (usando un usuario de prueba y evaluar como se listan)
USE avisos_clasificados;

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