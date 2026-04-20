-- =============================================================================
-- UNIDADE 5 — AULA 7: INTRODUÇÃO AO PL/SQL
-- =============================================================================

-- 1. Bloco Anônimo simples
-- Declara variável numérica, atribui 100 e exibe no console
SET SERVEROUTPUT ON;

DECLARE
    v_numero NUMBER;
BEGIN
    v_numero := 100;
    DBMS_OUTPUT.PUT_LINE('O valor da variável é: ' || v_numero);
END;
/

-- 2. Uso de %TYPE
-- Declara variável v_nome_cliente referenciando a coluna nome da tabela TB_CLIENTE
DECLARE
    v_nome_cliente tb_cliente.nome%TYPE;
BEGIN
    -- Exemplo de uso para manter o bloco funcional:
    DBMS_OUTPUT.PUT_LINE('Variável baseada em tipo declarada com sucesso.');
END;
/

-- 3. SELECT INTO: Buscar cliente por id_cliente
DECLARE
    v_id_busca      NUMBER := 1;
    v_nome_resultado tb_cliente.nome%TYPE;
BEGIN
    SELECT nome INTO v_nome_resultado 
    FROM tb_cliente 
    WHERE id_cliente = v_id_busca;
    
    DBMS_OUTPUT.PUT_LINE('Cliente encontrado (ID 1): ' || v_nome_resultado);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum cliente encontrado com o ID informado.');
END;
/

-- 4. Estrutura Condicional: IF/ELSIF/ELSE
DECLARE
    v_valor_venda NUMBER := 1250.50;
BEGIN
    IF v_valor_venda < 500 THEN
        DBMS_OUTPUT.PUT_LINE('Status da Venda: BAIXA');
    ELSIF v_valor_venda >= 500 AND v_valor_venda <= 2000 THEN
        DBMS_OUTPUT.PUT_LINE('Status da Venda: MÉDIA');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Status da Venda: ALTA');
    END IF;
END;
/

-- 5. Iteração com Loop: FOR LOOP percorrendo TB_CATEGORIA
BEGIN
    DBMS_OUTPUT.PUT_LINE('Listando todas as categorias:');
    FOR reg_cat IN (SELECT nome FROM tb_categoria) LOOP
        DBMS_OUTPUT.PUT_LINE('- Categoria: ' || reg_cat.nome);
    END LOOP;
END;
/

-- 6. Tratamento de Exceção: NO_DATA_FOUND
DECLARE
    v_id_teste NUMBER := 99999; -- ID que não existe
    v_data_venda tb_venda.dt_venda%TYPE;
BEGIN
    SELECT dt_venda INTO v_data_venda 
    FROM tb_venda 
    WHERE id_venda = v_id_teste;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: Não foi encontrada nenhuma venda para o ID ' || v_id_teste);
END;
/
