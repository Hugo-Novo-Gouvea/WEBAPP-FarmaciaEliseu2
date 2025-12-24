-- ============================================================================
-- SCRIPT DE MIGRAÇÃO CORRIGIDO (V3 - Correção da Sequence de Produtos)
-- ============================================================================

-- 1. ESTRUTURA (DDL)
CREATE SEQUENCE IF NOT EXISTS seq_codigo_movimento START WITH 1 INCREMENT BY 1;

CREATE TABLE IF NOT EXISTS public.clientes (
    clientes_id         SERIAL PRIMARY KEY,
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
    codigo_movimento    INT NOT NULL DEFAULT 0,
    data_cadastro       TIMESTAMP(0) NOT NULL,
    data_ultimo_registro TIMESTAMP(0) NOT NULL,
    deletado            BOOLEAN NOT NULL
);

-- 2. MIGRAÇÃO DE DADOS (PL/pgSQL)

DO $$
DECLARE
    v_max_cod INT;
BEGIN
    RAISE NOTICE 'Iniciando migração de dados...';

    -- -------------------------------------------------------
    -- MIGRAÇÃO: CLIENTES
    -- -------------------------------------------------------
    IF NOT EXISTS (SELECT 1 FROM public.clientes) THEN
        RAISE NOTICE 'Migrando Clientes...';
        
        INSERT INTO public.clientes (clientes_id, nome, endereco, rg, cpf, telefone, celular, data_nascimento, codigo_fichario, data_cadastro, data_ultimo_registro, deletado)
        VALUES (1, 'NÃO INFORMADO', 'NÃO INFORMADO', 'NÃO INFORMADO', 'NÃO INFORMADO', 'NÃO INFORMADO', 'NÃO INFORMADO', CURRENT_DATE, 0, NOW(), NOW(), FALSE);

        INSERT INTO public.clientes (clientes_id, nome, endereco, rg, cpf, telefone, celular, data_nascimento, codigo_fichario, data_cadastro, data_ultimo_registro, deletado)
        SELECT 
            CAST(c.codigo AS INT), 
            LEFT(COALESCE(NULLIF(TRIM(c.nome::TEXT), ''), 'NÃO INFORMADO'), 200), 
            LEFT(COALESCE(NULLIF(TRIM(c.endereco::TEXT), ''), 'NÃO INFORMADO'), 200), 
            LEFT(COALESCE(NULLIF(TRIM(c.rg::TEXT), ''), 'NÃO INFORMADO'), 30), 
            LEFT(COALESCE(NULLIF(TRIM(c.cic::TEXT), ''), 'NÃO INFORMADO'), 30), 
            LEFT(COALESCE(NULLIF(TRIM(c.fone::TEXT), ''), 'NÃO INFORMADO'), 50), 
            LEFT(COALESCE(NULLIF(TRIM(c.celular::TEXT), ''), 'NÃO INFORMADO'), 50), 
            CURRENT_DATE, 
            COALESCE(CAST(NULLIF(CAST(c.cod_fichario AS TEXT), '') AS INT), 0), 
            NOW(), 
            NOW(), 
            CASE WHEN UPPER(TRIM(c.situacao::TEXT)) IN ('ATIVO', 'ATIVA', 'SIM', 'S', '1', 'TRUE', 'T') THEN FALSE ELSE TRUE END
        FROM migracao_legacy.cliente AS c
        WHERE CAST(c.codigo AS INT) <> 1;

        PERFORM setval('public.clientes_clientes_id_seq', (SELECT MAX(clientes_id) FROM public.clientes));
    ELSE
        RAISE NOTICE 'Tabela Clientes já migrada. Pulando.';
    END IF;

    -- -------------------------------------------------------
    -- MIGRAÇÃO: FUNCIONARIOS
    -- -------------------------------------------------------
    IF NOT EXISTS (SELECT 1 FROM public.funcionarios) THEN
        RAISE NOTICE 'Migrando Funcionarios...';
        
        INSERT INTO public.funcionarios (nome, data_cadastro, data_ultimo_registro, deletado)
        SELECT 
            LEFT(COALESCE(NULLIF(TRIM(f.NOME::TEXT), ''), 'NÃO INFORMADO'), 200), 
            NOW(), 
            NOW(), 
            FALSE
        FROM migracao_legacy.funcionarios AS f;
        
        PERFORM setval('public.funcionarios_funcionarios_id_seq', (SELECT MAX(funcionarios_id) FROM public.funcionarios));
    ELSE
        RAISE NOTICE 'Tabela Funcionarios já migrada. Pulando.';
    END IF;

    -- -------------------------------------------------------
    -- MIGRAÇÃO: PRODUTOS
    -- -------------------------------------------------------
    IF NOT EXISTS (SELECT 1 FROM public.produtos) THEN
        RAISE NOTICE 'Migrando Produtos...';

        -- CORREÇÃO CRÍTICA AQUI:
        -- 1. Inserir o ID 1 Manualmente
        INSERT INTO public.produtos (produtos_id, descricao, unidade_medida, preco_compra, preco_venda, localizacao, laboratorio, principio, generico, codigo_produto, codigo_barras, data_cadastro, data_ultimo_registro, deletado)
        VALUES (1, 'NÃO INFORMADO', 'NÃO INFORMADO', 0, 0, '0', 'NÃO INFORMADO', 'NÃO INFORMADO', 'NAO', '0000000', 'NÃO INFORMADO', NOW(), NOW(), FALSE);

        -- 2. AJUSTAR A SEQUENCE IMEDIATAMENTE PARA NÃO REPETIR O ID 1
        PERFORM setval('public.produtos_produtos_id_seq', 1);

        -- 3. Agora sim, inserir a massa de dados (o contador vai gerar 2, 3, 4...)
        INSERT INTO public.produtos (descricao, unidade_medida, preco_compra, preco_venda, localizacao, laboratorio, principio, generico, codigo_produto, codigo_barras, data_cadastro, data_ultimo_registro, deletado)
        SELECT 
            LEFT(COALESCE(NULLIF(TRIM(t.MED_DES::TEXT), ''), 'NÃO INFORMADO'), 200), 
            LEFT(COALESCE(NULLIF(CAST(t.MED_UNI AS VARCHAR), ''), 'UN'), 200), 
            CAST(COALESCE(t.MED_PLA1, 0) AS DECIMAL(19,4)), 
            CAST(COALESCE(t.MED_PCO1, 0) AS DECIMAL(19,4)), 
            LEFT(COALESCE(NULLIF(TRIM(t.LOCALIZACAO::TEXT), ''), 'NÃO INFORMADO'), 200), 
            LEFT(COALESCE(NULLIF(TRIM(t.LAB_NOM::TEXT), ''), 'NÃO INFORMADO'), 200), 
            LEFT(COALESCE(NULLIF(TRIM(t.MED_PRINCI::TEXT), ''), 'NÃO INFORMADO'), 200), 
            LEFT(COALESCE(NULLIF(TRIM(t.MED_GENE::TEXT), ''), 'NA'), 3), 
            LEFT(COALESCE(NULLIF(TRIM(t.MED_ABC::TEXT), ''), ''), 9), 
            LEFT(COALESCE(NULLIF(TRIM(t.MED_BARRA::TEXT), ''), ''), 50), 
            NOW(), 
            NOW(), 
            FALSE
        FROM migracao_legacy.tabela_medicamentos AS t
        WHERE COALESCE(t.ATIVO::TEXT, '1') <> '0';
        
        PERFORM setval('public.produtos_produtos_id_seq', (SELECT MAX(produtos_id) FROM public.produtos));
    ELSE
        RAISE NOTICE 'Tabela Produtos já migrada. Pulando.';
    END IF;

    -- -------------------------------------------------------
    -- MIGRAÇÃO: MOVIMENTOS
    -- -------------------------------------------------------
    IF NOT EXISTS (SELECT 1 FROM public.movimentos) THEN
        RAISE NOTICE 'Migrando Movimentos...';

        INSERT INTO public.movimentos (produtos_id, produtos_descricao, produtos_codigo_produto, clientes_id, clientes_nome, funcionarios_id, funcionarios_nome, quantidade, preco_unitario_dia_venda, preco_total_dia_venda, preco_unitario_atual, preco_total_atual, valor_pago, desconto, data_venda, data_pagamento, codigo_movimento, data_cadastro, data_ultimo_registro, deletado)
        SELECT 
            0, 
            LEFT(COALESCE(NULLIF(TRIM(m.descricao_produto::TEXT), ''), 'NÃO INFORMADO'), 200), 
            LEFT(COALESCE(NULLIF(TRIM(m.material::TEXT), ''), ''), 9), 
            CAST(m.cod_cli AS INT), 
            'NÃO INFORMADO', 
            0, 
            'NÃO INFORMADO', 
            COALESCE(m.qtde_movimentada, 0), 
            CAST(COALESCE(m.valor_unitario, 0) AS DECIMAL(19,4)), 
            CAST(COALESCE(m.valor_unitario, 0) * COALESCE(m.qtde_movimentada, 0) AS DECIMAL(19,4)), 
            CAST(COALESCE(m.valor_unitario, 0) AS DECIMAL(19,4)), 
            CAST(COALESCE(m.valor_unitario, 0) * COALESCE(m.qtde_movimentada, 0) AS DECIMAL(19,4)), 
            CAST(CASE WHEN UPPER(TRIM(COALESCE(m.pago::TEXT, 'NAO'))) IN ('SIM', 'S', '1', 'TRUE', 'T') THEN COALESCE(m.valor_unitario, 0) * COALESCE(m.qtde_movimentada, 0) ELSE 0 END AS DECIMAL(19,4)), 
            CAST(COALESCE(m.desconto, 0) AS DECIMAL(19,4)), 
            CAST(m.data_venda AS TIMESTAMP(0)), 
            CAST(m.data_pagto AS TIMESTAMP(0)), 
            CAST(COALESCE(m.codigo_movimento, 0) AS INT), 
            NOW(), 
            NOW(), 
            CAST(CASE WHEN UPPER(TRIM(COALESCE(m.pago::TEXT, 'NAO'))) IN ('SIM', 'S', '1', 'TRUE', 'T') THEN TRUE ELSE FALSE END AS BOOLEAN)
        FROM migracao_legacy.mov_cliente AS m;

        RAISE NOTICE 'Corrigindo vínculos de Produtos nos Movimentos...';
        UPDATE public.movimentos m
        SET produtos_id = COALESCE(p.produtos_id, 0)
        FROM (
            SELECT codigo_produto, MIN(produtos_id) AS produtos_id 
            FROM public.produtos 
            GROUP BY codigo_produto
        ) p
        WHERE p.codigo_produto = m.produtos_codigo_produto 
          AND m.produtos_id = 0;

        RAISE NOTICE 'Corrigindo nomes de Clientes nos Movimentos...';
        UPDATE public.movimentos m
        SET clientes_nome = LEFT(COALESCE(NULLIF(TRIM(c.nome), ''), 'NÃO INFORMADO'), 200)
        FROM public.clientes c
        WHERE c.clientes_id = m.clientes_id;

        RAISE NOTICE 'Sincronizando Sequences...';
        SELECT COALESCE(MAX(codigo_movimento), 0) + 1 INTO v_max_cod FROM public.movimentos;
        PERFORM setval('public.seq_codigo_movimento', v_max_cod);
        PERFORM setval('public.movimentos_movimentos_id_seq', (SELECT MAX(movimentos_id) FROM public.movimentos));
        
    END IF;

    RAISE NOTICE 'Migração concluída com sucesso.';
END $$;