-- 9. Liste produtos que nunca foram vendidos.
SELECT p.* 
FROM tb_produto p 
LEFT JOIN tb_venda_item iv ON p.id_produto = iv.id_produto 
WHERE iv.id_item IS NULL;
