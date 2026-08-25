USE reservas_salones_eventos;

SELECT c.nombre_completo AS cliente,
    r.fecha_inicio AS fecha_reserva,
    r.valor_total AS total,
    COALESCE(SUM(p.monto), 0) AS abono,
    calcular_valor_pendiente(r.valor_total, COALESCE(SUM(p.monto), 0)) AS valor_pendiente
FROM reservas r
JOIN clientes c ON r.id_cliente = c.id_cliente
LEFT JOIN pagos p ON p.id_reserva = r.id_reserva
GROUP BY r.id_reserva, c.nombre_completo, r.fecha_inicio, r.valor_total
HAVING valor_pendiente > 0
ORDER BY r.fecha_inicio;