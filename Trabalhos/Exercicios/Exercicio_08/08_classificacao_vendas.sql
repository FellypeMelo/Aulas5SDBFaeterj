-- 8. Classifique as vendas em Baixa, Média ou Alta com base no valor líquido.
SELECT 
    id_venda, 
    valor_liquido,
    CASE
        WHEN valor_liquido < 1000 THEN 'Baixa'
        WHEN valor_liquido BETWEEN 1000 AND 5000 THEN 'Média'
        ELSE 'Alta'
    END AS classificacao
FROM tb_venda;
