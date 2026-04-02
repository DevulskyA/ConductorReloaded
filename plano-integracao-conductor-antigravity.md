# Plano Operacional de Integração do Conductor-for-all com o Workflow Canônico de SPEC Review

## Decisão de formato

**Formato recomendado para execução por IA: Markdown (`.md`).**

### Motivo técnico
- **Markdown é melhor que PDF para execução por agente** porque o conteúdo permanece texto puro, fácil de ler, citar, transformar e seguir passo a passo.
- **PDF é melhor apenas para revisão humana, versionamento visual ou compartilhamento formal.**
- Como **quem vai executar este procedimento é o Antigravity**, o formato mais adequado é **Markdown**.

### Regra prática
- Use este arquivo `.md` como **documento operacional principal**.
- Gere PDF apenas depois, se houver necessidade de arquivamento, revisão visual ou distribuição humana.

---

## Objetivo

Integrar a **camada operacional atual** baseada em **Conductor-for-all** com o **workflow canônico anterior** contido em um único arquivo Markdown, preservando a precedência do workflow antigo e permitindo, numa segunda etapa, adaptar o conjunto para execução nativa via **Antigravity**.

---

## Princípio de precedência

A ordem correta de autoridade é esta:

```text
/docs/spec-reviewer/system-spec-reviewer-constitution.md
> /conductor/product-guidelines.md
> /conductor/workflow.md
> /AGENTS.md
> /.agents/skills/*
> qualquer execução local do agente
```

### Consequência operacional
A camada nova **não pode reescrever a lógica antiga**. Ela deve **obedecer** ao workflow canônico já existente.

---

## Premissas obrigatórias

Antes de executar qualquer etapa, a IA executora deve definir e validar estas variáveis:

```bash
PROJECT_ROOT="/caminho/absoluto/do/projeto-alvo"
OLD_WORKFLOW_SRC="/caminho/absoluto/do/specreviewerlionlab.md"
VENDOR_DIR="$PROJECT_ROOT/.vendor/Conductor-for-all"
```

### Regras de parada
1. **Não inferir caminhos.** Se `PROJECT_ROOT` ou `OLD_WORKFLOW_SRC` não estiverem definidos com precisão, **parar**.
2. **Não prosseguir sem Node funcional.** O pacote `conductor-4-all` exige `Node >= 18`.
3. **Não usar Antigravity como caminho inicial de instalação do pacote.** O executor final será o Antigravity, mas a instalação inicial deve seguir pelo caminho conservador e validado.
4. **Não alterar SPEC nem código antes do encerramento da fase de entrevista e confirmação explícita.**

---

## Contexto técnico importante

### O que o Conductor-for-all realmente é
O **Conductor-for-all** não é um agente autônomo. Ele é um **instalador/adaptador** que injeta um workflow do tipo Conductor em ambientes de agentes e IDEs, por meio de arquivos como:
- `AGENTS.md`
- `SKILL.md`
- prompts/comandos por agente
- estrutura `conductor/` com contexto, workflow e tracks

### O que o workflow antigo realmente é
O arquivo antigo (`specreviewerlionlab.md`) contém a **lógica normativa** do reviewer. Entre os comportamentos que devem ser preservados:
- entrevistar antes de alterar;
- fazer uma pergunta por vez;
- nunca assumir que a SPEC está completa;
- nunca assumir qual SPEC revisar sem caminho explícito;
- aplicar auto-fill técnico por categoria quando isso não envolver decisão de negócio;
- confirmar tudo antes de atualizar a SPEC.

### Situação específica do Antigravity
Mesmo que o executor final seja o **Antigravity**, a instalação inicial **não deve depender** de suporte oficial perfeito no `Conductor-for-all`, porque a exposição pública desse suporte é inconsistente. Portanto:
- **o executor final será o Antigravity**;
- **a instalação inicial seguirá pelo modo Skills / General Coding Agents**;
- **a adaptação específica para Antigravity será feita numa etapa posterior**.

---

# PARTE 1 — Pré-flight do ambiente

## 1.1 Verificar ferramentas mínimas

Executar:

```bash
git --version
node --version
corepack --version || true
```

### Critérios de aceite
- `git --version` deve retornar sem erro.
- `node --version` deve indicar `v18.x`, `v20.x`, `v22.x` ou superior.
- `corepack --version` pode falhar neste ponto; isso não bloqueia ainda, mas exigirá correção antes do build.

## 1.2 Se `corepack` não existir

Executar:

```bash
npm install -g corepack@latest
corepack enable
```

## 1.3 Validar os caminhos operacionais

Executar:

```bash
test -d "$PROJECT_ROOT"
test -f "$OLD_WORKFLOW_SRC"
```

### Regra
Se qualquer teste falhar, **parar imediatamente**.

---

# PARTE 2 — Obter e compilar o Conductor-for-all localmente

## 2.1 Clonar o repositório

Executar:

```bash
mkdir -p "$PROJECT_ROOT/.vendor"
git clone https://github.com/hlhr202/Conductor-for-all.git "$VENDOR_DIR"
```

## 2.2 Verificar o clone

Executar:

```bash
test -d "$VENDOR_DIR/.git"
test -f "$VENDOR_DIR/package.json"
```

## 2.3 Entrar no repositório e ativar Corepack

Executar:

```bash
cd "$VENDOR_DIR"
corepack enable
```

## 2.4 Instalar dependências e compilar

Executar:

```bash
pnpm install
pnpm build
```

## 2.5 Verificar o build

Executar:

```bash
test -f "$VENDOR_DIR/dist/index.js"
```

## 2.6 Verificar a CLI compilada

Executar:

```bash
node dist/index.js --help
```

### Regra
Se `dist/index.js` não existir ou a ajuda da CLI falhar, **parar**.

---

# PARTE 3 — Instalar a camada atual no projeto-alvo

## 3.1 Rodar a instalação

Ainda dentro de `"$VENDOR_DIR"`, executar:

```bash
node dist/index.js install "$PROJECT_ROOT"
```

## 3.2 Responder às perguntas interativas

Escolhas obrigatórias:

1. **Select installation mode:** `Skills`
2. **Select target agent for skills:** `General Coding Agents`

### Motivo
Este é o caminho mais seguro e mais coerente com a implementação atual.

## 3.3 Verificar o resultado da instalação

Executar:

```bash
test -f "$PROJECT_ROOT/AGENTS.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-setup/SKILL.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-newTrack/SKILL.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-implement/SKILL.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-status/SKILL.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-review/SKILL.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-revert/SKILL.md"
```

## 3.4 Tirar snapshot do baseline

Executar no projeto-alvo:

```bash
cd "$PROJECT_ROOT"
git status
git add AGENTS.md .agents/skills
git commit -m "chore(conductor): bootstrap baseline skills install"
```

### Observação
Se o projeto não estiver sob Git, **não inicializar Git automaticamente** sem ordem explícita.

---

# PARTE 4 — Preservar o workflow antigo como constituição canônica

## 4.1 Copiar o arquivo antigo para local estável

Executar:

```bash
mkdir -p "$PROJECT_ROOT/docs/spec-reviewer"
cp -f "$OLD_WORKFLOW_SRC" "$PROJECT_ROOT/docs/spec-reviewer/system-spec-reviewer-constitution.md"
test -f "$PROJECT_ROOT/docs/spec-reviewer/system-spec-reviewer-constitution.md"
```

## 4.2 Regra de preservação

Nesta etapa:
- **não resumir**;
- **não reescrever**;
- **não refatorar**;
- **não decompor em vários arquivos**.

O arquivo antigo é a **fonte normativa**.

---

# PARTE 5 — Materializar a camada `conductor/`

## 5.1 Criar a estrutura base

Executar:

```bash
mkdir -p "$PROJECT_ROOT/conductor/tracks"
```

## 5.2 Criar `conductor/index.md`

Executar:

```bash
cat > "$PROJECT_ROOT/conductor/index.md" <<'EOF'
# Conductor Project Context Index

- [Product Definition](./product.md)
- [Tech Stack](./tech-stack.md)
- [Workflow](./workflow.md)
- [Product Guidelines](./product-guidelines.md)
- [Tracks Registry](./tracks.md)
EOF
```

## 5.3 Criar `conductor/product.md`

Executar:

```bash
cat > "$PROJECT_ROOT/conductor/product.md" <<'EOF'
# Product Definition

## Name
SPEC Reviewer Integrated Workflow

## Purpose
Revisar, aprofundar e corrigir SPECs antes de qualquer implementação ou atualização estrutural.

## Canonical Source
A fonte normativa principal deste projeto é:
`docs/spec-reviewer/system-spec-reviewer-constitution.md`

## Primary Rule
Nenhuma SPEC pode ser alterada antes que:
1. todos os gaps de negócio tenham sido perguntados;
2. as respostas tenham sido confirmadas;
3. o formato final da SPEC tenha sido escolhido.
EOF
```

## 5.4 Criar `conductor/product-guidelines.md`

Executar:

```bash
cat > "$PROJECT_ROOT/conductor/product-guidelines.md" <<'EOF'
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
EOF
```

## 5.5 Criar `conductor/tech-stack.md`

Executar:

```bash
cat > "$PROJECT_ROOT/conductor/tech-stack.md" <<'EOF'
# Tech Stack

## Operational Stack
- Legacy constitutional workflow file in Markdown
- Conductor-for-all operational layer
- Skills-based agent integration
- Project-level AGENTS protocol
- Track-based workflow in `conductor/tracks/`

## Constraints
- A camada operacional não pode contradizer a constituição antiga.
- A revisão de SPEC precede qualquer implementação.
EOF
```

## 5.6 Criar `conductor/workflow.md`

Executar:

```bash
cat > "$PROJECT_ROOT/conductor/workflow.md" <<'EOF'
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
EOF
```

## 5.7 Criar `conductor/tracks.md`

Executar:

```bash
cat > "$PROJECT_ROOT/conductor/tracks.md" <<'EOF'
# Tracks Registry

Nenhuma track criada ainda.

## Rules
- Não abrir track de implementação antes da aprovação explícita da SPEC revisada.
- Cada track deve conter:
  - spec.md
  - plan.md
  - metadata.json
EOF
```

## 5.8 Verificar a estrutura

Executar:

```bash
test -f "$PROJECT_ROOT/conductor/index.md"
test -f "$PROJECT_ROOT/conductor/product.md"
test -f "$PROJECT_ROOT/conductor/product-guidelines.md"
test -f "$PROJECT_ROOT/conductor/tech-stack.md"
test -f "$PROJECT_ROOT/conductor/workflow.md"
test -f "$PROJECT_ROOT/conductor/tracks.md"
test -d "$PROJECT_ROOT/conductor/tracks"
```

---

# PARTE 6 — Patch controlado de `AGENTS.md` e dos skills instalados

## Objetivo
Fazer a camada instalada obedecer à constituição antiga **sem ainda alterar o core TypeScript do Conductor-for-all**.

## 6.1 Fazer backup antes de patchar

Executar:

```bash
cp "$PROJECT_ROOT/AGENTS.md" "$PROJECT_ROOT/AGENTS.md.bak.pre-spec-reviewer"

for f in \
  "$PROJECT_ROOT/.agents/skills/conductor-setup/SKILL.md" \
  "$PROJECT_ROOT/.agents/skills/conductor-newTrack/SKILL.md" \
  "$PROJECT_ROOT/.agents/skills/conductor-review/SKILL.md" \
  "$PROJECT_ROOT/.agents/skills/conductor-implement/SKILL.md"
do
  cp "$f" "$f.bak.pre-spec-reviewer"
done
```

## 6.2 Patchar `AGENTS.md`

Executar:

```bash
node <<'NODE'
const fs = require('fs');
const path = require('path');

const projectRoot = process.env.PROJECT_ROOT;
if (!projectRoot) {
  console.error('PROJECT_ROOT não definido');
  process.exit(1);
}

const agentsPath = path.join(projectRoot, 'AGENTS.md');
const backupPath = path.join(projectRoot, 'AGENTS.md.bak.pre-spec-reviewer');

if (!fs.existsSync(backupPath)) {
  console.error('Backup de AGENTS.md não encontrado');
  process.exit(1);
}

const oldContent = fs.readFileSync(backupPath, 'utf8');

const preamble = `# Spec Reviewer Integration Override

## Precedence
1. \`docs/spec-reviewer/system-spec-reviewer-constitution.md\`
2. \`conductor/product-guidelines.md\`
3. \`conductor/workflow.md\`
4. \`conductor/tracks.md\` e arquivos de track
5. skills em \`.agents/skills/\`

## Mandatory Rules
- Nunca assumir qual SPEC revisar.
- Nunca alterar SPEC, gerar código ou modificar arquivos antes de concluir a entrevista e obter confirmação explícita.
- Fazer uma pergunta por vez.
- Separar gaps técnicos de gaps de negócio.
- Aplicar auto-fill técnico sem inventar regra de negócio.
- Perguntar formato final antes de atualizar a SPEC.

`;

fs.writeFileSync(agentsPath, preamble + oldContent, 'utf8');
console.log('AGENTS.md atualizado com preâmbulo de integração.');
NODE
```

## 6.3 Patchar os skills principais

Executar:

```bash
node <<'NODE'
const fs = require('fs');
const path = require('path');

const projectRoot = process.env.PROJECT_ROOT;
if (!projectRoot) {
  console.error('PROJECT_ROOT não definido');
  process.exit(1);
}

const targets = {
  'conductor-setup': `
## Integration Override

Antes de agir:
1. Leia \`docs/spec-reviewer/system-spec-reviewer-constitution.md\`.
2. Trate esse arquivo como regra superior.
3. Garanta que existam:
   - \`conductor/index.md\`
   - \`conductor/product.md\`
   - \`conductor/product-guidelines.md\`
   - \`conductor/tech-stack.md\`
   - \`conductor/workflow.md\`
   - \`conductor/tracks.md\`
4. Nunca sobrescreva a constituição antiga sem confirmação explícita.
`,
  'conductor-newTrack': `
## Integration Override

Antes de abrir qualquer track:
1. Leia \`docs/spec-reviewer/system-spec-reviewer-constitution.md\`.
2. Não abra track de implementação se a SPEC ainda não foi revisada e aprovada.
3. Para track de SPEC review, exija estes blocos:
   - já coberto
   - gaps técnicos
   - gaps de negócio
   - perguntas pendentes
   - decisões confirmadas
   - auto-fills aplicados
   - formato final da SPEC
`,
  'conductor-review': `
## Integration Override

Antes de qualquer mutação:
1. Leia \`docs/spec-reviewer/system-spec-reviewer-constitution.md\`.
2. Não altere arquivos antes de concluir todas as perguntas e obter confirmação explícita.
3. Faça uma pergunta por vez.
4. Use múltipla escolha sempre que possível.
5. Nunca invente regra de negócio.
6. Apresente primeiro:
   - já coberto
   - gaps técnicos
   - gaps de negócio
7. Só depois da confirmação final pergunte o formato da SPEC e atualize.
`,
  'conductor-implement': `
## Integration Override

Antes de implementar:
1. Verifique se a SPEC revisada foi aprovada explicitamente.
2. Se não houver aprovação explícita, pare.
3. Use \`conductor/workflow.md\` e a track atual como base.
4. Nunca implemente a partir de SPEC ambígua ou não confirmada.
`
};

function insertAfterFrontMatter(content, block) {
  if (!content.startsWith('---\n')) {
    return block.trim() + '\n\n' + content;
  }
  const end = content.indexOf('\n---\n', 4);
  if (end === -1) {
    return block.trim() + '\n\n' + content;
  }
  const frontMatter = content.slice(0, end + 5);
  const rest = content.slice(end + 5).replace(/^\n+/, '');
  return `${frontMatter}\n${block.trim()}\n\n${rest}`;
}

for (const [skillName, block] of Object.entries(targets)) {
  const skillPath = path.join(projectRoot, '.agents', 'skills', skillName, 'SKILL.md');
  if (!fs.existsSync(skillPath)) {
    console.error(`Skill ausente: ${skillPath}`);
    process.exit(1);
  }
  const original = fs.readFileSync(skillPath, 'utf8');
  const updated = insertAfterFrontMatter(original, block);
  fs.writeFileSync(skillPath, updated, 'utf8');
  console.log(`Patched: ${skillPath}`);
}
NODE
```

## 6.4 Verificar se o patch entrou

Executar:

```bash
grep -R "Integration Override" "$PROJECT_ROOT/AGENTS.md" "$PROJECT_ROOT/.agents/skills" -n
```

### Regra
Se nada for encontrado, **parar**.

---

# PARTE 7 — Verificação estrutural final

## 7.1 Estrutura mínima esperada

```text
PROJECT_ROOT/
  AGENTS.md
  conductor/
    index.md
    product.md
    product-guidelines.md
    tech-stack.md
    workflow.md
    tracks.md
    tracks/
  docs/
    spec-reviewer/
      system-spec-reviewer-constitution.md
  .agents/
    skills/
      conductor-setup/SKILL.md
      conductor-newTrack/SKILL.md
      conductor-implement/SKILL.md
      conductor-status/SKILL.md
      conductor-review/SKILL.md
      conductor-revert/SKILL.md
```

## 7.2 Checklist de verificação

Executar:

```bash
test -f "$PROJECT_ROOT/docs/spec-reviewer/system-spec-reviewer-constitution.md"
test -f "$PROJECT_ROOT/conductor/workflow.md"
test -f "$PROJECT_ROOT/conductor/product-guidelines.md"
test -f "$PROJECT_ROOT/AGENTS.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-review/SKILL.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-newTrack/SKILL.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-setup/SKILL.md"
test -f "$PROJECT_ROOT/.agents/skills/conductor-implement/SKILL.md"
```

## 7.3 Conferência semântica mínima

Verificar manualmente:
- em `system-spec-reviewer-constitution.md`: entrevista antes de alterar; uma pergunta por vez; auto-fill técnico por categoria; confirmação final antes de atualizar;
- em `conductor/workflow.md`: bloqueio de mutação antes da confirmação;
- em `AGENTS.md`: bloco `Spec Reviewer Integration Override`;
- em `conductor-review/SKILL.md`: bloco `Integration Override`.

---

# PARTE 8 — Commit da integração

Se tudo passou, executar:

```bash
cd "$PROJECT_ROOT"
git add AGENTS.md conductor docs/spec-reviewer .agents/skills
git commit -m "feat(spec-reviewer): integrate legacy constitution into conductor operational layer"
```

---

# PARTE 9 — Adaptação posterior para Antigravity

## Situação atual
Nesta etapa, o executor humano-operacional pode passar a usar o **Antigravity** para executar os passos do processo. Porém, a integração feita até aqui foi instalada via `Skills / General Coding Agents` porque esse é o caminho mais seguro da ferramenta atual.

## Objetivo da etapa posterior
Adaptar o conjunto para que o **Antigravity** consiga consumir a estrutura de forma mais nativa, possivelmente por meio de:
- `.agent/workflows`
- convenções próprias do Antigravity
- arquivos de protocolo ajustados ao runtime do Antigravity
- bridge entre `conductor/` e a convenção esperada pelo Antigravity

## Regra
Essa etapa **não deve ser feita antes da estabilização do fluxo base**.

### Ordem correta
1. instalar a camada atual de modo conservador;
2. integrar a constituição antiga;
3. validar o fluxo end-to-end de SPEC review;
4. só então adaptar o conjunto para consumo nativo do Antigravity.

---

# Resultado esperado

Ao final deste plano, o projeto terá:

1. a **camada atual** instalada e versionada;
2. o **workflow antigo** preservado como constituição normativa;
3. a **camada `conductor/`** materializada e alinhada com a constituição;
4. os **skills principais** adaptados para obedecer ao reviewer antigo;
5. uma base estável para futura adaptação específica ao **Antigravity**.

---

# Veredito técnico

## O que usar agora
**Use este arquivo Markdown.**

## O que não usar como fonte principal de execução
**Não use PDF como fonte principal para o Antigravity executar a tarefa.**

## Melhor estratégia
- **Markdown para execução por IA**
- **PDF apenas como derivado opcional para humanos**

## Síntese final
A decisão correta é:

> instalar a camada atual de forma conservadora,
> preservar a anterior como constituição,
> integrar a atual para obedecer à anterior,
> e só depois adaptar o conjunto ao Antigravity.
