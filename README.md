# Sistema de Reservas de Salones de Eventos - Eventos Premier S.A.S.

**Autor:** Alejandro Camacho

## Descripción del proyecto

Base de datos en MySQL para digitalizar el manejo de reservas de salones de la empresa Eventos Premier S.A.S. El sistema permite registrar salones, clientes, reservas y pagos, controlando automáticamente la disponibilidad de cada salón y dejando trazabilidad de los cambios de precio mediante una tabla de auditoría.

El modelo incluye:

- 5 tablas relacionadas mediante llaves foráneas: `salones`, `clientes`, `reservas`, `pagos` y `auditoria_precios`.
- 2 funciones para calcular el valor de una reserva (con IVA) y verificar disponibilidad de un salón en un rango de fechas.
- 3 triggers para mantener el estado de los salones sincronizado con las reservas y auditar los cambios de precio, además de un cuarto trigger que calcula automáticamente el total de horas y el valor de cada reserva al insertarla.
- 1 vista con el resumen de reservas y 3 consultas de negocio solicitadas.

## Estructura del repositorio

```
RESERVAS_SALONES_ALEJANDROCAMACHO/
├── tablas.sql   -> Base de datos, tablas, llaves foráneas e índices
├── funciones.sql            -> Funciones (calcular_total_reserva, verificar_disponibilidad)
├── triggers.sql             -> Triggers de control y auditoría
├── consultas.sql     -> Vista vista_resumen_reservas y consultas de negocio
├── datos.sql         -> Datos de ejemplo para probar el sistema
└── README.md
```

## Instrucciones de ejecución

Requisitos: MySQL 8.0 o superior (probado en MySQL 8.0.46).

1. Clonar el repositorio y ubicarse en la carpeta del proyecto.
2. Ejecutar los scripts **en este orden exacto** desde la terminal:

```bash
mysql -u tu_usuario -p < 01_creacion_bd_tablas.sql
mysql -u tu_usuario -p < 02_funciones.sql
mysql -u tu_usuario -p < 03_triggers.sql
mysql -u tu_usuario -p < 04_vistas_consultas.sql
mysql -u tu_usuario -p < 05_datos_prueba.sql   # opcional, solo para probar
```

O bien, abrir cada archivo en MySQL Workbench y ejecutarlo en el mismo orden.

El orden importa porque las funciones se usan dentro de los triggers, y los triggers dependen de que las tablas ya existan.

## Ejemplos de uso

### Funciones

```sql
-- Calcular el valor total de una reserva de 4 horas a $50.000/hora (incluye IVA 19%)
SELECT calcular_total_reserva(50000, 4) AS total_con_iva;
-- Resultado: 238000.00

-- Verificar si el salón 1 está disponible en un horario específico
SELECT verificar_disponibilidad(1, '2026-09-05 09:00:00', '2026-09-05 10:00:00') AS disponible;
-- Resultado: 0 (ya está ocupado en ese rango)
```

### Triggers

- Al insertar una fila en `reservas`, el trigger `calcular_reserva_trigger` calcula `total_horas` y `valor_total` automáticamente, y `actualizar_estado_salon_trigger` cambia el salón a `Ocupado`.
- Al eliminar una reserva, `liberar_salon_trigger` regresa el salón a `Disponible`.
- Al actualizar el `precio_hora` de un salón, `auditoria_precios_trigger` registra el cambio:

```sql
UPDATE salones SET precio_hora = 65000.00 WHERE id_salon = 1;
SELECT * FROM auditoria_precios;
```

### Consultas y vista

```sql
-- Resumen de todas las reservas
SELECT * FROM vista_resumen_reservas;

-- Reservas en un rango de fechas
SELECT * FROM reservas WHERE fecha_inicio BETWEEN '2026-09-01' AND '2026-09-30';

-- Salones disponibles con capacidad mayor a 50 personas
SELECT * FROM salones WHERE capacidad > 50 AND estado = 'Disponible';

-- Clientes corporativos con más de 3 reservas
SELECT c.nombre_completo, COUNT(*) AS total_reservas
FROM clientes c
JOIN reservas r ON r.id_cliente = c.id_cliente
WHERE c.tipo_cliente = 'Corporativo'
GROUP BY c.id_cliente
HAVING total_reservas > 3;
```