-- 14. Reescreva uma consulta complexa usando CTE.
-- Consulta Original (Sem CTE): Clientes com faturamento maior que 10.000
/*
SELECT c.nome, vpc.total
FROM tb_cliente c
JOIN (
    SELECT id_cliente, SUM(valor_liquido) AS total
    FROM tb_venda
    GROUP BY id_cliente
) vpc ON c.id_cliente = vpc.id_cliente
WHERE vpc.total > 10000;
*/

-- Consulta Reescrevida (Com CTE):
WITH VendasPorCliente AS (
    SELECT id_cliente, SUM(valor_liquido) AS total_gasto
    FROM tb_venda
    GROUP BY id_cliente
)
SELECT c.nome, vpc.total_gasto
FROM tb_cliente c
JOIN VendasPorCliente vpc ON c.id_cliente = vpc.id_cliente
WHERE vpc.total_gasto > 10000;
