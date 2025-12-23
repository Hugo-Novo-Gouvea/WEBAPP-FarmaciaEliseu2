-- Script de migração PORTADO para PostgreSQL
-- Origem: Schema 'migracao_legacy' (Dados brutos do Access)
-- Destino: Schema 'public' (Tabelas oficiais do sistema)

BEGIN; -- Inicia a transação única

RAISE NOTICE 'Iniciando migração para o schema public...';

---------------------------------------------------------
-- 1. CRIAÇÃO DA SEQUENCE (PONTO 1 - CONTROLE DE VENDAS)
---------------------------------------------------------
CREATE SEQUENCE IF NOT EXISTS seq_codigo_movimento
    START WITH 1
    INCREMENT BY 1;

---------------------------------------------------------
-- 2. CRIAÇÃO DAS TABELAS (DDL)
---------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.clientes (
    clientes_id         SERIAL PRIMARY KEY, -- SERIAL cria sequence auto
    nome                VARCHAR(200) NOT NULL,
    endereco            VARCHAR(200),
    rg                  VARCHAR(30),
    cpf                 VARCHAR(30),
    telefone            VARCHAR(50),
    celular             VARCHAR(50),
    data_nascimento     DATE,
    codigo_fichario     INT,
    data_cadastro       TIMESTAMP(0),
    data_ultimo_registro TIMESTAMP(0),
    deletado            BOOLEAN
);

CREATE TABLE IF NOT EXISTS public.funcionarios (
    funcionarios_id     SERIAL PRIMARY KEY,
    nome                VARCHAR(200) NOT NULL,
    data_cadastro       TIMESTAMP(0) NOT NULL,
    data_ultimo_registro TIMESTAMP(0) NOT NULL,
    deletado            BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS public.produtos (
    produtos_id         SERIAL PRIMARY KEY,
    descricao           VARCHAR(200) NOT NULL,
    unidade_medida      VARCHAR(200),
    preco_compra        DECIMAL(19,4) NOT NULL,
    preco_venda         DECIMAL(19,4) NOT NULL,
    localizacao         VARCHAR(200),
    laboratorio         VARCHAR(200),
    principio           VARCHAR(200),
    generico            VARCHAR(3) NOT NULL,
    codigo_produto      VARCHAR(9),
    codigo_barras       VARCHAR(50) NOT NULL,
    data_cadastro       TIMESTAMP(0),
    data_ultimo_registro TIMESTAMP(0),
    deletado            BOOLEAN
);

CREATE TABLE IF NOT EXISTS public.movimentos (
    movimentos_id       SERIAL PRIMARY KEY,
    produtos_id         INT NOT NULL,
    produtos_descricao  VARCHAR(200) NOT NULL,
    produtos_codigo_produto VARCHAR(9) NOT NULL,
    clientes_id         INT NOT NULL,
    clientes_nome       VARCHAR(200) NOT NULL,
    funcionarios_id     INT NOT NULL,
    funcionarios_nome   VARCHAR(200) NOT NULL,
    quantidade          INT NOT NULL,
    preco_unitario_dia_venda DECIMAL(19,4) NOT NULL,
    preco_total_dia_venda    DECIMAL(19,4) NOT NULL,
    preco_unitario_atual     DECIMAL(19,4) NOT NULL,
    preco_total_atual        DECIMAL(19,4) NOT NULL,
    valor_pago          DECIMAL(19,4) NOT NULL,
    desconto            DECIMAL(19,4) NOT NULL,
    data_venda          TIMESTAMP(0) NOT NULL,
    data_pagamento      TIMESTAMP(0),
    codigo_movimento    INT NOT NULL DEFAULT 0, -- Campo controlado manualmente ou via trigger
    data_cadastro       TIMESTAMP(0) NOT NULL,
    data_ultimo_registro TIMESTAMP(0) NOT NULL,
    deletado            BOOLEAN NOT NULL
);

---------------------------------------------------------
-- 3. MIGRAÇÃO: CLIENTES
---------------------------------------------------------
-- Verifica se a tabela origem existe (Opcional, assumindo que você importou via DBeaver)
-- Limpeza prévia (Opcional)
-- TRUNCATE TABLE public.clientes RESTART IDENTITY CASCADE;

INSERT INTO public.clientes (clientes_id, nome, endereco, rg, cpf, telefone, celular, data_nascimento, codigo_fichario, data_cadastro, data_ultimo_registro, deletado)
VALUES (1, 'NÃO INFORMADO', 'NÃO INFORMADO', 'NÃO INFORMADO', 'NÃO INFORMADO', 'NÃO INFORMADO', 'NÃO INFORMADO', CURRENT_DATE, 0, NOW(), NOW(), FALSE);

INSERT INTO public.clientes (clientes_id, nome, endereco, rg, cpf, telefone, celular, data_nascimento, codigo_fichario, data_cadastro, data_ultimo_registro, deletado)
SELECT 
    CAST(c.codigo AS INT), 
    LEFT(COALESCE(NULLIF(TRIM(c.nome), ''), 'NÃO INFORMADO'), 200), 
    LEFT(COALESCE(NULLIF(TRIM(c.endereco), ''), 'NÃO INFORMADO'), 200), 
    LEFT(COALESCE(NULLIF(TRIM(c.rg), ''), 'NÃO INFORMADO'), 30), 
    LEFT(COALESCE(NULLIF(TRIM(c.cic), ''), 'NÃO INFORMADO'), 30), 
    LEFT(COALESCE(NULLIF(TRIM(c.fone), ''), 'NÃO INFORMADO'), 50), 
    LEFT(COALESCE(NULLIF(TRIM(c.celular), ''), 'NÃO INFORMADO'), 50), 
    CURRENT_DATE, 
    COALESCE(CAST(NULLIF(c.cod_fichario, '') AS INT), 0), -- Access as vezes traz vazio como string
    NOW(), 
    NOW(), 
    CASE WHEN UPPER(TRIM(c.situacao)) IN ('ATIVO', 'ATIVA', 'SIM', 'S', '1', 'TRUE', 'T') THEN FALSE ELSE TRUE END
FROM migracao_legacy.cliente AS c; -- NOTE O SCHEMA 'migracao_legacy'

-- Ajustar a sequence do ID para não dar erro no próximo insert manual
PERFORM setval('public.clientes_clientes_id_seq', (SELECT MAX(clientes_id) FROM public.clientes));

---------------------------------------------------------
-- 4. MIGRAÇÃO: FUNCIONARIOS
---------------------------------------------------------
INSERT INTO public.funcionarios (nome, data_cadastro, data_ultimo_registro, deletado)
SELECT 
    LEFT(COALESCE(NULLIF(TRIM(f.NOME), ''), 'NÃO INFORMADO'), 200), 
    NOW(), 
    NOW(), 
    FALSE
FROM migracao_legacy.funcionarios AS f;

---------------------------------------------------------
-- 5. MIGRAÇÃO: PRODUTOS
---------------------------------------------------------
INSERT INTO public.produtos (produtos_id, descricao, unidade_medida, preco_compra, preco_venda, localizacao, laboratorio, principio, generico, codigo_produto, codigo_barras, data_cadastro, data_ultimo_registro, deletado)
VALUES (1, 'NÃO INFORMADO', 'NÃO INFORMADO', 0, 0, '0', 'NÃO INFORMADO', 'NÃO INFORMADO', 'NAO', '0000000', 'NÃO INFORMADO', NOW(), NOW(), FALSE);

INSERT INTO public.produtos (descricao, unidade_medida, preco_compra, preco_venda, localizacao, laboratorio, principio, generico, codigo_produto, codigo_barras, data_cadastro, data_ultimo_registro, deletado)
SELECT 
    LEFT(COALESCE(NULLIF(TRIM(t.MED_DES), ''), 'NÃO INFORMADO'), 200), 
    LEFT(COALESCE(NULLIF(CAST(t.MED_UNI AS VARCHAR), ''), 'UN'), 200), 
    CAST(COALESCE(t.MED_PLA1, 0) AS DECIMAL(19,4)), 
    CAST(COALESCE(t.MED_PCO1, 0) AS DECIMAL(19,4)), 
    LEFT(COALESCE(NULLIF(TRIM(t.LOCALIZACAO), ''), 'NÃO INFORMADO'), 200), 
    LEFT(COALESCE(NULLIF(TRIM(t.LAB_NOM), ''), 'NÃO INFORMADO'), 200), 
    LEFT(COALESCE(NULLIF(TRIM(t.MED_PRINCI), ''), 'NÃO INFORMADO'), 200), 
    LEFT(COALESCE(NULLIF(TRIM(t.MED_GENE), ''), 'NA'), 3), 
    LEFT(COALESCE(NULLIF(TRIM(t.MED_ABC), ''), ''), 9), 
    LEFT(COALESCE(NULLIF(TRIM(t.MED_BARRA), ''), ''), 50), 
    NOW(), 
    NOW(), 
    FALSE
FROM migracao_legacy.tabela_medicamentos AS t
WHERE COALESCE(t.ATIVO, '1') <> '0';

---------------------------------------------------------
-- 6. MIGRAÇÃO: MOVIMENTOS
---------------------------------------------------------
INSERT INTO public.movimentos (produtos_id, produtos_descricao, produtos_codigo_produto, clientes_id, clientes_nome, funcionarios_id, funcionarios_nome, quantidade, preco_unitario_dia_venda, preco_total_dia_venda, preco_unitario_atual, preco_total_atual, valor_pago, desconto, data_venda, data_pagamento, codigo_movimento, data_cadastro, data_ultimo_registro, deletado)
SELECT 
    0, -- Placeholder, será atualizado
    LEFT(COALESCE(NULLIF(TRIM(m.descricao_produto), ''), 'NÃO INFORMADO'), 200), 
    LEFT(COALESCE(NULLIF(TRIM(m.material), ''), ''), 9), 
    CAST(m.cod_cli AS INT), 
    'NÃO INFORMADO', -- Placeholder
    0, 
    'NÃO INFORMADO', 
    COALESCE(m.qtde_movimentada, 0), 
    CAST(COALESCE(m.valor_unitario, 0) AS DECIMAL(19,4)), 
    CAST(COALESCE(m.valor_unitario, 0) * COALESCE(m.qtde_movimentada, 0) AS DECIMAL(19,4)), 
    CAST(COALESCE(m.valor_unitario, 0) AS DECIMAL(19,4)), 
    CAST(COALESCE(m.valor_unitario, 0) * COALESCE(m.qtde_movimentada, 0) AS DECIMAL(19,4)), 
    -- Lógica do CASE convertida
    CAST(CASE WHEN UPPER(TRIM(COALESCE(m.pago, 'NAO'))) IN ('SIM', 'S', '1', 'TRUE', 'T') THEN COALESCE(m.valor_unitario, 0) * COALESCE(m.qtde_movimentada, 0) ELSE 0 END AS DECIMAL(19,4)), 
    CAST(COALESCE(m.desconto, 0) AS DECIMAL(19,4)), 
    CAST(m.data_venda AS TIMESTAMP(0)), 
    CAST(m.data_pagto AS TIMESTAMP(0)), 
    CAST(COALESCE(m.codigo_movimento, 0) AS INT), 
    NOW(), 
    NOW(), 
    CAST(CASE WHEN UPPER(TRIM(COALESCE(m.pago, 'NAO'))) IN ('SIM', 'S', '1', 'TRUE', 'T') THEN TRUE ELSE FALSE END AS BOOLEAN)
FROM migracao_legacy.mov_cliente AS m;

-- Updates de Correção (Sintaxe Postgres: UPDATE ... FROM)
-- 1. Corrige Produtos
UPDATE public.movimentos m
SET produtos_id = COALESCE(p.produtos_id, 0)
FROM (
    SELECT codigo_produto, MIN(produtos_id) AS produtos_id 
    FROM public.produtos 
    GROUP BY codigo_produto
) p
WHERE p.codigo_produto = m.produtos_codigo_produto 
  AND m.produtos_id = 0;

-- 2. Corrige Nome Clientes
UPDATE public.movimentos m
SET clientes_nome = LEFT(COALESCE(NULLIF(TRIM(c.nome), ''), 'NÃO INFORMADO'), 200)
FROM public.clientes c
WHERE c.clientes_id = m.clientes_id;

---------------------------------------------------------
-- 7. SINCRONIZAÇÃO DA SEQUENCE DE MOVIMENTOS
---------------------------------------------------------
-- Em Postgres usamos setval
PERFORM setval('seq_codigo_movimento', (SELECT COALESCE(MAX(codigo_movimento), 0) + 1 FROM public.movimentos));

COMMIT; -- Efetiva tudo
RAISE NOTICE 'Migração para PostgreSQL concluída com sucesso.';