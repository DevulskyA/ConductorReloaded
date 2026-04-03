---
description: Gera ou reconstrói o arquivo PROJECT_MAP.md mapeando a raiz e os diretórios estruturais
---

Este workflow força a varredura atômica da árvore do repositório para documentar estruturalmente os componentes sem inventar dados.

**Objetivo:** Produzir o arquivo `PROJECT_MAP.md` na raiz do projeto contendo o índice de arquivos importantes para as engenharias.

### Instruções Operacionais

1. **Varredura Atômica:**
   - Execute uma verificação das pastas essenciais (ignorar caminhos de cache como `node_modules`, `dist`, `bin`, `.git`).
   - Colete os nomes verdadeiros de arquivos primários que existem. **FORBIDDEN: Não escreva arquivos, scripts ou caminhos lógicos que não estejam materialmente confirmados no disco!**

2. **Geração do Arquivo `PROJECT_MAP.md`:**
   - O documento deve ser limpo e agrupado por domínio/pasta.
   - Cada linha deve mapear a utilidade com uma descrição concisa.
   - **Regra do Validador (MANDATÓRIA):** A descrição (`Descrição`) de cada entrada não deve ultrapassar uma (1) linha sob NENHUMA circunstância.

3. **Exemplo Esperado:**
   ```markdown
   # Project Map (Arquitetura Visual)
   ## /src/controllers
   - `UserController.ts`: Controla a autenticação e chamadas HTTP de gerência.
   - `OrderController.ts`: Transaciona os tickets dos pagamentos.
   ```

4. **Saída:** Utilize a ferramenta adequada (`write_to_file` ou manipulação atômica) para salvar e reportar a conclusão na interface.
