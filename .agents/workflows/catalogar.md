---
description: Workflow vital que gera e estrutura o API_CATALOG.md com documentação aprofundada de I/O e rastreamento de Features Puras (FEATURE_LEDGER.md).
---

Este é o processo mais exigente de extração que garante uma visão global sobre comportamento lateral de classes e features, alimentando fortemente o *Fail-Closed* em manutenções.

**Objetivo:** Desenhar o catálogo tático `API_CATALOG.md` (com Gaps identificados) e inicializar a fundação do rastreador biográfico `FEATURE_LEDGER.md`.

### Passo A: O Catálogo de API (`API_CATALOG.md`)
1. Agrupar em tabela de formato literal com 4 colunas essenciais. 
2. Você deve garantir dados vitais por Assinatura (Ex: `void Start();`).
3. Para cada campo identificado, explicite o contrato: `Summary | Pre | Post | Inv | Fail | GAP`.
4. Se algo não puder ser validado por evidência local, declare expressamente como `GAP: ` seguido do motivo. Nunca assuma como inexistente usando apenas (NONE) se a informação real for desconhecida.
5. **Declaração de Colateralidade Obrigatória:** Registre sempre explanações da cadeia dos "Side effects" indicando estritamente restrições como `Writes`, `Reads`, `IO`, `Timing` ou `Lifecycle` (Declare `NONE` quando de fato for puro).

### Passo B: A Trilha de Integração (`FEATURE_LEDGER.md`)
1. Construa um registro para abrigar a linha do tempo e validações das features (Ativas, Em progresso ou Obsoletas).
2. Tabela fundamental: Todas as *features* inseridas DEVEM carregar atrelado um sistema de Verificação Operacional, com teste técnico (automatizado) OR Manual Case reproduzível pelo humano validando a completude. Sem verificação vinculada, rejeite a trilha.

**Output:** Escreva dois arquivos na raiz: `API_CATALOG.md` e `FEATURE_LEDGER.md`.
