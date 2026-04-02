---
description: Start or continue a Conductor feature (Track) automatically
---

Este workflow orquestra a máquina de estado do Conductor Reloaded silenciosamente. Não exija do usuário o uso de comandos `/conductor:track`.

1. **Auto-Discovery e Setup (Se necessário)**
   Verifique se o projeto já possui o diretório `conductor/` e os artefatos base (`product.md`, `tech-stack.md`, `index.md`).
   - Se os artefatos base estiverem ausentes, leia as instruções da Skill de Setup em `.agents/plugins/conductor-reload/skills/conductor-setup/SKILL.md` e execute-as em modo Auto-Pilot.

2. **Criação da Track (Feature Lifecycle)**
   Leia e aplique rigorosamente as instruções da Skill newTrack localizadas em `.agents/plugins/conductor-reload/skills/conductor-newTrack/SKILL.md`. 
   - Colete com o usuário qual será a "Feature" ou "Track" a ser construída.
   - Construa os artefatos da feature (`spec.md` e `plan.md`).

3. **Revisão Constitucional Automática**
   Imediatamente após a geração inicial da Track, inicie a revisão do SPEC de forma contínua, garantindo os padrões de negócio.
   - Leia as regras da Constituição do Projeto em `docs/spec-reviewer/system-spec-reviewer-constitution.md`.
   - Leia e execute a Skill de revisão contida em `.agents/plugins/conductor-reload/skills/conductor-review/SKILL.md`. Faça o diálogo interativo de gaps.

4. **Início da Codificação**
   Assim que o Ponto de Revisão confirmar e limpar os gaps técnicos/de negócio:
   - Avance para a codificação automática.
   - Leia e siga a Skill de implementação detalhada em `.agents/plugins/conductor-reload/skills/conductor-implement/SKILL.md`.
   - Lembre-se de rodar primeiro o passo `3.5 Auto-Sincronia Git` de dentro dela se houverem arquivos no git não rastreados!
