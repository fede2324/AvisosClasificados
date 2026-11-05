# Proyecto final de PHP

## Descripcion:

Aplicación web simple desarrollada en PHP que permite publicar, listar y gestionar avisos clasificados, con conexión a base de datos MySQL.



## Requisitos del proyecto:

### Funcionalidades

- [ ] `clasificados.php`: listado público de avisos, ordenados por categoría y fecha de creación
- [ ] Avisos resaltados (negrita o tamaño mayor) cuando el autor paga el doble
- [ ] `publicador.php`: ver, crear, modificar y borrar los propios avisos
- [ ] Un publicador no puede modificar ni borrar avisos de otro publicador
- [ ] Modificación de avisos sin cambio de categoría
- [ ] `admin.php`: ver todos los avisos y borrar cualquiera
- [ ] `admin.php`: crear y borrar usuarios publicadores
- [ ] Autenticación simple: usuario y contraseña en cada acción (sin sesiones)

### Técnico

- [ ] Programación orientada a objetos (herencia, encapsulación, getters/setters)
- [ ] Conexión a MySQL con PDO y consultas preparadas
- [ ] Manejo de excepciones (try/catch)
- [ ] Formularios enviados por POST, con validación del lado del servidor

### Extras (opcionales)

- [ ] `admin.php` crea la base de datos y las tablas (avisa si ya existen)
