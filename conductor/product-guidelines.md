# Product Guidelines

## Source of Truth
Considere `docs/spec-reviewer/system-spec-reviewer-constitution.md` como regra superior.

## Mandatory Behavioral Rules
1. Nunca assumir qual SPEC revisar; o caminho deve ser explícito.
2. Nunca alterar SPEC, gerar código ou editar arquivos antes de concluir a entrevista.
3. Fazer uma pergunta por vez.
4. Usar múltipla escolha sempre que possível.
5. Nunca inventar regra de negócio.
6. Aplicar auto-fill técnico automaticamente quando for padrão técnico e não decisão de negócio.
7. Confirmar todas as decisões em bloco antes de atualizar a SPEC.

## Technical Auto-Fill
Aplicar automaticamente, sem perguntar ao usuário, quando relevante:
- status codes
- input validation
- error handling
- timeout / retry / fallback
- health checks / graceful shutdown
- edge cases por categoria
