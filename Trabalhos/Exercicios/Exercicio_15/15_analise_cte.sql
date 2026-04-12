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
   - No Oracle 12c em diante (e 23ai), o otimizador tenta inline as views dentro ou fora de CTEs equivalentemente pra otimização ótima. Você mesmo assim consegue injetar metadados como comando /*+ MATERIALIZE */ do Oracle se precisar isolar resultados.
*/
