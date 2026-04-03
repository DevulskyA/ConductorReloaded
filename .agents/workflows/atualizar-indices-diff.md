---
description: Operação vital de atualização segura de matriz Delta para Map/Index/Catalog/Ledger que invalida edições pre-destrutivas se não houver um Snipet mapeado de alteração real.
---

Se os motores (`PROJECT_MAP.md`, `API_INDEX.md` ou `API_CATALOG.md` e `FEATURE_LEDGER.md`) já nasceram no eco-sistema, as modificações a seguir na base do projeto requerem acionar esse workflow Delta Update Passivo. A regra global dele nega a re-indexação total (pesada de Tokens) ou assunções cruas sem Diffs (que arriscam perder estado anterior do projeto/logs originais gravados em humanos e plan.md prévios).

**Objetivo:** Promover um DELTA passivo limitando sobreescrições cegas nestes arquivos.

### Instruções Operacionais de Auto-Proteção ("Delta Constraint")

1. **Obrigação do DIFF Constante:** Apenas atualize "Entries" comprovadamente alterados. Se ocorreu uma atualização sem a presença validada de um ***Diff com Paths + Snippets Reais de Código***, isso reflete como erro sistêmico inaceitável.
   
2. **Action no Erro Analítico:** Se não há Diff Confiável provando Path e Snippet (ex: Uma lista puramente conceitual de arquivos ou assunção abstrata), a Lei do Validator manda sinalizar de forma agressiva:
   `⛔ HALT: INSUFFICIENT DIFF — provide diff (paths+snippets) ou autorize opening affected files`.
   - Cesse tudo sem escrever um BYTE no repositório nessas condições.

3. **Se o Diff for Confiável:** Proceda à modificação isolada daquela linha (no Tracker `FEATURE_LEDGER` ou Listagem do `API_INDEX`) mantendo intacto as demais subseções em redor dos outros IDs da tabela, blindando assim contra colaterais.
