-- 1. Liste todos os clientes ativos ordenados pelo nome.
SELECT * 
FROM tb_cliente 
WHERE ativo = 'S' 
ORDER BY nome;
