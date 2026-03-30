---
Título: Automação — Dados e Contratos
resumo: Modelos de dados, estrutura de configuração JSON, schemas de autenticação e contratos de API do produto Automação
categoria: Técnica
tags: [dados, MongoDB, fieldMappings, JSON, contratos, configuração, templates, Handlebars]
entidades_chave: [MongoDB, Redis, fieldMappings, originStrategy, entityReference, authentication, searchConnector, Handlebars]
produto: Automação
---

## Banco de Dados (Teoria)

> **Summary:** Cada microsserviço da Automação possui seu próprio banco MongoDB (database per service), com Redis utilizado adicionalmente como cache e distributed locks.

- **Tecnologia:** MongoDB
- **Estratégia:** Cada serviço possui seu próprio banco (database per service)
- **Cache/Locks:** Redis

---

## Estrutura de Configuração da Automação (Teoria)

> **Summary:** A configuração de uma Automação é um documento JSON que define o contexto, conector de saída (entityReference), URL destino, action e o mapa de campos (fieldMappings) com estratégias dinâmicas de origem de dados.

### Campos principais da configuração

| Campo | Tipo | Descrição | Valores possíveis |
|---|---|---|---|
| `context` | String | Contexto da Automação | **Sim** | `HISTORY`, `TASK`, `LOCAL`, `ANY` |
| `url` | String | URL destino da API do cliente (suporta Handlebars) | **Sim** | Template URL |
| `entityReference` | String | Referência ao conector de saída (template) | **Sim** | Alias do conector |
| `entityReferenceId` | String | Campo no fieldMappings que define o ID único da API do cliente | Não | Valor alfanumérico |
| `action` | String | Tipo de operação na API destino | Não | `INSERT` (POST, padrão), `UPDATE` (PUT), `PARTIAL_UPDATE` (PATCH) |
| `target` | Numérico | ID do ambiente de destino ou código do cliente para roteamento | Não | Números inteiros |
| `fieldMappings` | Array | Mapa de campos — o "de" (payload) | **Sim** | Array de Tipo Padrão |
| `headers` | Array | Cabeçalhos HTTP customizados (mesma estrutura do fieldMappings) | Não | Array de Tipo Padrão |
| `conditions` | Array | Condições lógicas (barreiras) | Não | Array de operandLeft/operator/operandRight |
| `authentication` | Object | Configuração de autenticação | Não | Objeto com strategy |
| `searchConnector` | Array | Conectores de busca (pré-busca) | Não | Array com identifier, component, filters |
| `advancedSettings` | Object | Config. avançadas (encadeamento, tradução, encurtador, adaptador) | Não | Objeto estrutural |
| `grouper` | Object | Agrupador de execuções em pacotes controlados | Não | Objeto com identifier e order |
| `reprocess` | Array | Política de retentativa configurável (serviço e estratégia) | Não | Array com service e strategy |

---

## Exemplo Completo — Configuração de Automação (Prática)

> **Summary:** Exemplo prático de configuração JSON de uma Automação com context HISTORY, conector de saída task, ação PARTIAL_UPDATE e fieldMappings usando originStrategy CONTEXT_FIELD e HISTORY_FIELD.

### Exemplo resumido de configuração

```json
{
    "context": "HISTORY",
    "entityReference": "task",
    "entityReferenceId": "taskAltId",
    "url": "https://dese-api.umov.me/v2/task/alt-id/{{{format (referenceId content)}}}",
    "action": "PARTIAL_UPDATE",
    "fieldMappings": [
        {
            "originStrategy": "FIELD",
            "name": "taskAltId",
            "value": "6339308"
        }
    ]
}
```

---

## Template Handlebars — Conector de Saída (Prática)

> **Summary:** Os templates de conector de saída (de-para) usam Handlebars com helpers customizados para transformar dados em JSON compatível com a API do cliente, suportando campos condicionais, listas, formatação de datas e iteração.

### Helpers Handlebars disponíveis

| Helper | Descrição |
|---|---|
| `format` | Formata valor para output |
| `formatDate` | Formata data |
| `hasAny` | Condicional — renderiza bloco se algum parâmetro existir |
| `pipeToArray` | Converte pipe-separated string em array |
| `#each` | Iteração sobre listas |
| `#unless @last` | Controle de vírgula no último item |
| `referenceId` | Busca referência de ID no conteúdo |

### Exemplo de template (trecho — conector task)

```handlebars
{
    "alternativeIdentifier": {{{format alternativeIdentifier}}},
    "active": {{{format active}}},
    {{#hasAny taskType taskTypeId}}
    "taskType": {
        "alternativeIdentifier": {{{format taskType}}},
        "id": {{{format taskTypeId}}}
    },
    {{/hasAny}}
    "initialDate": {{{format (formatDate initialDate)}}},
    "customFields": [
        {{#each customFields}}
        {
            "alternativeIdentifier": {{{format customField}}},
            "value": {{{format value}}}
        }{{#unless @last}},{{/unless}}
        {{/each}}
    ]
}
```

---

## Contratos de API — Automação (Prática)

> **Summary:** O Automation Management expõe a API V2 com autenticação JWT, suportando CRUD completo de automações via MCP tools (`create_automation`, `update_automation`, `get_automation_by_action`).

### API V2 — Criar Automação → MCP tool: `create_automation`

```
POST https://automation-api.umov.me/automation/v2
Content-Type: application/json
Authorization: JWT Token
```

```json
{
  "action": { "name": "Criar tarefa ao executar atividade", "type": "CALLBACK", "active": true, "order": 1 },
  "event": { "moment": 213, "name": "Ao executar uma atividade", "activityIds": [1103379] },
  "automation": {
    "context": "HISTORY",
    "entityReference": "task",
    "url": "https://api.umov.me/v2/task",
    "fieldMappings": [
      { "originStrategy": "CONSTANT", "name": "active", "value": true },
      { "originStrategy": "CONTEXT_FIELD", "name": "serviceLocal", "value": "history.task.serviceLocal.alternativeIdentifier" },
      { "originStrategy": "HISTORY_FIELD", "name": "agent", "value": "6289232" },
      { "originStrategy": "CONSTANT", "name": "activityOriginList", "value": "7" }
    ]
  }
}
```

Resposta: `201` com `actionId`.

---

## Schemas de Autenticação (Prática)

> **Summary:** Os schemas de autenticação da Automação seguem o padrão originStrategy com OBJECT_LIST_FROM_FIELDS como raiz, suportando Basic (user/pass ou hash), JWT (hash) e OAuth (url, tokenPath, auth, cache).

### Schema Basic Auth

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `strategy.originStrategy` | String | ✅ | Sempre `OBJECT_LIST_FROM_FIELDS` |
| `strategy.name` | String | ✅ | `basic` |
| `strategy.values[].name` | String | ✅ | `user`, `pass` ou `hash` |
| `strategy.values[].value` | String | ✅ | Valor da credencial |
| `strategy.values[].index` | Number | ✅ | Ordem do campo |

### Schema OAuth

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `values[0].name=url` | String | ✅ | URL de autorização |
| `values[1].name=tokenPath` | String | ✅ | Caminho no response para o token |
| `values[2].name=hashReturnType` | String | ❌ | Tipo de retorno (`JWT`) |
| `values[3].name=auth` | String | ✅ | Tipo: `basic`, `header`, `body` |
| `values[4]` | Object | ✅ | Credenciais conforme `auth` |
| `values[5].name=cache` | Object | ❌ | Configuração de cache de token |
