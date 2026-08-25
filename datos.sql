-- =====================================================================
-- Sistema de Reservas de Salones de Eventos - Eventos Premier S.A.S.
-- Script 05: Datos de prueba
-- Autor: Alejandro Camacho
-- =====================================================================

USE reservas_salones_eventos;

-- ---------------------------------------------------------------------
-- Salones
-- ---------------------------------------------------------------------
INSERT INTO salones (nombre_salon, capacidad, precio_hora, estado, encargado) VALUES
('Salón Esmeralda',   80,  60000.00, 'Disponible', 'Laura Méndez'),
('Salón Rubí',        40,  40000.00, 'Disponible', 'Carlos Peña'),
('Salón Zafiro',      150, 90000.00, 'Disponible', 'Diana Ríos'),
('Salón Topacio',     30,  25000.00, 'En mantenimiento', 'Julián Torres');

-- ---------------------------------------------------------------------
-- Clientes
-- ---------------------------------------------------------------------
INSERT INTO clientes (nombre_completo, identificacion, telefono, correo, tipo_cliente) VALUES
('Constructora ABC S.A.S.', '900123456-1', '3011234567', 'contacto@abc.com', 'Corporativo'),
('María Fernanda Gómez',    '1020304050',  '3157894561', 'mafe.gomez@mail.com', 'Individual'),
('Tech Solutions Ltda.',    '900654321-2', '3209876543', 'ventas@techsol.com', 'Corporativo'),
('Andrés Felipe Ruiz',      '1098765432',  '3179988776', 'andres.ruiz@mail.com', 'Individual');

-- ---------------------------------------------------------------------
-- Reservas
-- (total_horas y valor_total se calculan automáticamente por trigger)
-- ---------------------------------------------------------------------
INSERT INTO reservas (id_cliente, id_salon, fecha_inicio, fecha_fin) VALUES
(1, 1, '2026-09-05 08:00:00', '2026-09-05 12:00:00'),
(3, 2, '2026-09-10 14:00:00', '2026-09-10 18:00:00'),
(1, 3, '2026-09-15 09:00:00', '2026-09-15 17:00:00'),
(1, 1, '2026-09-20 18:00:00', '2026-09-20 22:00:00'),
(3, 2, '2026-09-22 10:00:00', '2026-09-22 13:00:00');

-- Nota: los INSERT anteriores dejan los salones 1 y 2 en estado "Ocupado"
-- automáticamente gracias al trigger actualizar_estado_salon_trigger.

-- ---------------------------------------------------------------------
-- Pagos
-- ---------------------------------------------------------------------
INSERT INTO pagos (id_reserva, fecha_pago, monto, metodo_pago) VALUES
(1, '2026-09-04', 285600.00, 'Transferencia'),
(2, '2026-09-09', 190400.00, 'Tarjeta'),
(3, '2026-09-14', 856800.00, 'Transferencia');

-- ---------------------------------------------------------------------
-- Prueba rápida del trigger de auditoría de precios
-- ---------------------------------------------------------------------
-- UPDATE salones SET precio_hora = 65000.00 WHERE id_salon = 1;
-- SELECT * FROM auditoria_precios;