# add social-media-psychology

📅 Data: 2026-03-22 17:04
🔖 Ticket: Sem ticket
🔗 Commit: b2c047b (b2c047bce0882d25f2775905e787f162e9af1e9c)
👤 Branch: main

---

## Arquivos Alterados

| Arquivo | Tipo de Alteração |
|---------|-------------------|
| `.agent/skills/social-media-psychology/SKILL.md` | Novo |
| `.agent/skills/social-media-psychology/README.md` | Novo |
| `AGENTS.md` | Modificado |
| `README.md` | Modificado |
| `.agent/workflows/write-tech-article.md` | Modificado |

---

## Resumo das Alterações

Criada a nova skill `social-media-psychology` — módulo de conhecimento consultivo sobre psicologia de redes sociais e algoritmos de distribuição (LinkedIn e Instagram). A skill opera em dois modos: **Consulta** (diretrizes antes da escrita) e **Revisão** (checklist de conformidade após escrita). Cobre 4 pilares: algoritmos de distribuição por plataforma, princípios de persuasão de Cialdini, vieses cognitivos aplicáveis e engenharia de hooks/anti-patterns.

O workflow `write-tech-article` foi atualizado com integração **condicional**: a skill é acionada somente quando o formato alvo é de rede social (Post LinkedIn), sendo pulada para artigos de blog. Foram adicionados passos de consulta antes da escrita (passo 4), revisão de engajamento após o revisor técnico (passo 6.5), e consulta+revisão no Designer (passos 10.1 e 10.3).

---

## Diff Resumido

### `.agent/skills/social-media-psychology/SKILL.md` (Novo)
- Skill completa (~380 linhas) com 4 pilares de conhecimento
- Dois templates de output: Diretrizes de Otimização (Consulta) e Checklist de Conformidade (Revisão)
- Inputs definidos: `plataforma_alvo`, `formato`, `conteudo_base`, `objetivo`
- Integração por composição com `engineering-writer`, `designer`, posters

### `.agent/skills/social-media-psychology/README.md` (Novo)
- Documentação para humanos com visão geral, pilares, plataformas e integração

### `AGENTS.md` (Modificado)
- Adicionada entrada `social-media-psychology` na lista de Ferramentas Ativas (Skills)

### `README.md` (Modificado)
- Adicionada `social-media-psychology/` na árvore de diretórios do projeto

### `.agent/workflows/write-tech-article.md` (Modificado)
- Adicionada `social-media-psychology` nos pré-requisitos
- Reformuladas opções de formato (rede social vs blog)
- Novo passo 4: Consulta condicional antes da escrita
- Novo passo 6.5: Revisão de engajamento condicional após revisor técnico
- Novos sub-passos 10.1/10.3: Consulta e revisão condicional no Designer
- Renumerados passos 5-10 (antes eram 4-9)
- Dois exemplos de uso: blog (sem skill) e Post LinkedIn (com skill)
