-- 3. Liste as vendas que ainda não estão com status FECHADA.
SELECT * 
FROM tb_venda 
WHERE status <> 'FECHADA';
