-- =====================================================================
-- Sistema de Reservas de Salones de Eventos - Eventos Premier S.A.S.
-- Script 02: Funciones personalizadas
-- Autor: Alejandro Camacho
-- =====================================================================

USE reservas_salones_eventos;

DELIMITER $$

-- ---------------------------------------------------------------------
-- Función: calcular_total_reserva
-- Calcula el valor total de una reserva incluyendo IVA del 19%.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS calcular_total_reserva $$
CREATE FUNCTION calcular_total_reserva(
    precio_hora DECIMAL(10,2),
    horas DECIMAL(6,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE subtotal DECIMAL(12,2);
    DECLARE total_con_iva DECIMAL(12,2);

    SET subtotal = precio_hora * horas;
    SET total_con_iva = subtotal * 1.19;

    RETURN total_con_iva;
END $$

-- ---------------------------------------------------------------------
-- Función: verificar_disponibilidad
-- Retorna 1 si el salón está disponible en el rango de fechas dado,
-- 0 si ya existe una reserva activa que se cruza con ese rango.
-- ---------------------------------------------------------------------
DROP FUNCTION IF EXISTS verificar_disponibilidad $$
CREATE FUNCTION verificar_disponibilidad(
    p_salon_id INT,
    p_fecha_inicio DATETIME,
    p_fecha_fin DATETIME
)
    WHERE id_salon = p_salon_id
      AND estado_reserva = 'Activa'
      AND fecha_inicio < p_fecha_fin
      AND fecha_fin > p_fecha_inicio;

    IF cruces > 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END $$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Ejemplos de uso
-- ---------------------------------------------------------------------
-- SELECT calcular_total_reserva(50000, 4) AS total_con_iva;
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE cruces INT;

    SELECT COUNT(*) INTO cruces
    FROM reservas
-- SELECT verificar_disponibilidad(1, '2026-09-01 14:00:00', '2026-09-01 18:00:00') AS disponible;


