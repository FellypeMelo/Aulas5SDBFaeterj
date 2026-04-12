-- 4. Liste todos os clientes que não possuem vendas registradas.
SELECT c.* 
FROM tb_cliente c 
LEFT JOIN tb_venda v ON c.id_cliente = v.id_cliente 
WHERE v.id_venda IS NULL;
