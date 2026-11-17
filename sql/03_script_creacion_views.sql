-- Script para creacion de VIEWS, usadas en las distintas paginas

--  DB --
USE avisos_clasificados;


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
