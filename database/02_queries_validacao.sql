-- Arquivo: database/02_queries_validacao.sql

-- Verificar Movimentos do Cliente 2082
SELECT * FROM public.movimentos WHERE clientes_id = 2082;

-- Verificar Dados Cadastrais do Cliente 2082
SELECT * FROM public.clientes WHERE clientes_id = 2082;

-- Verificar o Produto 41656
SELECT * FROM public.produtos WHERE produtos_id = 41656;