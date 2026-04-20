-- =============================================================================
-- UNIDADE 4 — AULA 6: VIEWS (ABSTRAÇÃO E SEGURANÇA)
-- =============================================================================

-- 1. View Operacional: v_vendas_detalhadas
-- Une as tabelas de venda, cliente e vendedor
CREATE OR REPLACE VIEW v_vendas_detalhadas AS
SELECT 
    v.id_venda, 
    v.dt_venda, 
    c.nome  AS nome_cliente, 
    ven.nome AS nome_vendedor
FROM tb_venda v
JOIN tb_cliente c   ON v.id_cliente = c.id_cliente
JOIN tb_vendedor ven ON v.id_vendedor = ven.id_vendedor;

-- 2. Camada de Segurança: v_cliente_restrito
-- Exibe apenas id_cliente, nome e email (oculta CPF/Telefone)
CREATE OR REPLACE VIEW v_cliente_restrito AS
SELECT 
    id_cliente, 
    nome, 
    email
FROM tb_cliente;

-- 3. View Analítica: Faturamento total por mês e categoria do produto
CREATE OR REPLACE VIEW v_faturamento_mensal_categoria AS
SELECT 
    TO_CHAR(v.dt_venda, 'YYYY-MM') AS mes,
    cat.nome AS categoria,
    SUM(v.valor_liquido) AS faturamento_total
FROM tb_venda v
JOIN tb_venda_item vi ON v.id_venda = vi.id_venda
JOIN tb_produto p     ON vi.id_produto = p.id_produto
JOIN tb_categoria cat  ON p.id_categoria = cat.id_categoria
GROUP BY TO_CHAR(v.dt_venda, 'YYYY-MM'), cat.nome;

-- 4. Filtro em View: Consulta na view v_vendas_resumo
-- Retorna vendas pelo canal 'APP' com valor superior a R$ 500,00
SELECT * 
FROM v_vendas_resumo
WHERE canal = 'APP' 
  AND valor_liquido > 500;

-- 5. Manutenção de Contrato: Por que usar views no Oracle APEX?
/*
  RESPOSTA: 
  Utilizar views no Oracle APEX (ou qualquer aplicação) é uma boa prática de 
  "Encapsulamento de Esquema". A view funciona como uma camada de abstração (contrato).
  Se as tabelas físicas forem alteradas futuramente (ex: renomear colunas, normalização),
  você só precisa ajustar a definição da View no banco de dados, sem precisar
  alterar o código SQL em dezenas de páginas da aplicação front-end.
*/
