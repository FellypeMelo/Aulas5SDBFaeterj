-- 19. Compare GROUP BY × OVER.

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
