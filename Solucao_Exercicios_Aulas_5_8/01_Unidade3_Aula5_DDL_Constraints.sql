-- =============================================================================
-- UNIDADE 3 — AULA 5: MODELAGEM FÍSICA E CONSTRAINTS
-- =============================================================================

-- 1. Criação de Tabela: TB_FORNECEDOR
-- Colunas: id_fornecedor (PK), nome (obrigatório) e cnpj (único)
CREATE TABLE tb_fornecedor (
    id_fornecedor NUMBER GENERATED ALWAYS AS IDENTITY,
    nome          VARCHAR2(120) NOT NULL,
    cnpj          VARCHAR2(14) NOT NULL,
    CONSTRAINT pk_tb_fornecedor PRIMARY KEY (id_fornecedor),
    CONSTRAINT uq_tb_fornecedor_cnpj UNIQUE (cnpj)
);

-- 2. Regra de Domínio: Constraint CHECK na TB_PRODUTO
-- Garantir que o preco_unit nunca seja inferior ou igual a zero
ALTER TABLE tb_produto 
ADD CONSTRAINT ck_tb_produto_preco_positivo CHECK (preco_unit > 0);

-- 3. Integridade Referencial: Foreign Key ligando TB_PRODUTO à TB_CATEGORIA
-- Garantindo que não existam produtos sem uma categoria válida
ALTER TABLE tb_produto
ADD CONSTRAINT fk_tb_produto_categoria 
FOREIGN KEY (id_categoria) REFERENCES tb_categoria (id_categoria);

-- 4. Manutenção Segura: Exemplo de ON DELETE CASCADE
-- O comando abaixo demonstra como garantir que ao remover uma venda, os itens associados sumam automaticamente.
/*
  EXPLICACAO: 
  O ON DELETE CASCADE permite que a integridade referencial seja mantida 
  removendo registros dependentes automaticamente. No exemplo de TB_VENDA e TB_VENDA_ITEM,
  se uma venda de ID 500 for excluída, todos os registros em TB_VENDA_ITEM que possuem
  id_venda = 500 também serão excluídos pelo banco de dados.
*/

-- Exemplo de aplicação (recriando a FK com a opção CASCADE):
ALTER TABLE tb_venda_item 
DROP CONSTRAINT fk_tb_item_venda;

ALTER TABLE tb_venda_item
ADD CONSTRAINT fk_tb_item_venda 
FOREIGN KEY (id_venda) REFERENCES tb_venda (id_venda) 
ON DELETE CASCADE;

-- 5. Garantia de Unicidade: Coluna sku na TB_PRODUTO
ALTER TABLE tb_produto 
ADD CONSTRAINT uq_tb_produto_sku UNIQUE (sku);
