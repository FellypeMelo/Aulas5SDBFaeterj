-- ############################################################
-- CONSOLIDAÇÃO DE EXERCÍCIOS SQL - BANCO DE DADOS
-- ############################################################

-- 1. Liste todos os clientes ativos ordenados pelo nome.
SELECT * 
FROM tb_cliente 
WHERE ativo = 'S' 
ORDER BY nome;

-- 2. Liste as vendas realizadas, exibindo data da venda, nome do cliente e valor líquido.
SELECT 
    v.dt_venda, 
    c.nome AS nome_cliente, 
    v.valor_liquido 
FROM tb_venda v 
JOIN tb_cliente c ON v.id_cliente = c.id_cliente;

-- 3. Liste as vendas que ainda não estão com status FECHADA.
SELECT * 
FROM tb_venda 
WHERE status <> 'FECHADA';

-- 4. Liste todos os clientes que não possuem vendas registradas.
SELECT c.* 
FROM tb_cliente c 
LEFT JOIN tb_venda v ON c.id_cliente = v.id_cliente 
WHERE v.id_venda IS NULL;

-- 5. Calcule o total de vendas (valor líquido) por cliente.
SELECT 
    c.nome, 
    SUM(v.valor_liquido) as total_vendas 
FROM tb_cliente c 
JOIN tb_venda v ON c.id_cliente = v.id_cliente 
GROUP BY c.id_cliente, c.nome;

-- 6. Liste clientes que possuem vendas acima da média geral.
SELECT DISTINCT c.nome
FROM tb_cliente c
JOIN tb_venda v ON c.id_cliente = v.id_cliente
WHERE v.valor_liquido > (
    SELECT AVG(valor_liquido) 
    FROM tb_venda
);

-- 7. Liste vendedores que não realizaram vendas.
SELECT vd.* 
FROM tb_vendedor vd 
LEFT JOIN tb_venda v ON vd.id_vendedor = v.id_vendedor 
WHERE v.id_venda IS NULL;

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

-- 9. Liste produtos que nunca foram vendidos.
SELECT p.* 
FROM tb_produto p 
LEFT JOIN tb_venda_item iv ON p.id_produto = iv.id_produto 
WHERE iv.id_item IS NULL;

-- 10. Liste vendas realizadas via APP ou SITE.
SELECT * 
FROM tb_venda 
WHERE canal IN ('APP', 'SITE');

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

-- 12. Liste o mês com maior faturamento.
SELECT 
    TRUNC(dt_venda, 'MM') AS mes, 
    SUM(valor_liquido) AS faturamento
FROM tb_venda
GROUP BY TRUNC(dt_venda, 'MM')
ORDER BY faturamento DESC
FETCH FIRST 1 ROWS ONLY;

-- 13. Liste clientes com faturamento acima de R$ 5.000.
SELECT 
    c.nome, 
    SUM(v.valor_liquido) AS faturamento_total
FROM tb_cliente c
JOIN tb_venda v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING SUM(v.valor_liquido) > 5000;

-- 14. Reescreva uma consulta complexa usando CTE.
-- Consulta Reescrevida (Com CTE):
WITH VendasPorCliente AS (
    SELECT id_cliente, SUM(valor_liquido) AS total_gasto
    FROM tb_venda
    GROUP BY id_cliente
)
SELECT c.nome, vpc.total_gasto
FROM tb_cliente c
JOIN VendasPorCliente vpc ON c.id_cliente = vpc.id_cliente
WHERE vpc.total_gasto > 10000;

-- 15. Compare uma consulta com e sem CTE (análise textual).

/*
ANÁLISE: CTE (Common Table Expression) vs Subquery (Sem CTE) no Oracle

1. Legibilidade e Manutenção:
   - Com CTE: O código é lido de cima para baixo. Declaramos primeiro o "bloco de construção" (a CTE) e depois o usamos na consulta principal. Muito mais fácil de ler e dar manutenção.
   - Sem CTE (Subquery no FROM): O código pode se tornar um "spaghetti", especialmente se houver múltiplos níveis de aninhamento. Você tem que ler de dentro para fora, dificultando a interpretação.

2. Reusabilidade:
   - Com CTE: Uma CTE pode ser referenciada múltiplas vezes na mesma consulta principal (ex: fazer self-joins na CTE, útil em Views Complexas no Oracle).
   - Sem CTE: A subquery teria que ser repetida por completo a cada vez que fosse necessária gerando duplicação de lógica.

3. Recursividade:
   - Com CTE: Permite a criação de CTEs recursivas, excelentes para estruturas de árvore/hierárquicas (Apesar de o Oracle também ter o tradicional START WITH ... CONNECT BY, a CTE Recursive é o padrão ANSI moderno).
   - Sem CTE: Impossível de fazer no SQL base ANSI com formatação limpa sem loops (tirando a clausula nativa CONNECT BY do Oracle).

4. Performance:
   - No Oracle 12c em diante (e 23ai), o otimizador tenta inline as views dentro ou fora de CTEs equivalentemente pra otimização ótima. Você mesmo assim consegue injetar metadados como o hint MATERIALIZE do Oracle se precisar isolar resultados.
*/

-- 16. Gere ranking mensal de vendedores.
SELECT
    TRUNC(dt_venda, 'MM') AS mes,
    id_vendedor,
    SUM(valor_liquido) AS total_vendido,
    RANK() OVER (
        PARTITION BY TRUNC(dt_venda, 'MM') 
        ORDER BY SUM(valor_liquido) DESC
    ) as ranking
FROM tb_venda
GROUP BY TRUNC(dt_venda, 'MM'), id_vendedor;

-- 17. Liste o vendedor líder de cada mês.
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
SELECT mes, id_vendedor, total_vendido
FROM RankingMensal
WHERE ranking = 1;

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

-- 19. Compare GROUP BY vs OVER (Window Functions).

/*
ANÁLISE: GROUP BY vs Cláusula OVER (Window Functions) no Oracle 23ai

1. Granularidade do Resultado:
   - GROUP BY: Agrupa as linhas da tabela (e.g. `tb_venda`) e retorna apenas UMA linha por grupo criado (redução dimensional). O nível de detalhe original da tabela é substituído pelo nível de agregação.
   - OVER (Window Function): Retorna TODAS as linhas originais da consulta e acrescenta a elas uma ou mais colunas computadas (como média, ranking, proporção, utilizando `RANK()`, `ROW_NUMBER()`, etc.) relativas a uma "janela" ou partição de linhas. Em suma, o OVER não reduz as dimensões.

2. Contexto Funcional:
   - GROUP BY: Desenvolvido explicitamente para resumir informações, produzindo relatórios sintéticos (ex: Total de Faturamento Mensal por Cliente/Vendedor).
   - OVER: Desenvolvido para operações de análise inter e intra-registro, onde uma linha isolada carece de cálculos mensurados ao longo do seu grupo (ex: Calcular o % de contribuição do faturamento desta Venda isolada para com o faturamento do mesmo Mês, ou pegar a data da última compra com um `LAG`).

3. Localização na Query:
   - GROUP BY: É uma cláusula isolada no corpo final da query, que atua na formatação final do dataset daquela query após restrições `WHERE`.
   - OVER: Age como invocação direta em cada escopo de uma função em nivel de coluna individual no select (`SUM(x) OVER(...)`).
*/

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
