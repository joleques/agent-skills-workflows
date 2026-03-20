# ajuste resumo skill git

📅 Data: 2026-03-20 11:50
🔖 Ticket: Sem ticket
🔗 Commit: 4282c9f (4282c9fa9c50194272d7a6d6a0b29a24498a28c1)
👤 Branch: main

---

## Arquivos Alterados

| Arquivo | Tipo de Alteração |
|---------|-------------------|
| `.agent/skills/git-ops/SKILL.md` | Modificado |
| `.agent/skills/git-ops/scripts/git-enviar.sh` | Modificado |
| `git-ops/add-ao-git-um-resumo.md` | Modificado |

---

## Resumo das Alterações

Refatoração do fluxo do atalho `enviar` na skill Git Ops para tornar a operação completamente atômica. O script `git-enviar.sh` agora encapsula **todo** o ciclo: `add → commit → captura hash → atualiza resumo → amend → push`, eliminando a necessidade de múltiplos `run_command` pelo agente. O SKILL.md foi atualizado para refletir o novo fluxo com 3 parâmetros (mensagem, diretório, caminho do resumo) e incluir o CAUTION contra execuções separadas. O resumo anterior (`add-ao-git-um-resumo.md`) teve o hash atualizado de `(pendente)` para `8dbbeaf`.

---

## Diff Resumido

### `.agent/skills/git-ops/SKILL.md`
- Fluxo do atalho `enviar` simplificado de 5 passos para 4 passos
- Passo 3 agora usa `git diff` (sem staged) com `SafeToAutoRun: true`
- Passo 4 passa 3 parâmetros ao script (mensagem, dir, resumo)
- Removido passo 5 (atualização de hash pós-push) — agora é feito pelo script
- Adicionado CAUTION contra execução separada de add/commit/push
- Template do resumo: campo `🔗 Commit:` agora indica preenchimento automático

### `.agent/skills/git-ops/scripts/git-enviar.sh`
- Adicionado suporte ao 3º parâmetro `$3` (caminho do arquivo de resumo)
- Script agora faz `git add .` internamente (antes dependia do agente)
- Adicionada captura de hash (`git log --format`) após commit
- Adicionada atualização do hash no resumo via `sed`
- Adicionado `git commit --amend --no-edit` para incluir resumo atualizado
- Refatorada validação de staged (simplificada em um único check)

### `git-ops/add-ao-git-um-resumo.md`
- Campo `🔗 Commit:` atualizado de `(pendente)` para `8dbbeaf`
