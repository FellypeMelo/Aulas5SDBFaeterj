-- =============================================================================
-- LISTA DE EXERCÍCIOS: AULAS 5 A 8 (SQL E PL/SQL)
-- RESOLUÇÃO COMPLETA
-- =============================================================================

-- =============================================================================
-- UNIDADE 3 — AULA 5: MODELAGEM FÍSICA E CONSTRAINTS
-- =============================================================================

-- 1. Criação de Tabela: Comando DDL para TB_FORNECEDOR
CREATE TABLE tb_fornecedor (
  id_fornecedor NUMBER GENERATED ALWAYS AS IDENTITY,
  nome          VARCHAR2(120) NOT NULL,
  cnpj          VARCHAR2(14) NOT NULL,
  CONSTRAINT pk_tb_fornecedor PRIMARY KEY (id_fornecedor),
  CONSTRAINT uq_tb_fornecedor_cnpj UNIQUE (cnpj)
);

-- 2. Regra de Domínio: Constraint CHECK na TB_PRODUTO
-- (Se a tabela já existir, usamos ALTER TABLE)
ALTER TABLE tb_produto 
ADD CONSTRAINT ck_tb_produto_preco_positivo CHECK (preco_unit > 0);

-- 3. Integridade Referencial: FK na TB_PRODUTO para TB_CATEGORIA
ALTER TABLE tb_produto
ADD CONSTRAINT fk_tb_produto_categoria 
FOREIGN KEY (id_categoria) REFERENCES tb_categoria (id_categoria);

-- 4. Manutenção Segura: Exemplo de ON DELETE CASCADE
-- O CASCADE garante que, ao excluir uma venda, todos os seus itens sejam removidos automaticamente.
-- Exemplo de definição na criação ou alteração:
/*
ALTER TABLE tb_venda_item
DROP CONSTRAINT fk_tb_item_venda;

ALTER TABLE tb_venda_item
ADD CONSTRAINT fk_tb_item_venda 
FOREIGN KEY (id_venda) REFERENCES tb_venda (id_venda) 
ON DELETE CASCADE;
*/
-- Exemplo de uso:
-- DELETE FROM tb_venda WHERE id_venda = 10; -- Removerá automaticamente os itens associados em tb_venda_item.

-- 5. Garantia de Unicidade: Coluna sku única na TB_PRODUTO
ALTER TABLE tb_produto 
ADD CONSTRAINT uq_tb_produto_sku UNIQUE (sku);


-- =============================================================================
-- UNIDADE 4 — AULA 6: VIEWS (ABSTRAÇÃO E SEGURANÇA)
-- =============================================================================

-- 1. View Operacional: v_vendas_detalhadas
CREATE OR REPLACE VIEW v_vendas_detalhadas AS
SELECT 
    v.id_venda, 
    v.dt_venda, 
    c.nome AS cliente_nome, 
    ven.nome AS vendedor_nome
FROM tb_venda v
JOIN tb_cliente c ON v.id_cliente = c.id_cliente
JOIN tb_vendedor ven ON v.id_vendedor = ven.id_vendedor;

-- 2. Camada de Segurança: v_cliente_restrito
CREATE OR REPLACE VIEW v_cliente_restrito AS
SELECT 
    id_cliente, 
    nome, 
    email
FROM tb_cliente;

-- 3. View Analítica: Faturamento total por mês e categoria
CREATE OR REPLACE VIEW v_faturamento_mensal_categoria AS
SELECT 
    TO_CHAR(v.dt_venda, 'YYYY-MM') AS mes,
    cat.nome AS categoria,
    SUM(v.valor_liquido) AS faturamento_total
FROM tb_venda v
JOIN tb_venda_item vi ON v.id_venda = vi.id_venda
JOIN tb_produto p ON vi.id_produto = p.id_produto
JOIN tb_categoria cat ON p.id_categoria = cat.id_categoria
GROUP BY TO_CHAR(v.dt_venda, 'YYYY-MM'), cat.nome;

-- 4. Filtro em View: Consulta na v_vendas_resumo
SELECT * 
FROM v_vendas_resumo
WHERE canal = 'APP' 
AND valor_liquido > 500;

-- 5. Manutenção de Contrato: Por que usar views no Oracle APEX?
/*
É uma boa prática porque a View funciona como um "contrato" entre o banco de dados e a aplicação front-end.
Se a estrutura das tabelas físicas mudar (ex: renomear colunas, normalização), basta ajustar a View sem precisar
alterar as queries dentro das páginas do APEX, garantindo isolamento e facilitando a manutenção.
*/


-- =============================================================================
-- UNIDADE 5 — AULA 7: INTRODUÇÃO AO PL/SQL
-- =============================================================================

-- 1. Bloco Anônimo simples
SET SERVEROUTPUT ON;
DECLARE
    v_valor NUMBER;
BEGIN
    v_valor := 100;
    DBMS_OUTPUT.PUT_LINE('O valor da variável é: ' || v_valor);
END;
/

-- 2. Uso de %TYPE
DECLARE
    v_nome_cliente tb_cliente.nome%TYPE;
BEGIN
    NULL; -- Apenas declaração conforme pedido
END;
/

-- 3. SELECT INTO: Buscar nome do cliente por ID
DECLARE
    v_nome_cliente tb_cliente.nome%TYPE;
    v_id_busca NUMBER := 1;
BEGIN
    SELECT nome INTO v_nome_cliente 
    FROM tb_cliente 
    WHERE id_cliente = v_id_busca;
    
    DBMS_OUTPUT.PUT_LINE('Cliente encontrado: ' || v_nome_cliente);
END;
/

-- 4. Estrutura Condicional: Classificação de Venda
DECLARE
    v_valor_venda NUMBER := 1500;
BEGIN
    IF v_valor_venda < 500 THEN
        DBMS_OUTPUT.PUT_LINE('Classificação: BAIXA');
    ELSIF v_valor_venda <= 2000 THEN
        DBMS_OUTPUT.PUT_LINE('Classificação: MÉDIA');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Classificação: ALTA');
    END IF;
END;
/

-- 5. Iteração com Loop: Exibir nomes das categorias
BEGIN
    FOR r_cat IN (SELECT nome FROM tb_categoria) LOOP
        DBMS_OUTPUT.PUT_LINE('Categoria: ' || r_cat.nome);
    END LOOP;
END;
/

-- 6. Tratamento de Exceção: NO_DATA_FOUND
DECLARE
    v_id_venda tb_venda.id_venda%TYPE;
BEGIN
    -- Tentando buscar um ID que provavelmente não existe
    SELECT id_venda INTO v_id_venda 
    FROM tb_venda 
    WHERE id_venda = -99;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Venda não encontrada no sistema.');
END;
/


-- =============================================================================
-- UNIDADE 5 — AULA 8: PROCEDURES E FUNCTIONS
-- =============================================================================

-- 1. Criação de Function: fn_calcula_desconto
CREATE OR REPLACE FUNCTION fn_calcula_desconto (
    p_valor      IN NUMBER,
    p_percentual IN NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN p_valor * (1 - (p_percentual / 100));
END;
/

-- 2. Lógica de Negócio Encapsulada: Comissão do Vendedor
CREATE OR REPLACE FUNCTION fn_calcular_comissao (
    p_id_venda IN NUMBER
) RETURN NUMBER IS
    v_canal VARCHAR2(20);
    v_valor_liquido NUMBER;
    v_comissao NUMBER;
BEGIN
    SELECT canal, valor_liquido 
    INTO v_canal, v_valor_liquido
    FROM tb_venda
    WHERE id_venda = p_id_venda;

    IF v_canal = 'APP' THEN
        v_comissao := v_valor_liquido * 0.03;
    ELSE
        v_comissao := v_valor_liquido * 0.02;
    END IF;

    RETURN v_comissao;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
END;
/

-- 3. Criação de Procedure: pr_atualiza_status_venda
CREATE OR REPLACE PROCEDURE pr_atualiza_status_venda (
    p_id_venda   IN NUMBER,
    p_novo_status IN VARCHAR2
) IS
BEGIN
    UPDATE tb_venda
    SET status = p_novo_status
    WHERE id_venda = p_id_venda;
    
    COMMIT;
END;
/

-- 4. Parâmetros de Saída: Busca dados do Cliente (Completa o exercício)
CREATE OR REPLACE PROCEDURE pr_busca_dados_cliente (
    p_id_cliente IN  NUMBER,
    p_nome       OUT VARCHAR2,
    p_email      OUT VARCHAR2
) IS
BEGIN
    SELECT nome, email 
    INTO p_nome, p_email
    FROM tb_cliente
    WHERE id_cliente = p_id_cliente;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_nome := 'NÃO ENCONTRADO';
        p_email := NULL;
END;
/
