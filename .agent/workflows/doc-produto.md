---
description: Orquestra as skills product-interviewer, product-interviewer-revisor, product-context-aggregator e product-documenter para gerar documentação de produto RAG-ready com ciclo de revisão automática (máx 5x). Absorve a funcionalidade do antigo workflow /hermes.
---

# Workflow: Documentação de Produto

Este workflow orquestra quatro agentes especializados para extrair conhecimento de produto do usuário e transformá-lo em documentação canônica otimizada para Base de Conhecimento de Agentes de IA.

Suporta dois modos de operação:
- **Modo Completo** (recomendado) — Entrevista interativa + pipeline completo
- **Modo Rápido** — Transformação direta de `.md` existentes em formato RAG-ready (funcionalidade herdada do antigo workflow `/hermes`)

## Pré-requisitos

- Skills disponíveis em:
  - `.agent/skills/product-interviewer/SKILL.md`
  - `.agent/skills/product-interviewer-revisor/SKILL.md`
  - `.agent/skills/product-context-aggregator/SKILL.md`
  - `.agent/skills/product-documenter/SKILL.md`
  - `.agent/skills/documentador/SKILL.md` (padrão de formato RAG)
  - `.agent/skills/documentador_revisor/SKILL.md` (revisão no modo rápido)

---

## Passos do Workflow

### 1. Triagem de Modo

Pergunte ao usuário:

```
┌─────────────────────────────────────────────────────────────────┐
│  Você já tem documentação existente (.md) sobre o produto,      │
│  ou vamos extrair o conhecimento do zero?                       │
│                                                                  │
│  🟢 MODO COMPLETO (recomendado)                                  │
│     → Entrevista interativa + pipeline completo                  │
│     → Se já tem docs, eles serão usados como contexto adicional  │
│                                                                  │
│  ⚡ MODO RÁPIDO                                                  │
│     → Transforma .md existentes direto em formato RAG-ready      │
│     → Sem entrevista, sem fases extras                           │
└─────────────────────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> **Recomendação forte para Modo Completo:** Mesmo que o usuário já tenha documentação escrita, **recomende fortemente** o Modo Completo. A entrevista interativa captura **conhecimento tácito** que documentação escrita raramente cobre — dubiedades, edge cases, decisões não documentadas e regras implícitas. Os `.md` existentes não são desperdiçados: eles são incorporados como **contexto adicional** na Fase 1.5 (via symlinks em `extra/`), enriquecendo o resultado final. A documentação escrita é um excelente ponto de partida, mas nunca substitui a extração direta do especialista.

**Se o usuário escolher Modo Completo (ou aceitar a recomendação):**
- Prossiga para o **Passo 2** (fluxo completo)

**Se o usuário insistir no Modo Rápido:**
- Prossiga para o **Passo 1.R** (fluxo rápido)

---

### 1.R. Modo Rápido — Transformação Direta (herdado do /hermes)

> [!NOTE]
> Este modo replica a funcionalidade do antigo workflow `/hermes`. Use apenas quando o usuário deseja uma transformação rápida de `.md` existentes sem entrevista.

Pergunte ao usuário:

1. **Arquivos de entrada**: Quais arquivos `.md` devem ser processados? Pode ser:
   - Um único arquivo (caminho absoluto ou relativo)
   - Múltiplos arquivos (lista separada por vírgula)
   - Um diretório inteiro (processar todos os `.md` dentro)
   - O arquivo ativo no editor (se o usuário não especificar)

2. **Diretório de saída**: Onde salvar o documento aprovado?
   - Caminho absoluto ou relativo para o diretório de destino
   - Se não especificado, usar `exemplos-para-testes/documentador/file-out/` como padrão

3. **Nome do arquivo de saída** (apenas se múltiplos arquivos):
   - Nome para o documento consolidado (ex: `resiliencia_completo.md`)
   - Se não especificado, usar o nome do primeiro arquivo ou do diretório

Aguarde a resposta antes de prosseguir.

#### 1.R.1. Executar Agente Documentador

Leia a skill do Documentador:

```
.agent/skills/documentador/SKILL.md
```

**REGRA IMPORTANTE**:

- Se a entrada for **UM ÚNICO arquivo**: gerar UM documento a partir dele
- Se a entrada for **MÚLTIPLOS arquivos ou diretório**: ler TODO o conteúdo de TODOS os arquivos e gerar **UM ÚNICO documento consolidado** que abrange todo o conhecimento contido nos arquivos

Aplique as regras do system prompt para gerar um documento Markdown estruturado com:

- Bloco YAML de metadados
- `## Visão Geral (Teoria)`
- `## Fundamentos e Regras Conceituais (Teoria)`
- `## Detalhamento e Implementação (Prática)` (se aplicável)

Salve o resultado intermediário mentalmente ou em variável para o próximo passo.

#### 1.R.2. Executar Agente Revisor

Leia a skill do Revisor:

```
.agent/skills/documentador_revisor/SKILL.md
```

Aplique o checklist de validação ao documento gerado no passo anterior. O resultado deve ser:

- **APROVADO**: Prossiga para o passo 1.R.4
- **REPROVADO**: Prossiga para o passo 1.R.3

#### 1.R.3. Loop de Correção (se reprovado)

Se o Revisor reprovou o documento:

1. Extraia a lista de não-conformidades do relatório do Revisor
2. Volte ao passo 1.R.1, mas agora passe ao Documentador:
   - O documento atual
   - A lista de não-conformidades para correção
3. O Documentador deve ajustar APENAS os pontos indicados
4. Repita o passo 1.R.2 (máximo de 3 iterações para evitar loops infinitos)

Se após 3 iterações ainda houver reprovação, notifique o usuário sobre os problemas persistentes.

#### 1.R.4. Salvar e Notificar

Quando o Revisor aprovar, salve o documento final no diretório de saída informado pelo usuário.

- **Arquivo único**: manter o nome original
- **Múltiplos arquivos**: usar o nome informado pelo usuário ou nome do diretório

Use a tool `notify_user` para informar:

```
✅ Documentação RAG-ready APROVADA (Modo Rápido)

📄 Arquivo: [caminho do arquivo gerado]
🔄 Iterações: [N]/3
📂 Formato: Documentador RAG (Teoria/Prática + chunking semântico)
```

Inclua o caminho do arquivo em `PathsToReview`.

**⚠️ O workflow ENCERRA aqui no Modo Rápido. Os passos abaixo são exclusivos do Modo Completo.**

---

### 2. Coletar Parâmetros Iniciais

Pergunte ao usuário:

1. **Título do produto/sistema** — será usado como `{titulo}` em `kebab-case` para o diretório
2. **Resumo em uma frase** — "O que é esse produto em uma frase?"
3. **Recursos depreciados** — "Existe alguma versão de API, campo, recurso ou funcionalidade depreciada que o agente NÃO deve aprender? Se sim, liste-os para que sejam excluídos da documentação."

Aguarde a resposta antes de prosseguir.

Após receber, defina o diretório base de trabalho:

```
/documentacao/{titulo}/
├── contexto/   ← Fase 1: entrevista
├── extra/      ← Fase 1.5: symlinks para artefatos extras
└── docs/       ← Fase 2: documentação final RAG-ready
```

Crie as pastas automaticamente caso não existam.

Se o usuário informou recursos depreciados, registre-os em `/documentacao/{titulo}/contexto/depreciados.md` para uso nas fases seguintes.

---

### 3. Fase 1 — Entrevista (Skill product-interviewer)

Leia a skill do Entrevistador:

```
.agent/skills/product-interviewer/SKILL.md
```

Execute a skill passando:
- **Título** informado pelo usuário
- **Diretório de output:** `/documentacao/{titulo}/contexto/`

A skill conduzirá a entrevista interativa com o usuário, cobrindo os 7 eixos temáticos.

> [!IMPORTANT]
> A entrevista é **interativa** — o agente pergunta e o usuário responde. Não encerre a entrevista até que todos os eixos relevantes estejam cobertos com profundidade suficiente.

Ao finalizar, a skill gerará os arquivos temáticos e o `entrevista-log.md`.

---

### 4. Fase 1 — Revisão (Skill product-interviewer-revisor)

Leia a skill do Revisor:

```
.agent/skills/product-interviewer-revisor/SKILL.md
```

Execute a skill passando o diretório `/documentacao/{titulo}/contexto/` com todos os artefatos gerados.

O resultado deve ser:

- **✅ APROVADO**: Prossiga para o passo 5
- **⚠️ APROFUNDAR** ou **❌ INSUFICIENTE**: Prossiga para o passo 4.1

---

### 4.1. Loop de Aprofundamento (se não aprovado)

Se o Revisor não aprovou o contexto:

1. Extraia as **perguntas pendentes** do relatório do Revisor
2. Apresente as perguntas ao usuário e colete as respostas
3. Atualize os arquivos temáticos e o `entrevista-log.md` com as novas respostas
4. Volte ao passo 4 (revisão)

**Regra do loop:**

```
┌──────────────────────────────────────────────────────────────────┐
│  Iteração 1–4: Revisor reprova → Entrevistador aprofunda        │
│  Iteração 5:   Se ainda reprovado → PARA                        │
│                Prossegue com ressalvas                           │
└──────────────────────────────────────────────────────────────────┘
```

- **Máximo de 5 iterações** (entrevista + revisão) para evitar loops infinitos
- A cada iteração, registre o número da iteração atual
- Se após 5 iterações ainda houver problemas, prossiga para o passo 5 com ressalvas

---

### 5. Fase 1.5 — Artefatos Extras (Skill product-context-aggregator)

Leia a skill do Agregador:

```
.agent/skills/product-context-aggregator/SKILL.md
```

Execute a skill passando:
- **Título** do produto
- **Diretório base:** `/documentacao/{titulo}/`

A skill perguntará ao usuário se há diretórios extras com documentação existente.

**Perguntas adicionais obrigatórias:**

1. **Logs de queries reais:** "Você possui logs de perguntas reais de usuários (ex: langfuse, analytics, suporte)? Se sim, informe o caminho — usarei para gerar FAQ e troubleshooting mais assertivos."
2. **Datasets de treinamento:** "Existe algum dataset de treinamento (JSONL, CSV) existente que possa servir de referência? Se sim, informe o caminho."

**Se houver artefatos extras ou logs:**
- Cria symlinks em `/documentacao/{titulo}/extra/`
- Analisa os artefatos
- Gera `contexto-consolidado.md`

**Se não houver:**
- Sinaliza que o fluxo pode prosseguir direto para a Fase 1.5b

---

### 5.1. Fase 1.5b — Contexto do Agente

Verifique se existe um arquivo de contexto do agente:

```
/documentacao/{titulo}/contexto/context_agent_*.md
```

**Se existir:**

1. Leia o arquivo de contexto do agente
2. Cruze o conteúdo do contexto com os artefatos da entrevista (Fase 1) e extras (Fase 1.5)
3. Identifique:
   - **Gaps:** Campos, ferramentas ou regras mencionados no contexto sem cobertura na base de conhecimento
   - **Redundâncias:** Informação detalhada no contexto que deveria estar na RAG (exemplos completos, tabelas extensas)
   - **Conflitos:** Informações no contexto que contradizem os artefatos da entrevista
4. Registre os achados em `/documentacao/{titulo}/contexto/analise-contexto-rag.md`
5. O documentador (Fase 2) deve consumir essa análise para garantir cobertura dos gaps

**Se NÃO existir:**

Pergunte ao usuário:

> "Não encontrei um arquivo de contexto do agente (`context_agent_*.md`). Esse arquivo define guardrails, regras de comportamento e ferramentas disponíveis para o agente que consumirá esta base de conhecimento.
>
> Gostaria que eu gere uma versão inicial desse contexto baseado no que já coletamos na entrevista? Ele incluirá:
> - Tabela de campos/parâmetros obrigatórios do domínio
> - Lista de ferramentas MCP (se aplicável)
> - Guardrails de formato (anti-hallucination)
> - Jornada interativa para as operações principais
> - Tópicos-âncora para busca semântica"

Se o usuário aceitar, gere o contexto em `/documentacao/{titulo}/contexto/context_agent_{titulo}.md` seguindo as boas práticas:

| O que colocar no CONTEXTO | O que deixar na RAG |
|---|---|
| Tabelas compactas de referência (campos, valores válidos) | Exemplos completos com dados reais |
| JSON skeleton (estrutura mínima correta) | Receitas e cenários detalhados |
| Lista de ferramentas/tools disponíveis | Regras de negócio detalhadas |
| Guardrails de formato (anti-hallucination) | Troubleshooting e FAQ |
| Jornada interativa (passos de conversação) | Histórico e evolução |

---

### 6. Fase 2 — Documentação (Skill product-documenter)

Leia a skill do Documentador:

```
.agent/skills/product-documenter/SKILL.md
```

Execute a skill passando todo o contexto disponível:
- `/documentacao/{titulo}/contexto/` (Fase 1)
- `/documentacao/{titulo}/extra/` (Fase 1.5, se houver)
- `contexto-consolidado.md` (se houver)
- `analise-contexto-rag.md` (se houver — Fase 1.5b)
- `depreciados.md` (se houver — Passo 2)

A skill gerará a documentação final em `/documentacao/{titulo}/docs/` seguindo o padrão Documentador RAG.

**Regras adicionais para o documentador:**

> [!IMPORTANT]
> **Guardrail anti-depreciação:** Se existir `depreciados.md`, o documentador NÃO deve incluir na documentação APIs, campos, recursos ou versões listados como depreciados. Se for necessário mencioná-los para contexto histórico, devem estar CLARAMENTE marcados como `⚠️ Depreciado` e isolados em chunk específico do doc de Histórico e Evolução.

> [!IMPORTANT]
> **Separação Contexto vs RAG:** A documentação RAG deve conter:
> - Exemplos detalhados com dados reais de produção
> - Receitas (cenários completos com JSON)
> - Regras de negócio e domínio
> - Troubleshooting e FAQ
> - Referências técnicas detalhadas
>
> A documentação RAG NÃO deve conter:
> - Regras de comportamento do agente (isso é do contexto)
> - Decisões de roteamento RAG vs MCP (isso é do contexto)
> - Tabelas compactas de referência que já estejam no contexto do agente

> [!IMPORTANT]
> **Chunk de troubleshooting obrigatório:** Para cada documento que contenha funcionalidades ou operações, o documentador DEVE gerar um chunk de troubleshooting com:
> - Cenários de erro comuns em formato "Problema → Diagnóstico → Solução"
> - Referência a ferramentas MCP para diagnóstico (se aplicável)
> - Se existirem logs de queries reais (langfuse/analytics em `extra/`), usar as perguntas mais frequentes para guiar os cenários

---

### 6.1. Validação de Exemplos Reais

Após a geração dos documentos (Passo 6), execute uma varredura em TODOS os arquivos `.md` gerados em `/documentacao/{titulo}/docs/`:

1. **Busque por exemplos genéricos/placeholders:**
   - Nomes genéricos: `"teste"`, `"nome"`, `"valor"`, `"config"`, `"exemplo"`
   - URLs fictícias: `exemplo.com`, `api.cliente.com`, `empresa.com`, `placeholder`
   - IDs fictícios: `123`, `456`, `12345`
   - Payloads vazios: `"campo": "qualquer JSON válido"`, `{...}`, `[...]`

2. **Para cada ocorrência encontrada:**
   - Substitua por dados reais de produção (se disponíveis nos artefatos extras)
   - Ou por dados realistas e específicos do domínio (extraídos da entrevista)
   - Nomes de ações devem ser descritivos (ex: `"Criar tarefa ao executar atividade"` ao invés de `"teste 123"`)

3. **Registre as substituições** em log para auditoria

> [!CAUTION]
> Exemplos genéricos em chunks RAG podem causar hallucination no agente consumidor. Se o agente recupera um chunk com `"config": "valor"` como exemplo, pode usar esse padrão para gerar payloads incorretos.

---

### 6.2. Validação de Summaries

Após a validação de exemplos (Passo 6.1), re-valide TODOS os campos `> **Summary:**` nos documentos gerados:

1. **Verifique que cada Summary:**
   - NÃO referencia termos depreciados (cruzar com `depreciados.md`)
   - É suficientemente específico para funcionar como embedding de busca semântica
   - Contém as entidades-chave do chunk (para melhorar recall na busca vetorial)
   - NÃO é genérico demais (ex: `"Exemplo de configuração"` — ruim; `"Exemplo de automação com PARTIAL_UPDATE e OBJECT_LIST_FROM_FIELDS para montar customFields"` — bom)

2. **Corrija summaries que falharem** nas validações acima

---

### 7. Notificar Usuário

Use a tool `notify_user` para informar ao usuário:

**Se todo o fluxo foi aprovado:**

```
✅ Documentação de Produto CONCLUÍDA (Modo Completo)

📁 Diretório: /documentacao/{titulo}/docs/
📄 Documentos gerados: [lista]
🔄 Iterações de revisão: [N]/5
📎 Artefatos extras: [N] diretórios (ou "nenhum")
🧠 Contexto do agente: [gerado/existente/não solicitado]
🧹 Exemplos corrigidos: [N] substituições
📝 Summaries validados: [N] correções

Estrutura final:
  /documentacao/{titulo}/
  ├── contexto/   ← Entrevista (Fase 1) + contexto do agente
  ├── extra/      ← Symlinks extras (Fase 1.5)
  └── docs/       ← Documentação RAG-ready (Fase 2)
```

**Se houve ressalvas:**

```
⚠️ Documentação gerada com RESSALVAS (Modo Completo)

📁 Diretório: /documentacao/{titulo}/docs/
🔄 Iterações: 5/5 (limite atingido)

Problemas pendentes do revisor:
- [lista dos problemas que o Revisor ainda apontou]

Recomendação: considere complementar manualmente os pontos acima.
```

Inclua o caminho do diretório `docs/` em `PathsToReview`.

---

## Exemplos de Uso

### Modo Completo (recomendado)

```
/doc-produto

> Como deseja gerar a documentação?
> 🟢 Modo Completo (recomendado) ou ⚡ Modo Rápido?
Modo Completo

> Qual o título do produto/sistema?
automacao

> Resumo em uma frase?
Módulo de integração entre APIs via triggers e conectores da plataforma umov.me.

> Existe recurso depreciado que o agente NÃO deve aprender?
Sim: API V1 do Automation Management e o originStrategy FIELD.

> 📁 Diretório criado: /documentacao/automacao/

> 🎙️ Iniciando entrevista (Fase 1)...
> Pergunta 1: O que o produto faz exatamente?
(... entrevista interativa ...)

> 🔍 Revisando contexto (iteração 1/5)...
> ⚠️ APROFUNDAR — 3 perguntas pendentes
> (... loop de aprofundamento ...)

> 🔍 Revisando contexto (iteração 2/5)...
> ✅ APROVADO

> 📎 Fase 1.5 — Artefatos extras?
> Sim: /home/jorge/projeto/wiki-docs, /home/jorge/projeto/automations
> Logs de queries reais? Sim: /home/jorge/projeto/langfuse.jsonl

> 🧠 Fase 1.5b — Contexto do agente?
> Encontrado: context_agent_automacao.md
> Analisando gaps entre contexto e base...
> 3 gaps identificados, serão cobertos na Fase 2.

> 📖 Gerando documentação RAG-ready (Fase 2)...
> 🧹 Validando exemplos — 4 placeholders substituídos por dados reais
> 📝 Validando summaries — 1 correção aplicada
> ✅ Documentação concluída!

> 📁 /documentacao/automacao/docs/
```

### Modo Rápido

```
/doc-produto

> Como deseja gerar a documentação?
> 🟢 Modo Completo (recomendado) ou ⚡ Modo Rápido?
Modo Rápido

> Quais arquivos você quer processar?
exemplos-para-testes/documentador/file-in/resiliencia.md

> Onde salvar?
./docs/output

> Processando resiliencia.md...
> Status: APROVADO pelo Revisor ✓ (iteração 1/3)
> ✅ Arquivo salvo em: ./docs/output/resiliencia.md
```
