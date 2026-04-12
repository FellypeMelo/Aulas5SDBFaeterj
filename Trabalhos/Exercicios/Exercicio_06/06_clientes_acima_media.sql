-- 6. Liste clientes que possuem vendas acima da média geral.
SELECT DISTINCT c.nome
FROM tb_cliente c
JOIN tb_venda v ON c.id_cliente = v.id_cliente
WHERE v.valor_liquido > (
    SELECT AVG(valor_liquido) 
    FROM tb_venda
);
