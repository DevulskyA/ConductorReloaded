# Guia de Teste Basico pela Interface

Data de referencia: 6 de fevereiro de 2026.

Este documento e para teste manual por usuario final, usando apenas a interface web.

## 1. Objetivo

Validar se o fluxo basico do sistema funciona do ponto de vista de quem usa a tela.

## 2. Antes de comecar

1. A equipe tecnica ja deve ter deixado o sistema no ar.
2. Abra o sistema no navegador (exemplo: `http://localhost:5173`).
3. Se estiver com tela antiga, faca `Ctrl + F5`.

## 3. Checklist rapido

Use este checklist e marque `OK` ou `FALHOU`:

1. Dashboard abre normalmente.
2. Lista de produtos aparece.
3. Busca por nome/SKU funciona.
4. Filtro de local funciona.
5. Mostrar inativos liga/desliga a lista.
6. Cadastro de produto funciona.
7. Edicao de produto funciona.
8. Entrada de estoque funciona.
9. Saida de estoque funciona.
10. Tela de movimentacoes mostra os lancamentos.
11. Exclusao do produto de teste funciona.

## 4. Roteiro detalhado (passo a passo)

### Caso 1 - Abrir dashboard

1. Entrar no sistema.
2. Ir para a tela principal (Visao Geral / Estoque).

Resultado esperado:
1. A pagina carrega sem travar.
2. Cards e tabela aparecem.

### Caso 2 - Validar lista inicial de produtos

1. Verificar a tabela principal.
2. Conferir se existe mais de um produto listado.

Resultado esperado:
1. Produtos visiveis na grade.
2. Sem mensagem de erro.

### Caso 3 - Testar busca

1. No campo "Filtrar por nome ou SKU", digitar parte de um SKU real (ex.: `ONT`).
2. Limpar o campo em seguida.

Resultado esperado:
1. A lista reduz ao filtrar.
2. A lista volta ao normal ao limpar.

### Caso 4 - Testar filtro de local

1. No seletor de local, trocar de "Todos os Locais" para um deposito especifico.
2. Voltar para "Todos os Locais".

Resultado esperado:
1. A quantidade de itens muda conforme o local.
2. A lista volta ao total ao retornar para "Todos os Locais".

### Caso 5 - Testar mostrar inativos

1. Marcar "Mostrar inativos".
2. Desmarcar "Mostrar inativos".

Resultado esperado:
1. Com a opcao marcada, aparecem itens inativos.
2. Com a opcao desmarcada, ficam apenas ativos.

### Caso 6 - Cadastrar produto de teste

1. Clicar em "Novo Produto".
2. Criar item com SKU unico, por exemplo `MANUAL-TEST-20260206`.
3. Salvar.

Resultado esperado:
1. Produto aparece na tabela.
2. Mensagem de sucesso aparece.

### Caso 7 - Editar produto de teste

1. Encontrar o produto criado.
2. Clicar em editar.
3. Alterar nome (ex.: adicionar " - Editado").
4. Salvar.

Resultado esperado:
1. Nome atualizado na tabela.
2. Mensagem de sucesso aparece.

### Caso 8 - Registrar entrada de estoque

1. No produto de teste, clicar em movimentar.
2. Fazer uma entrada (`IN`) de 10 unidades.
3. Confirmar.

Resultado esperado:
1. Estoque do produto aumenta.
2. Operacao finaliza sem erro.

### Caso 9 - Registrar saida de estoque

1. No mesmo produto, abrir movimentacao novamente.
2. Fazer uma saida (`OUT`) de 3 unidades.
3. Confirmar.

Resultado esperado:
1. Estoque reduz de acordo com a saida.
2. Operacao finaliza sem erro.

### Caso 10 - Conferir historico de movimentacoes

1. Ir para a tela "Movimentacoes".
2. Procurar os dois lancamentos do produto de teste (entrada e saida).

Resultado esperado:
1. As duas movimentacoes aparecem no historico.
2. Quantidades e tipo (`IN`/`OUT`) estao corretos.

### Caso 11 - Excluir produto de teste

1. Voltar para a lista de produtos.
2. Excluir o item `MANUAL-TEST-20260206` (ou o SKU criado no teste).
3. Confirmar a exclusao.

Resultado esperado:
1. Produto some da lista ativa.
2. Mensagem de sucesso aparece.

## 5. Registro de evidencias

Para cada caso, registrar:

1. Status: `OK` ou `FALHOU`.
2. Horario do teste.
3. Print da tela (quando falhar).
4. Descricao curta do erro.

## 6. Quando abrir chamado

Abrir chamado para time tecnico se ocorrer qualquer um destes pontos:

1. Erro 500 na tela.
2. Botao salvar/movimentar sem resposta.
3. Produto salvo e nao aparece na lista.
4. Movimentacao concluida sem atualizar estoque.
5. Lentidao severa (mais de 10 segundos para operacoes simples).
