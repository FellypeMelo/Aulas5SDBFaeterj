-- 12. Liste o mês com maior faturamento.
SELECT 
    TRUNC(dt_venda, 'MM') AS mes, 
    SUM(valor_liquido) AS faturamento
FROM tb_venda
GROUP BY TRUNC(dt_venda, 'MM')
ORDER BY faturamento DESC
FETCH FIRST 1 ROWS ONLY;
