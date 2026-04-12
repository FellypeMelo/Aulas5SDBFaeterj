-- 10. Liste vendas realizadas via APP ou SITE.
SELECT * 
FROM tb_venda 
WHERE canal IN ('APP', 'SITE');
