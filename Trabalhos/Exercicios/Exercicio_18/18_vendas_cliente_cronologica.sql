-- 18. Numere as vendas de cada cliente por ordem cronológica.
SELECT
    id_cliente,
    id_venda AS venda_id,
    dt_venda,
    ROW_NUMBER() OVER (
        PARTITION BY id_cliente 
        ORDER BY dt_venda ASC
    ) AS numero_venda
FROM tb_venda
ORDER BY id_cliente, dt_venda;
