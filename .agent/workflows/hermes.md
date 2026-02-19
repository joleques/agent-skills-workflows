---
description: Orquestra os agentes Documentador e Revisor para processar arquivos .md e gerar documentação RAG-ready
---

# Workflow: Hermes

Este workflow orquestra dois agentes especializados para transformar documentação bruta em documentação estruturada para RAG.

## Pré-requisitos

- Arquivo(s) de entrada em formato `.md`
- Skills disponíveis em:
  - `.agent/skills/documentador/SKILL.md`
  - `.agent/skills/documentador_revisor/SKILL.md`

---

## Passos do Workflow

### 1. Coletar parâmetros do usuário

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

### 2. Executar Agente Documentador

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

### 3. Executar Agente Revisor

Leia a skill do Revisor:

```
.agent/skills/documentador_revisor/SKILL.md
```

Aplique o checklist de validação ao documento gerado no passo anterior. O resultado deve ser:

- **APROVADO**: Prossiga para o passo 5
- **REPROVADO**: Prossiga para o passo 4

### 4. Loop de Correção (se reprovado)

Se o Revisor reprovou o documento:

1. Extraia a lista de não-conformidades do relatório do Revisor
2. Volte ao passo 2, mas agora passe ao Documentador:
   - O documento atual
   - A lista de não-conformidades para correção
3. O Documentador deve ajustar APENAS os pontos indicados
4. Repita o passo 3 (máximo de 3 iterações para evitar loops infinitos)

Se após 3 iterações ainda houver reprovação, notifique o usuário sobre os problemas persistentes.

### 5. Salvar Documento Aprovado

Quando o Revisor aprovar, salve o documento final no diretório de saída informado pelo usuário no passo 1.

- **Arquivo único**: manter o nome original
- **Múltiplos arquivos**: usar o nome informado pelo usuário ou nome do diretório

### 6. Aguardar Validação Manual do Usuário

Após salvar o documento aprovado, use a tool `notify_user` para:

1. Informar ao usuário:
   - Status: APROVADO pelo Revisor ✓
   - Caminho do arquivo gerado
   - Número de iterações necessárias

2. Solicitar confirmação para publicar na Base de Conhecimento:
   - Peça ao usuário para **revisar o documento gerado**
   - Aguarde o **OK explícito** do usuário antes de prosseguir
   - O usuário deve informar também os parâmetros para publicação:
     - `context`: contexto da documentação (ex: "automation", "jira", "api")
     - `isGlobal`: se é documentação global (`true`) ou específica do cliente (`false`)

⚠️ **NÃO prossiga para o passo 7 sem o OK do usuário.**

---

### 7. Notificar Conclusão Final

Informe ao usuário:

- Status: FINALIZADO ✅
- Arquivo pronto para publicação na Base de Conhecimento
- Contexto e escopo utilizados

---

## Exemplo de Uso

**Arquivo único:**

```
/hermes

> Quais arquivos você quer processar?
exemplos-para-testes/documentador/file-in/resiliencia.md

> Onde salvar?
./docs/output

> Processando resiliencia.md...
> Status: APROVADO pelo Revisor ✓
> Arquivo salvo em: ./docs/output/resiliencia.md
>
> Por favor, revise o documento e confirme se deseja publicar na Base de Conhecimento.
> Informe: context (ex: "automation") e isGlobal (true/false)

[Usuário confirma: context="automation", isGlobal=true]

> Publicando na Base de Conhecimento...
> Status: PUBLICADO ✅
```

**Diretório (múltiplos arquivos → documento consolidado):**

```
/hermes

> Quais arquivos você quer processar?
exemplos-para-testes/documentador/file-in/

> Onde salvar?
./docs/output

> Nome do arquivo consolidado?
resiliencia_completo.md

> Lendo 4 arquivos do diretório...
> Gerando documentação consolidada...
> Status: APROVADO pelo Revisor ✓
> Arquivo salvo em: ./docs/output/resiliencia_completo.md
>
> Por favor, revise o documento e confirme se deseja publicar na Base de Conhecimento.
> Informe: context (ex: "jira") e isGlobal (true/false)

[Usuário confirma: context="jira", isGlobal=false]

> Publicando na Base de Conhecimento...
> Status: PUBLICADO ✅
```
