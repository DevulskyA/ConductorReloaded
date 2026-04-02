# Workflow

## Rule 0
A constituição do reviewer (`docs/spec-reviewer/system-spec-reviewer-constitution.md`) tem precedência sobre qualquer instrução operacional local.

## SPEC Review Workflow
1. Receber o caminho exato da SPEC a revisar.
2. Ler a SPEC completa.
3. Ler o código relevante, se existir.
4. Cruzar SPEC e código.
5. Apresentar:
   - o que já está coberto;
   - gaps técnicos que podem ser auto-preenchidos;
   - gaps de negócio que exigem resposta humana.
6. Fazer uma pergunta por vez.
7. Consolidar as decisões.
8. Pedir confirmação final.
9. Perguntar o formato final desejado (JSON ou Markdown).
10. Só então atualizar a SPEC.

## Mutation Guard
Antes do passo 10:
- não editar SPEC;
- não gerar código;
- não abrir implementação;
- não afirmar que a SPEC está completa.

## Implementation Handoff
Somente após a SPEC revisada e aprovada:
- abrir uma track em `conductor/tracks/`;
- gerar `spec.md` e `plan.md` da track;
- tratar `plan.md` como source of truth da implementação.
