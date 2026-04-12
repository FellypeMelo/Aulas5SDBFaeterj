-- 13. Liste clientes com faturamento acima de R$ 5.000.
SELECT 
    c.nome, 
    SUM(v.valor_liquido) AS faturamento_total
FROM tb_cliente c
JOIN tb_venda v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING SUM(v.valor_liquido) > 5000;
