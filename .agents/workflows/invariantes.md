---
description: Avalia repositório global para isolamento estático do runtime criando invariantes nativas restritivas.
---

Este workflow visa abstrair o comportamento exclusivo do projeto em execução, solidificando "A Lei do Projeto" fora do código operacional em um manifesto rígido `.ai_invariants.md`.

**Objetivo:** Extrair as configurações intocáveis de engenharia de ciclo de vida (Deployment customizado, Arquivo crítico que não pode ser mudado, Trava de Memória, Limitações) para garantir que próximas execuções Autônomas via LLM sejam domadas por este guia.

### Instruções Operacionais

1. **Investigação Customizada:** Identifique regras que parecem específicas do negócio da Codebase e que quebrem os fluxos convencionais (Ex: Variáveis env obrigatoriamente presentes, Pastas como `Security/` travadas de alteração). 

2. **Formato Categórico:** Agrupe por Severidade / Proteção no arquivo.
   - Todo *Rule* anotado lá não é opcional para as próximas sessões. Elas engatilham obrigatoriamente um Estado de `HALT` (Parada Interrompendo a execução) da máquina de IA se feridas.

3. Escreva o índice `.ai_invariants.md`.
