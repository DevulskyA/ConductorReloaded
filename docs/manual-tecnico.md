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

## 🎬 Parte III: Exemplos de Uso no Mundo Real

Abaixo estão cenários reais de interação entre o desenvolvedor (Você) e a Inteligência Artificial no chat, mostrando como a ausência de comandos rígidos deixa a governança invisível e fluida:

### Cenário 1: "Greenfield" (Auto-Setup + Encadeamento Mágico)
> **Você:** "Quero criar uma funcionalidade de Login via Google OAuth."
> **Agente:** "Notei que o motor do Conductor não está configurado neste projeto. Vou iniciar o setup automaticamente criando a infraestrutura básica... *[Arquivos gerados]*. Pronto! Iniciando a criação da sua Track de Login. Além do Google, há outra exigência?"
> **Você:** "O usuário tem que ir para /dashboard no sucesso."
> **Agente:** "Spec e Plan consolidados na pasta `conductor/`. Iniciando a Revisão Constitucional automaticamente... *[Modo Guardião assume]*. Notei um Gap de Negócio crítico: não há tratamento para falha na API do Google. Como lidamos?"
> **Você:** "Exiba um toast vermelho na tela e redirecione a rota para /login com query params."
> **Agente:** "Vulnerabilidade documentada. Revisão impecável. Iniciando a fase de codificação automaticamente... *[Agente codifica os passos cruciais sincronizado com o Git]*."

### Cenário 2: Blindagem Anti-Dessincronia (Git-Awareness)
> **Você:** "Retome a codificação da feature de Carrinho de Compras."
> **Agente:** "Acessando checklist `plan.md`... *[Roda checagem Git silenciosa]*. ⚠️ *Aviso de Dessincronia.* Detectei que você mesmo modificou `cart.controller.ts` manualmente e isso atende aos passos 2 e 3 do nosso plano. Deseja realizar um **Auto-Sync** e marcar esses itens como `[x]` antes de dar sequencia?"
> **Você:** "Sim, sincronize."
> **Agente:** "Ok. Reconciliação com a realidade atualizada. Pulando diretamente para o Passo 4 da implementação."

### Cenário 3: Retirada de Risco (Revert Limpo)
> **Você:** "Deu tudo errado. Reverta a track de Carrinho de Compras inteira."
> **Agente:** "Mapeando o histórico do Git... Identifiquei a árvore lógica da sua feature: 1 commit novo e 1 alteração de rotas (`f8da122` e `a01b2cc`). 🛑 **Aviso Destrutivo:** Irei desfazer essas ações diretamente na sua árvore e remover a Track. Você confirma (Sim/Não)?"
> **Você:** "Sim."
> **Agente:** "Git Revert aplicado sucessivamente. Seu código está íntegro exatamente como estava antes do início dessa feature."

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
