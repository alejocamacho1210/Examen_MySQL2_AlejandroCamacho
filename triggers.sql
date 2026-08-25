-- =====================================================================
-- Sistema de Reservas de Salones de Eventos - Eventos Premier S.A.S.
-- Script 03: Triggers de control y auditoría
-- Autor: Alejandro Camacho
-- =====================================================================

USE reservas_salones_eventos;

DELIMITER $$

-- ---------------------------------------------------------------------
-- Trigger: calcular_reserva_trigger
-- Antes de insertar una reserva, calcula automáticamente el total
-- de horas y el valor total (con IVA) usando el precio del salón.
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS calcular_reserva_trigger $$
CREATE TRIGGER calcular_reserva_trigger
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE v_precio_hora DECIMAL(10,2);

    SELECT precio_hora INTO v_precio_hora
    FROM salones
    WHERE id_salon = NEW.id_salon;

    SET NEW.total_horas = TIMESTAMPDIFF(MINUTE, NEW.fecha_inicio, NEW.fecha_fin) / 60;
    SET NEW.valor_total = calcular_total_reserva(v_precio_hora, NEW.total_horas);
END $$

-- ---------------------------------------------------------------------
-- Trigger: actualizar_estado_salon_trigger
-- Al registrar una nueva reserva, el salón pasa a estado "Ocupado".
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS actualizar_estado_salon_trigger $$
CREATE TRIGGER actualizar_estado_salon_trigger
AFTER INSERT ON reservas
FOR EACH ROW
BEGIN
    IF NEW.estado_reserva = 'Activa' THEN
        UPDATE salones
        SET estado = 'Ocupado'
        WHERE id_salon = NEW.id_salon
          AND estado = 'Disponible';
    END IF;
END $$

-- ---------------------------------------------------------------------
-- Trigger: liberar_salon_trigger
-- Al eliminar una reserva, el salón vuelve a estado "Disponible".
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS liberar_salon_trigger $$
CREATE TRIGGER liberar_salon_trigger
AFTER DELETE ON reservas
FOR EACH ROW
BEGIN
    UPDATE salones
    SET estado = 'Disponible'
    WHERE id_salon = OLD.id_salon
      AND estado = 'Ocupado';
END $$

-- ---------------------------------------------------------------------
-- Trigger: auditoria_precios_trigger
-- Cuando se actualiza el precio por hora de un salón, registra el
-- cambio en la tabla auditoria_precios (usuario, fecha, valor anterior/nuevo).
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS auditoria_precios_trigger $$
CREATE TRIGGER auditoria_precios_trigger
BEFORE UPDATE ON salones
FOR EACH ROW
BEGIN
    IF OLD.precio_hora <> NEW.precio_hora THEN
        INSERT INTO auditoria_precios (id_salon, usuario, fecha_cambio, precio_anterior, precio_nuevo)
        VALUES (OLD.id_salon, CURRENT_USER(), NOW(), OLD.precio_hora, NEW.precio_hora);
    END IF;
END $$

DELIMITER ;

