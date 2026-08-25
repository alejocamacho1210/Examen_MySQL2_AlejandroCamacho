USE reservas_salones_eventos;

DELIMITER $$

CREATE FUNCTION calcular_valor_pendiente(
    total_reserva DECIMAL(12,2),
    abono DECIMAL(12,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN total_reserva - abono;
END $$

DELIMITER ;
