# ajuste documentação das skills e workflow

📅 Data: 2026-03-20 12:09
🔖 Ticket: Sem ticket
🔗 Commit: 7ab8f98 (7ab8f9810ae196be018867fdc3d3f7e555f76248)
👤 Branch: main

---

## Arquivos Alterados

| Arquivo | Tipo de Alteração |
|---------|-------------------|
| `AGENTS.md` | Modificado |
| `README.md` | Modificado |
| `.agent/skills/git-ops/README.md` | Novo |
| `.agent/skills/git-ops/scripts/git-resumo.sh` | Novo |
| `.agent/skills/git-ops/scripts/git-enviar.sh` | Modificado |
| `.agent/skills/git-ops/SKILL.md` | Modificado |

---

## Resumo das Alterações

Atualização da documentação do projeto e da skill git-ops. O `README.md` do projeto foi atualizado para incluir 6 skills que estavam faltando (answers-questions, answers-questions-revisor, dataset-synthesizer, dataset-synthesizer-revisor, git-ops, researcher) e o workflow `/fine-tuning-gemini` na árvore de diretórios e tabela de workflows. O `AGENTS.md` recebeu a inclusão da skill `git-ops` na lista de ferramentas ativas. Foi criado o `README.md` da skill git-ops seguindo o padrão do projeto. Os scripts `git-resumo.sh` (captura de diff) e `git-enviar.sh` (commit + push + atualização de resumo) foram criados/atualizados com a abordagem de 2 scripts para minimizar confirmações. O `SKILL.md` da skill git-ops foi atualizado para documentar o fluxo completo com geração de resumo.

---

## Diff Resumido

- **AGENTS.md**: Adicionada entrada `git-ops` na lista de skills ativas
- **README.md**: Adicionadas 6 skills (answers-questions, dataset-synthesizer, git-ops, researcher e suas variantes) e 1 workflow (fine-tuning-gemini) na árvore de diretórios e tabela
- **git-ops/README.md** (NOVO): Documentação completa da skill — parâmetros, 14 operações suportadas, atalho `enviar`, fluxo obrigatório, exemplos de uso
- **git-ops/scripts/git-resumo.sh** (NOVO): Script que faz `git add .` e captura branch, name-status, stat e diff completo via stdout
- **git-ops/scripts/git-enviar.sh**: Reescrito para funcionar com resumo — add, commit, captura hash, atualiza hash no resumo via sed, amend e push
- **git-ops/SKILL.md**: Atualizado com fluxo de 2 scripts, remoção da preferência de terminal, simplificação da resolução de diretório
