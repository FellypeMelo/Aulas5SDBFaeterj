-- 5. Calcule o total de vendas (valor líquido) por cliente.
SELECT 
    c.nome, 
    SUM(v.valor_liquido) as total_vendas 
FROM tb_cliente c 
JOIN tb_venda v ON c.id_cliente = v.id_cliente 
GROUP BY c.id_cliente, c.nome;
