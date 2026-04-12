-- 2. Liste as vendas realizadas, exibindo data da venda, nome do cliente e valor líquido.
SELECT 
    v.dt_venda, 
    c.nome AS nome_cliente, 
    v.valor_liquido 
FROM tb_venda v 
JOIN tb_cliente c ON v.id_cliente = c.id_cliente;
