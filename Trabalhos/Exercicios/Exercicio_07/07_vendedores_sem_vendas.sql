-- 7. Liste vendedores que não realizaram vendas.
SELECT vd.* 
FROM tb_vendedor vd 
LEFT JOIN tb_venda v ON vd.id_vendedor = v.id_vendedor 
WHERE v.id_venda IS NULL;
