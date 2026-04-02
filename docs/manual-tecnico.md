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

### 4. Alternativa Fallback (Os Comandos Isolados)
Apesar do fluxo orquestrado ser autônomo (via NLP ou Workflow UI), as Skills nativas injetadas podem sempre ser forçadas de forma isolada caso você perca o controle do Chat:
- `/conductor:setup` - Força o Auto-Discovery inicial.
- `/conductor:newTrack` - Força geração bruta de arquivo de Tracking.
- `/conductor:review` - Se você escreveu um `spec.md` na mão e quer o stress-test.
- `/conductor:implement` - Retoma a implementação após pausa conturbada.
- `/conductor:revert` - Cancela o progresso e reverte o Git.

---

## 🔧 Parte III: Profundidade Técnica (Under the Hood)

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

| Ação | Comando a Chamar | Efeito |
| --- | --- | --- |
| **Ponto de Partida Zero** | `/conductor:setup` | Lê o repositório, sugere a stack e monta `conductor/*` |
| **Quero uma Nova Feature** | `/conductor:newTrack` | Gera Spec ➔ Propõe Review ➔ Atualiza as listas |
| **Codificar uma Feature Pura**| `/conductor:implement`| Processa o `plan.md`, reconciliando código com Git passivamente |
| **Stress-Test da Ideia** | `/conductor:review` | Exige a confirmação dura (Q&A de regras de negócio faltantes) |
| **"Deu Tudo Errado!"** | `/conductor:revert` | Isola mudanças e volta com segurança |
| **"Onde estamos?"** | `/conductor:status` | Lista features em Progresso vs. Concluídas |

---

*Gerado pelas Integrações Nativas de Workflow do Antigravity (Versão Ironclad v4.4E)*
