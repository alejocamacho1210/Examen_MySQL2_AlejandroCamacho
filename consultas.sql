-- =====================================================================
-- Sistema de Reservas de Salones de Eventos - Eventos Premier S.A.S.
-- Script 04: Vistas y consultas SQL
-- Autor: Alejandro Camacho
-- =====================================================================

USE reservas_salones_eventos;

-- ---------------------------------------------------------------------
-- Vista: vista_resumen_reservas
-- Nombre del cliente, nombre del salón, fecha inicio, fecha fin,
-- valor total y estado de la reserva.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW vista_resumen_reservas AS
SELECT
    r.id_reserva,
    c.nombre_completo AS cliente,
    s.nombre_salon    AS salon,
    r.fecha_inicio,
    r.fecha_fin,
    r.valor_total,
    r.estado_reserva  AS estado
FROM reservas r
INNER JOIN clientes c ON r.id_cliente = c.id_cliente
INNER JOIN salones s  ON r.id_salon   = s.id_salon;

-- SELECT * FROM vista_resumen_reservas;


-- ---------------------------------------------------------------------
-- Consulta 1: Reservas realizadas en un rango de fechas (BETWEEN)
-- ---------------------------------------------------------------------
SELECT
    r.id_reserva,
    c.nombre_completo AS cliente,
    s.nombre_salon    AS salon,
    r.fecha_inicio,
    r.fecha_fin,
    r.valor_total
FROM reservas r
INNER JOIN clientes c ON r.id_cliente = c.id_cliente
INNER JOIN salones s  ON r.id_salon   = s.id_salon
WHERE r.fecha_inicio BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59'
ORDER BY r.fecha_inicio;


-- ---------------------------------------------------------------------
-- Consulta 2: Salones con capacidad mayor a X personas y disponibles
-- ---------------------------------------------------------------------
SELECT
    id_salon,
    nombre_salon,
    capacidad,
    precio_hora,
    estado
FROM salones
WHERE capacidad > 50
  AND estado = 'Disponible'
ORDER BY capacidad DESC;


-- ---------------------------------------------------------------------
-- Consulta 3: Clientes corporativos con más de 3 reservas
-- (usando subconsulta con COUNT)
-- ---------------------------------------------------------------------
SELECT
    c.id_cliente,
    c.nombre_completo,
    c.tipo_cliente,
    (SELECT COUNT(*) FROM reservas r WHERE r.id_cliente = c.id_cliente) AS total_reservas
FROM clientes c
WHERE c.tipo_cliente = 'Corporativo'
  AND (SELECT COUNT(*) FROM reservas r WHERE r.id_cliente = c.id_cliente) > 3
ORDER BY total_reservas DESC;