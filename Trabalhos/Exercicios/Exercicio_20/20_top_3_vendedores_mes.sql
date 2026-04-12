-- 20. Liste o top 3 vendedores por mês.
WITH RankingMensal AS (
    SELECT
        TRUNC(dt_venda, 'MM') AS mes,
        id_vendedor,
        SUM(valor_liquido) AS total_vendido,
        RANK() OVER (
            PARTITION BY TRUNC(dt_venda, 'MM') 
            ORDER BY SUM(valor_liquido) DESC
        ) as ranking
    FROM tb_venda
    GROUP BY TRUNC(dt_venda, 'MM'), id_vendedor
)
SELECT mes, id_vendedor, total_vendido, ranking
FROM RankingMensal
WHERE ranking <= 3
ORDER BY mes, ranking;
