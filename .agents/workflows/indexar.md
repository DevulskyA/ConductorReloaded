---
description: Realiza a varredura passiva para gerar o arquivo API_INDEX.md enumerando blocos lógicos.
---

Este workflow escaneia os símbolos técnicos exportados da camada Source/Lib (Codebase) para gerar tabelas de endereçamento rápido sem interrupções.

**Objetivo:** Criar o `API_INDEX.md` mapeando funções, classes, objetos modulares ou enums do sistema de maneira alfabética para busca atômica.

### Instruções Operacionais

1. **Análise Focada:** Encontre arquivos-chave de código do repositório (ex. Classes Centrais, Helpers, Extensões) e resuma os exports ou namespaces encontrados neles.

2. **Formatação Rigorosa e Inviolável:**
   - Para compor o índice, TUDO tem que seguir unicamente este formato em bullet (MANDATÓRIO):
     `- Name (Type) → Path : Micro≤5`
   - O campo `Type` **só pode possuir** um limite do conjunto restrito: `{Class | Function | Object | Enum}`.
   - O resultado global de listagem deve estar em ordem **Alfabética (A-Z)**.
   - A descrição Micro (`Micro≤5`) deve ter, no máximo, 5 palavras soltas explicando. Não termine o Micro com Ponto Final (.).
   - Em caso de incerteza da função, marque estritamente como `N/A`.

3. **Exemplo Esperado no `API_INDEX.md`:**
   ```markdown
   - Authenticate (Function) → src/auth.ts : processa JWT
   - Client (Object) → utils/conn.js : gerencia porta banco
   - LoggerCore (Class) → src/logger/core.ps1 : N/A
   ```

4. **Salvamento:** Escreva ou atualize no arquivo base da raiz `API_INDEX.md`.
