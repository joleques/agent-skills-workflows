# ajuste enviar em 2 etapas

📅 Data: 2026-03-20 12:00
🔖 Ticket: Sem ticket
🔗 Commit: 58bd2fa (58bd2fa7d6935d7bb35027cb247c28a647a0026e)
👤 Branch: main

---

## Arquivos Alterados

| Arquivo | Tipo de Alteração |
|---------|-------------------|
| `.agent/skills/git-ops/SKILL.md` | Modificado |
| `.agent/skills/git-ops/scripts/git-enviar.sh` | Modificado |
| `.agent/skills/git-ops/scripts/git-resumo.sh` | Novo |

---

## Resumo das Alterações

Reestruturação do atalho `enviar` da skill Git Ops para dividir a execução em **2 scripts independentes** (`git-resumo.sh` e `git-enviar.sh`), cada um exigindo uma confirmação do usuário. Anteriormente, o diff era capturado como `run_command` avulso e tudo era executado em um único script. Agora, o `git-resumo.sh` faz o `git add .` e captura branch, name-status, stat e diff staged via stdout com delimitadores. O `git-enviar.sh` foi ajustado para focar em commit + push + atualização do hash no resumo via `sed` + amend. O `SKILL.md` foi reescrito refletindo o novo fluxo de 5 passos com 2 confirmações.

---

## Diff Resumido

### `.agent/skills/git-ops/SKILL.md`
- Seção de atalhos reescrita: fluxo de 4 passos → 5 passos com 2 scripts e 2 confirmações
- Adicionado **Passo 3** (`git-resumo.sh`) e **Passo 5** (`git-enviar.sh`) como etapas distintas
- Movido o passo de geração de resumo pelo agente para **Passo 4** (entre os 2 scripts)
- Atualizado o CAUTION para mencionar os 2 scripts e as 2 confirmações
- Removida referência a `run_command` avulso de diff

### `.agent/skills/git-ops/scripts/git-enviar.sh`
- Atualizado cabeçalho de documentação para refletir o novo escopo (commit + push + atualização)
- Comentários internos ajustados (Step 4-5 unificados, remoção do comentário de Step 5 separado)
- Mensagem final alterada de `add → commit → push` para `commit → push`

### `.agent/skills/git-ops/scripts/git-resumo.sh` (NOVO)
- Script criado para encapsular `git add .` + captura de informações de diff
- Valida repositório Git com `set -e`
- Verifica se há alterações staged antes de prosseguir
- Imprime output estruturado com delimitadores (`===BRANCH===`, `===NAME-STATUS===`, `===STAT===`, `===DIFF===`)
