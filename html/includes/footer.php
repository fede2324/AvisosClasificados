    </main>
    <!-- Bootstrap 5.3 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Lógica para mostrar/ocultar campos según la categoría -->
<script>
    function mostrarCampos() {
        // 1. Ocultar todas las secciones específicas
        document.getElementById('seccion-laboral').style.display = 'none';
        document.getElementById('seccion-producto').style.display = 'none';
        document.getElementById('seccion-inmobiliario').style.display = 'none';

        // 2. Quitar el atributo 'required' de todos los campos específicos para evitar errores de validación
        limpiarRequeridos();

        // 3. Obtener la categoría seleccionada
        const categoria = document.getElementById('id_categoria').value;

        // 4. Mostrar la sección correspondiente y activar sus 'required'
        if (categoria === 'laboral') {
            document.getElementById('seccion-laboral').style.display = 'block';
            activarRequeridos(['empresa', 'descripcion_cargo']);
        } else if (categoria === 'producto') {
            document.getElementById('seccion-producto').style.display = 'block';
            activarRequeridos(['descripcion_producto', 'precio_producto']);
        } else if (categoria === 'inmobiliario') {
            document.getElementById('seccion-inmobiliario').style.display = 'block';
            activarRequeridos(['tipo_inmueble', 'operacion', 'ubicacion', 'superficie_m2']);
            togglePreciosInmobiliario(); // Ajustar qué precio es obligatorio
        }
    }

    function togglePreciosInmobiliario() {
        const operacion = document.getElementById('operacion').value;
        const inputVenta = document.getElementById('precio_venta');
        const inputAlquiler = document.getElementById('precio_alquiler');

        if (operacion === 'venta') {
            inputVenta.required = true;
            inputAlquiler.required = false;
            inputAlquiler.value = ''; // Limpiar campo no usado
        } else {
            inputVenta.required = false;
            inputAlquiler.required = true;
            inputVenta.value = ''; // Limpiar campo no usado
        }
    }

    function limpiarRequeridos() {
        const inputs = document.querySelectorAll('.seccion-especifica input, .seccion-especifica select, .seccion-especifica textarea');
        inputs.forEach(input => input.removeAttribute('required'));
    }

    function activarRequeridos(ids) {
        ids.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.setAttribute('required', 'true');
        });
    }
</script>
</body>
</html>