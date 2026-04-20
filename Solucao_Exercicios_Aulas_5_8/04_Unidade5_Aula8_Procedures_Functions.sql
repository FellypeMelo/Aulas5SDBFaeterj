-- =============================================================================
-- UNIDADE 5 — AULA 8: PROCEDURES E FUNCTIONS
-- =============================================================================

-- 1. Criação de Function: fn_calcula_desconto
-- Recebe valor e percentual, retorna valor com desconto
CREATE OR REPLACE FUNCTION fn_calcula_desconto (
    p_valor      IN NUMBER,
    p_percentual IN NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN p_valor - (p_valor * (p_percentual / 100));
END;
/

-- 2. Lógica de Negócio Encapsulada: Função para Comissão do Vendedor
-- Regra: 3% para 'APP', 2% para demais.
CREATE OR REPLACE FUNCTION fn_calcula_comissao (
    p_id_venda IN NUMBER
) RETURN NUMBER IS
    v_canal            tb_venda.canal%TYPE;
    v_valor_liquido    tb_venda.valor_liquido%TYPE;
    v_percentual       NUMBER;
BEGIN
    SELECT canal, valor_liquido 
    INTO v_canal, v_valor_liquido
    FROM tb_venda 
    WHERE id_venda = p_id_venda;
    
    IF v_canal = 'APP' THEN
        v_percentual := 0.03;
    ELSE
        v_percentual := 0.02;
    END IF;
    
    RETURN v_valor_liquido * v_percentual;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- 3. Criação de Procedure: pr_atualiza_status_venda
-- Recebe ID e novo status, realiza o UPDATE
CREATE OR REPLACE PROCEDURE pr_atualiza_status_venda (
    p_id_venda    IN NUMBER,
    p_novo_status IN VARCHAR2
) IS
BEGIN
    UPDATE tb_venda 
    SET status = p_novo_status 
    WHERE id_venda = p_id_venda;
    
    COMMIT;
END;
/

-- 4. Parâmetros de Saída: Quantidade total já vendida de um produto
CREATE OR REPLACE PROCEDURE pr_total_vendido_produto (
    p_id_produto IN  NUMBER,
    p_quantidade OUT NUMBER
) IS
BEGIN
    SELECT SUM(quantidade) INTO p_quantidade
    FROM tb_venda_item
    WHERE id_produto = p_id_produto;
    
    -- Se não houver vendas, retornar 0 ao invés de NULL
    p_quantidade := NVL(p_quantidade, 0);
END;
/
