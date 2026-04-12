-- 11. Calcule a receita mensal total usando CTE.
WITH ReceitaMensal AS (
    SELECT 
        TRUNC(dt_venda, 'MM') AS mes, 
        SUM(valor_liquido) AS receita_total
    FROM tb_venda
    GROUP BY TRUNC(dt_venda, 'MM')
)
SELECT * 
FROM ReceitaMensal 
ORDER BY mes;
