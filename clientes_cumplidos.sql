USE reservas_salones_eventos;

SELECT c.id_cliente, c.nombre_completo, COUNT(*) AS reservas_completadas
FROM clientes c
JOIN reservas r ON r.id_cliente = c.id_cliente
JOIN (
    SELECT id_reserva, SUM(monto) AS total_pagado
    FROM pagos
    GROUP BY id_reserva
) pg ON pg.id_reserva = r.id_reserva
WHERE pg.total_pagado >= r.valor_total
GROUP BY c.id_cliente, c.nombre_completo
ORDER BY reservas_completadas DESC
LIMIT 3;