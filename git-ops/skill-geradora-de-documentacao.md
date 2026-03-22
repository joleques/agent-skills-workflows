# skill geradora de documentação

📅 Data: 2026-03-22 11:10
🔖 Ticket: Sem ticket
🔗 Commit:
👤 Branch: main

---

## Arquivos Alterados

| Arquivo | Tipo de Alteração |
|---------|-------------------|
| `.agent/skills/api-documentador/README.md` | Novo |
| `.agent/skills/api-documentador/SKILL.md` | Novo |
| `.agent/skills/api-documentador-revisor/README.md` | Novo |
| `.agent/skills/api-documentador-revisor/SKILL.md` | Novo |
| `AGENTS.md` | Modificado |
| `README.md` | Modificado |

---

## Resumo das Alterações

Criação de duas novas skills para documentação de APIs: `api-documentador` e `api-documentador-revisor`. A skill `api-documentador` gera documentação em camadas (técnica, não-técnica ou ambas), particionável por contexto e domínio, atendendo múltiplos públicos-alvo (devs, analistas, suporte). A skill `api-documentador-revisor` valida completude, consistência e qualidade da documentação gerada por camada. O `AGENTS.md` e o `README.md` do projeto foram atualizados para incluir as novas skills na lista de ferramentas ativas e na árvore de diretórios.

---

## Diff Resumido

- **api-documentador/SKILL.md**: Skill completa com inputs (título obrigatório, tipo default `ambas`, descrição e contexto opcionais), templates para 4 camadas (Getting Started, Casos de Uso, Referência Técnica, Suporte), regras de particionamento por contexto/domínio, checklist de completude e quick reference.
- **api-documentador/README.md**: Documentação para humanos com objetivo, inputs, tipos e estrutura de saída.
- **api-documentador-revisor/SKILL.md**: Skill revisora com 9 categorias de análise (completude, qualidade por camada, consistência, particionamento, exemplos), relatório versionado `{titulo}-revision-{versao}.md` e veredicto padrão.
- **api-documentador-revisor/README.md**: Documentação para humanos com critérios de revisão e formato de saída.
- **AGENTS.md**: Adicionadas 2 linhas com as novas skills na seção de ferramentas ativas.
- **README.md**: Adicionadas 2 linhas com as novas skills na árvore de diretórios do projeto.
