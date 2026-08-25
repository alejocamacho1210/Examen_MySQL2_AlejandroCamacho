USE reservas_salones_eventos;

CREATE TABLE auditoria_abonos (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_pago INT NOT NULL,
    fecha_movimiento DATETIME NOT NULL,
    valor_anterior DECIMAL(12,2) NULL,
    valor_nuevo DECIMAL(12,2) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_pago) REFERENCES pagos(id_pago)
        ON UPDATE CASCADE ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER auditar_abono_insert_trigger
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_abonos (id_pago, fecha_movimiento, valor_anterior, valor_nuevo, usuario)
    VALUES (NEW.id_pago, NOW(), NULL, NEW.monto, CURRENT_USER());
END $$

CREATE TRIGGER auditar_abono_update_trigger
AFTER UPDATE ON pagos
FOR EACH ROW
BEGIN
    IF OLD.monto <> NEW.monto THEN
        INSERT INTO auditoria_abonos (id_pago, fecha_movimiento, valor_anterior, valor_nuevo, usuario)
        VALUES (NEW.id_pago, NOW(), OLD.monto, NEW.monto, CURRENT_USER());
    END IF;
END $$

DELIMITER ;