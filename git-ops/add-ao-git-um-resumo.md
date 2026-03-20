# add ao git um resumo

📅 Data: 2026-03-20 11:41
🔖 Ticket: Sem ticket
🔗 Commit: (pendente)
👤 Branch: main

---

## Arquivos Alterados

| Arquivo | Tipo de Alteração |
|---------|-------------------|
| `.agent/skills/git-ops/SKILL.md` | Modificado |
| `.agent/skills/git-ops/scripts/git-enviar.sh` | Modificado |

---

## Resumo das Alterações

A skill Git Ops foi aprimorada para incluir **geração automática de resumo das alterações** no fluxo do atalho `enviar`. Anteriormente, o atalho apenas executava `add + commit + push`. Agora, antes do push, o agente analisa o diff staged e gera um arquivo Markdown com o resumo legível das mudanças, salvo em `git-ops/`. O script `git-enviar.sh` foi refatorado para que o `git add .` seja feito pelo agente (antes do script), permitindo capturar o diff para o resumo. O script agora valida se há alterações staged antes de commitar e faz fallback com `git add .` caso nada esteja staged.

---

## Diff Resumido

### `SKILL.md`
- Descrição do atalho `enviar` atualizada para mencionar "geração automática de resumo"
- Fluxo expandido de 3 para 5 passos: adicionados passos de análise de alterações (passo 3) e atualização do resumo pós-push (passo 5)
- Adicionada seção completa com regras de nomenclatura do arquivo de resumo (kebab-case)
- Adicionado template Markdown do arquivo de resumo (data, ticket, hash, arquivos, resumo, diff)
- Quick Reference atualizada para refletir a geração de resumo

### `git-enviar.sh`
- Removido `git add .` do fluxo principal do script (agora responsabilidade do agente)
- Adicionada verificação de staged changes antes do commit
- Fallback: se nada staged, executa `git add .` e verifica novamente
- Mensagem final ajustada de "add → commit → push" para "commit → push"
