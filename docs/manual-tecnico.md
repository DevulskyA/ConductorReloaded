# Conductor Reloaded: Manual Técnico de Uso

Bem-vindo ao **Conductor Reloaded**, um motor de Workflow e Arquitetura **High-Assurance** movido a IA, projetado sob o paradigma de desenvolvimento *Spec-Driven* (Especificações primeiro, código depois). 

Este manual serve como o guia definitivo para iniciar novos projetos, idealizar funcionalidades sob uma blindagem constitucional e comandar agentes autônomos por um fluxo de ponta a ponta.

---

## 🏛️ Parte I: O Paradigma e Os Pilares

O Conductor Reloaded não é apenas um template ou um assistente de código. É um **framework de governança** que te impede de escrever código mal pensado ou quebrar funcionalidades existentes.

### Os Três Pilares
1. **Spec-Driven Development:** Tudo começa com um `spec.md`. Nenhum código é tocado antes de um acordo estruturado sobre o que deve ser feito.
2. **A Constituição (The Law):** Existe um documento chamado de *Spec Reviewer Constitution* (A Lei do Revisor). O ambiente opera sob a premissa de um *FAIL-CLOSED* — se não estiver claro e se não cobrir limites/borda (edge-cases), a implementação não tem permissão para começar.
3. **Auto-Pilot Fluído:** A esteira (Setup -> Criar Track -> Revisar -> Desenvolver) é encadeada automaticamente. Você não precisa lembrar de múltiplos comandos; a IA guia a transição de estados.

### Glossário Expresso
- **Track:** Uma unidade coesa de desenvolvimento. Pode ser uma feature, um bugfix épico ou uma refatoração massiva.
- **Spec:** O "contrato" de uma Track. Descreve o que precisa ser feito e todas as condições de contorno e borda.
- **Plan:** A versão executável da Spec. Um checklist (`plan.md`) de passos que o agente seguirá cegamente.

---

## 🚀 Parte II: Guia de Bolso (Agnóstico e Invisível)

Você interage com o Conductor através de **Workflows do Antigravity** ou pelo **Codex**. Não é necessário memorizar comandos de barra (`/`).

### 1. Inicializando a Engrenagem
**Para começar um novo projeto ou plugar o Conductor em um projeto existente:**
Apenas peça ao agente na sua linguagem natural:
*"Prepare o ambiente do Conductor neste projeto"* (ou dispare a execução via UI).

O que acontece:
- O agente varrerá seu repositório (*Auto-Discovery*). Se for em uma base de código existente, ele tentará detectar passivamente as tecnologias (ex: `package.json`).
- O **Auto-Pilot** será sugerido: Você pode permitir que o agente rascunhe automaticamente todas as suas documentações vitais da arquitetura (`tech-stack.md`, `product.md` e Styleguides) exigindo apenas um "De acordo" final seu, diminuindo a burocracia do dia 1.

### 2. O Ciclo de Vida de uma Track (Feature Lifecycle)
Sempre que você for trabalhar em algo novo, basta pedir à inteligência artificial:
*"Eu quero começar uma nova feature chamada X"*

O **Workflow Nativo** (definido em `.agents/workflows/` para o Antigravity ou em `.cursorrules` para o Codex) será acionado e guiará a esteira.

#### A Esteira Automática (Auto-Handoff Ininterrupto)
Você não precisa se preocupar em coordenar diferentes agentes. Criamos um fluxo de *"Auto-Handoff"*. Basta seguir o diálogo:

1. **A Visão Inicial:** Diga o que quer (ex: "Quero uma tela de login com OAuth").
2. **Perguntas Rápidas:** O agente estruturará a base do documento `spec.md`.
3. **Ponte para Revisão (A Constituição Ataca):** Assim que a estruturação inicial termina, o Conductor perguntará: *"Iniciar a Revisão Constitucional agora?"*. Ao dizer "Sim", o modo *Reviewer* entra em ação silenciosamente. 
4. **O Interrogatório de Negócio:** O Guardião fará perguntas duras sobre Gaps Técnicos e Gaps de Negócio não cobertos. Preencha os vazios que ele detectar.
5. **A Ponte para o Código:** Assim que a SPEc for selada e validada, a IA perguntará: *"Revisão Mestra concluída. Iniciar Codificação?"*. 
6. **Mãos na Massa:** Se você concordar, a implementação assume e executa todo o plano.

### 3. A Prevenção de Desastres Git
> *"Eu modifiquei arquivos da feature durante a implementação manualmente. E agora?"*

Se o Agente iniciar a fase de implementação e você já tiver modificado algo, o Conductor Reloaded fará um `git status` silencioso na largada. Se detectar que código surgiu do nada (você os alterou), ele pausará e oferecerá a opção de fazer um **Auto-Sync** do seu `plan.md` com a realidade atual do repositório.

### 4. Ações Destrutivas (Sempre com Permissão)
Embora as transições de ciclo sejam automáticas, o Conductor **nunca** executará ações destrutivas (deletar tracks, arquivar, ou reverter via Git) sem apresentar um aviso claro e exigir uma resposta explícita ("Sim/Não") de você, mantendo o controle total sobre exclusões.

### 5. Alternativa Fallback (Acionamentos Isolados)
Apesar do fluxo principal orquestrado ser ininterrupto, as Skills nativas injetadas podem sempre ser invocadas pontualmente descrevendo o que você quer fazer caso você perca o contexto do Chat:
- *"Force o Auto-Discovery inicial"* (Equivalente ao antigo setup)
- *"Gere uma Track manualmente sem continuar"* (Equivalente ao newTrack avulso)
- *"Revise a spec que eu acabei de escrever na mão"* (Equivalente a rodar review)
- *"Retome a implementação de onde parei"* (Equivalente ao implement direto)
- *"Cancele meu progresso e reverta o Git"* (Equivalente ao revert de emergência)

---

## 🎬 Parte III: Exemplos Práticos (Como Controlar a Integração)

Nesta seção, dissecamos de forma técnica como traduzir a sua intenção (Linguagem Natural) na esteira orquestrada do Conductor sem depender de comandos estritos.

### Exemplo 1: Iniciando uma Funcionalidade Completa (Greenfield)

**1. O Objetivo:** Você precisa criar uma nova arquitetura para login com integração OAuth via Google. O repositório ainda não possui a pasta `conductor/`.

**2. A Entrada (Prompt do Usuário):** 
> *"Crie uma nova feature de Login via Google OAuth."*

**3. A Orquestração Interna (O que o Conductor faz sozinho):**
- **Trigger 1 (Auto-Setup):** O sistema detecta a ausência da governança. Ele silenciosamente faz um *scaffolding* das regras e stack de projeto baseando-se no que encontrar na raiz.
- **Trigger 2 (NewTrack):** Uma vez feito o setup, ele isola uma pasta `conductor/tracks/login-google_2026/` e cria a infraestrutura da feature.
- **Trigger 3 (Auto-Handoff):** Ele submete a estrutura inicial instantaneamente ao **Spec Reviewer Constitution**, que interrompe a escrita de código para te interrogar sobre os gaps da regra de negócio de login (ex: falha de internet no meio do token).

**4. O Resultado Final:** O projeto passa de zero a uma funcionalidade com **Design de Contrato** documentado, revisado e com um checklist atômico pronto para você autorizar o início do código.

---

### Exemplo 2: O 'Auto-Sync' após Retrabalho Manual no Git

**1. O Objetivo:** Um colega (ou você mesmo) alterou arquivos de rotas do projeto diretamente no VS Code na noite passada para adiantar trabalho. Hoje de manhã, você quer que a Inteligência Artificial retome de onde você parou baseado no plano técnico de uma feature chamada 'Carrinho de Compras'.

**2. A Entrada (Prompt do Usuário):** 
> *"Retome a codificação da feature de Carrinho de Compras."*

**3. A Orquestração Interna:**
- **Trigger 1 (File Resolution):** O agente acha o ID da respectiva e lê o `plan.md`.
- **Trigger 2 (Git-Awareness):** Antes de escrever qualquer linha ou subscrever seu trabalho da noite passada, ele roda um `git status --porcelain`. O sistema descobre que a alteração cruza (resolve) as tarefas 2 e 3 do Checklist.
- **Trigger 3 (Conciliação):** O agente pausa, lhe mostra o relatório de conflito e sugere marcar como `[x]` as tarefas detectadas no Git local isoladamente antes de dar continuidade na próxima demanda mecânica.

**4. O Resultado Final:** Sincronia limpa. Ele não atropela seu código novo, pula os passos necessários e avança na implementação respeitando o estado do versionamento.

---

### Exemplo 3: A Reversão de Múltiplos Commits (Safe Revert)

**1. O Objetivo:** Uma feature de Migração Banco de Dados inteira, com 4 commits acumulados na master, introduziu um memory leak no ambiente. Você necessita arrancar apenas o estado modificado da interface sem quebrar outras contribuições.

**2. A Entrada (Prompt do Usuário):** 
> *"Reverta inteiramente a track de Migração de Banco."*

**3. A Orquestração Interna:**
- **Trigger 1 (Track Tracing):** O sistema varre os IDs atrelados ao registro em `conductor/tracks.md`.
- **Trigger 2 (Log Intersecting):** Ele cruza via `git log` localizando de maneira reversa todos os SHAs ligados aos commits exatos que dizem `feat: Migração` listados sequencialmente.
- **Trigger 3 (Safe Prompting):** Trata-se de uma *ação destrutiva*. A automação **pausa bloqueando a lixeira** e cospe uma listagem contendo um prompt duro com "Sim ou Não" (exclusivo) antes do rollback acontecer.

**4. O Resultado Final:** Só após o "Sim" consciente e intencional do operador é que o Git Revert inverso emenda o código do projeto devolvendo as especificações originais.

---

## 🔧 Parte IV: Profundidade Técnica (Under the Hood)

Para os Engenheiros querendo customizar ou compreender a caixa preta, o Conductor Reloaded reside nativamente no Antigravity sob o caminho:
`.agents/plugins/conductor-reload/`

### A Hierarquia de Informação / Universal File Resolution
Os arquivos não se movem magicamente. O sistema navega na arquitetura usando o *Universal File Resolution Protocol* mapeado no `AGENTS.md`. Funciona assim:
1. O agente procura a "Mesa Central" em `conductor/index.md`.
2. Do índice, ele sabe onde estão as Diretrizes de Produto (`product.md`), a Stack de Tecnologia (`tech-stack.md`) e a Lei suprema de Governança (`docs/spec-reviewer/system-spec-reviewer-constitution.md`).
3. Uma pasta `conductor/tracks/` mantém o registro do estado atual, armazenando um subdiretório para cada Funcionalidade com seu ID isolado (Ex: `tela-de-login_20261120/`). 

### Customizando o Guardião / Revisão
Se o Agente estiver sendo tolerante demais (ou muito rígido) na revisão das SPECs das suas features:
Abra o documento `docs/spec-reviewer/system-spec-reviewer-constitution.md`. 
Essas são as **diretrizes master do LLM** no formato *Fail-Closed*. Pode alterar a "regrinha" de tolerância livremente e nos próximos `/conductor:review`, ele adotará o novo comportamento instintivamente.

### Como o Auto-Sync Funciona?
O componente passivo do `/conductor:implement` não escreve em branches de backup sozinho. Ele avalia o output literal do `git status --porcelain`. Quando se encontra descompassos de checklist contra as edições recém identificáveis, ele atualiza as flags do Markdown para `[x]` forçando uma reconciliação mental do Agente sobre a próxima tarefa disponível.

---

## ⚡ Cheatsheet Invariável

| Ação | Como acionar via Agente / Workflow | Efeito |
| --- | --- | --- |
| **Ponto de Partida Zero** | *"Inicie o projeto Conductor aqui"* | Auto-setup silencioso (se faltar algo, ele constrói `conductor/*`) |
| **Criar Nova Feature** | *"Quero criar a feature X"* | Gera Spec ➔ Inicia Review (Auto) |
| **Codificar Feature**| *"Codifique a track X"* | Sincroniza Git local ➔ Implementa `plan.md` |
| **Stress-Test de Ideia** | *"Faça a revisão constitucional dessa track"* | Interrogatório de regras contra `spec.md` |
| **Voltar Atrás (Rollback)** | *"Reverta a track X"* | Pede permissão explícita ➔ Reverte Git seguro |
| **Situação Geral** | *"Status report"* | Relata progresso versus pendências |

---

*Gerado pelas Integrações Nativas de Workflow do Antigravity (Versão Ironclad v4.4E)*
