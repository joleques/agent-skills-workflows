---
Título: Automação — Guia de Configuração
resumo: Guia passo-a-passo para configurar automações usando a API V2, com receitas para cenários comuns e exemplos reais de produção
categoria: Técnica
tags: [configuração, API-V2, passo-a-passo, fieldMappings, searchConnector, conditions, advancedSettings, receitas]
entidades_chave: [Automação, API-V2, Tipo-Padrão, originStrategy, fieldMappings, searchConnector, conditions, advancedSettings]
produto: Automação
---

## O que é necessário para configurar uma Automação (Teoria)

> **Summary:** Para configurar uma Automação é necessário definir três blocos na API V2: o evento (trigger), a ação (metadados) e a automação em si (configuração JSON com contexto, URL, fieldMappings e conector de saída).

Uma Automação é configurada via **API V2** (`POST /automation/v2`) com um JSON dividido em 3 blocos:

| Bloco | Obrigatório | Propósito |
|---|---|---|
| `action` | ✅ | Define metadados da ação: nome, tipo (ex: `CALLBACK`), se está ativa |
| `event` | ✅ | Define o evento/trigger: `moment` (ID do evento) e nome |
| `automation` | ✅ | Configuração real: contexto, URL, fieldMappings, conditions, auth, etc. |

### Dentro do bloco `automation`

O bloco `automation` aceita qualquer JSON válido. Os campos mais comuns:

| Campo | Obrigatório | O que responde |
|---|---|---|
| `context` | ✅ | "De onde vêm os dados?" → HISTORY, TASK, LOCAL ou ANY |
| `entityReference` | ✅ | "Qual template de saída?" → alias do conector de saída (Bumblebee) |
| `url` | ✅ | "Para onde enviar?" → URL da API do cliente (suporta Handlebars) |
| `fieldMappings` | ✅ | "Quais dados enviar?" → mapa de campos usando Tipo Padrão |
| `conditions` | ❌ | "Deve executar?" → barreiras lógicas (AND) |
| `authentication` | ❌ | "Como autenticar?" → Basic, JWT ou OAuth |
| `searchConnector` | ❌ | "Precisa buscar dados extras?" → pré-busca em APIs externas |
| `advancedSettings` | ❌ | "O que acontece depois?" → encadeamento, tradução, encurtador |
| `headers` | ❌ | "Headers HTTP extras?" → mesmo formato de fieldMappings |

### O conceito de Tipo Padrão (FieldMapping)

Todas as configurações dinâmicas usam o **Tipo Padrão** — uma estrutura universal com 3 campos obrigatórios:

| Campo | Obrigatório | Descrição |
|---|---|---|
| `originStrategy` | ✅ | De onde buscar o dado |
| `name` | ✅ | Nome da chave no payload de saída |
| `value` | ✅ | Valor fixo ou rota de busca |

---

## Passo-a-passo: Criar uma Automação simples (Prática)

> **Summary:** Passo-a-passo para criar uma automação simples via API V2, incluindo definição de evento, ação, contexto, URL destino e fieldMappings com diferentes origin strategies.

### 1. Definir o Evento (trigger)

Escolha o `moment` — o ID do evento que dispara a automação:

- `213` → Ao executar uma Atividade
- `219` → Ao editar Local
- `221` → Ao criar Tarefa
- [Ver lista completa de 32 eventos no doc 02-dominio-negocio]

### 2. Definir a Ação

```json
"action": {
    "name": "Nome descritivo da automação",
    "type": "CALLBACK",
    "active": true
}
```

### 3. Definir o Contexto e URL

Escolha o `context` baseado na entidade que origina os dados:

| Se o evento é sobre... | Use context | Dados acessíveis via CONTEXT_FIELD |
|---|---|---|
| Histórico/Atividade | `HISTORY` | `history.*`, `history.task.*`, `history.task.serviceLocal.*` |
| Tarefa | `TASK` | `task.*`, `task.serviceLocal.*` |
| Local | `LOCAL` | `serviceLocal.*` |
| Qualquer / dados externos | `ANY` | ❌ Necessita SEARCH_CONNECTOR |

### 4. Montar os fieldMappings

Cada campo do payload é um Tipo Padrão. Escolha a `originStrategy`:

| Quero enviar... | Use | Exemplo de value |
|---|---|---|
| Um valor fixo | `CONSTANT` | `"true"`, `"30"`, `"jorge"` |
| Um dado do contexto | `CONTEXT_FIELD` | `"serviceLocal.alternativeIdentifier"` |
| Um dado do histórico (por ID) | `HISTORY_FIELD` | `"6289233"` (ID do campo) |
| Um dado de API externa | `SEARCH_CONNECTOR` | `"vendedor.nome"` |
| Um helper Handlebars | `CONSTANT`  | `"{{{ currentDate }}}"` |
| Uma variável de ambiente | `SYSTEM_SETUP` | `"ENV_TOKEN_EXTERNO"` |

### 5. Enviar via MCP tool `create_automation`

O payload completo (com `action`, `event` e `automation`) é enviado como parâmetro da tool `create_automation`. O agente nunca chama a API diretamente.

---

## Receita: Automação ao editar local com CONTEXT_FIELD e SEARCH_CONNECTOR (Prática)

> **Summary:** Exemplo completo de automação configurada para o evento ao editar local (moment 219), usando CONTEXT_FIELD para dados do local e SEARCH_CONNECTOR para dados de API externa, com advancedSettings para assinatura alternativa.

### Cenário

Quando um local é editado na plataforma, criar uma tarefa na API com dados do local e de uma busca externa.

### JSON completo (API V2)

```json
{
    "action": {
        "name": "Automação 2 de editar local",
        "type": "CALLBACK",
        "active": true
    },
    "event": {
        "moment": 219,
        "name": "Ao editar local"
    },
    "automation": {
        "context": "LOCAL",
        "entityReference": "task",
        "url": "https://api.umov.me/v2/task",
        "advancedSettings": {
            "alternativeIdentifier": {
                "originStrategy": "CONTEXT_FIELD",
                "name": "alternativeIdentifier",
                "value": "serviceLocal.id"
            }
        },
        "fieldMappings": [
            {
                "originStrategy": "CONSTANT",
                "name": "active",
                "value": true
            },
            {
                "originStrategy": "CONSTANT",
                "name": "situation",
                "value": "30"
            },
            {
                "originStrategy": "CONTEXT_FIELD",
                "name": "serviceLocal",
                "value": "serviceLocal.alternativeIdentifier"
            },
            {
                "originStrategy": "SEARCH_CONNECTOR",
                "name": "observation",
                "value": "vendedor.nome"
            },
            {
                "originStrategy": "CONTEXT_FIELD",
                "name": "initialDate",
                "value": "{{{ currentDate }}}"
            },
            {
                "originStrategy": "CONSTANT",
                "name": "initialHour",
                "value": "{{{ currentHour }}}"
            },
            {
                "originStrategy": "CONSTANT",
                "name": "activityOriginList",
                "value": "3"
            }
        ]
    }
}
```

### Anotações

| Linha | O que faz |
|---|---|
| `context: LOCAL` | Os dados acessíveis são do Local de Atendimento |
| `entityReference: task` | Template de saída = criação de tarefa |
| `advancedSettings.alternativeIdentifier` | Usa o ID do local como assinatura (identificador externo) |
| `CONSTANT active: true` | Valor fixo — tarefa sempre ativa |
| `CONTEXT_FIELD serviceLocal` | Busca o alternativeIdentifier do local no contexto |
| `SEARCH_CONNECTOR observation` | Busca nome do vendedor em API externa |
| `{{{ currentDate }}}` | Helper Handlebars — data atual |
| `{{{ currentHour }}}` | Helper Handlebars — hora atual |

---

## Receita: Automação com PARTIAL_UPDATE, searchConnector e OBJECT_LIST_FROM_FIELDS (Prática)

> **Summary:** Exemplo de automação que faz atualização parcial (PARTIAL_UPDATE) de um local usando searchConnector para pré-busca de dados e OBJECT_LIST_FROM_FIELDS para montar customFields como lista de objetos.

### Cenário

Ao editar um local, atualizar parcialmente o local na API destino buscando dados de customFields via conector de busca e montando uma lista de campos customizados.

### JSON do bloco automation

```json
{
    "context": "LOCAL",
    "entityReference": "local",
    "entityReferenceId": "referenceId",
    "url": "https://api.umov.me/v2/local/alt-id/{{{format (referenceId content)}}}",
    "action": "PARTIAL_UPDATE",
    "searchConnector": [
        {
            "identifier": "ajustalistaLocal",
            "filters": [
                {
                    "originStrategy": "CONTEXT_FIELD",
                    "name": "id",
                    "value": "serviceLocal.id"
                },
                {
                    "originStrategy": "CONSTANT",
                    "name": "connector_modifier",
                    "value": "local_adservi_modifier"
                }
            ]
        }
    ],
    "fieldMappings": [
        {
            "originStrategy": "CONTEXT_FIELD",
            "name": "referenceId",
            "value": "serviceLocal.alternativeIdentifier"
        },
        {
            "originStrategy": "CONTEXT_FIELD",
            "name": "active",
            "value": "true"
        },
        {
            "originStrategy": "SEARCH_CONNECTOR",
            "name": "status",
            "value": "ajustalistaLocal.local.customFields.1033664.externalValue"
        },
        {
            "originStrategy": "SEARCH_CONNECTOR",
            "name": "setor",
            "value": "ajustalistaLocal.local.customFields.1082015.externalValue"
        },
        {
            "originStrategy": "OBJECT_LIST_FROM_FIELDS",
            "name": "customFields",
            "values": [
                {
                    "originStrategy": "CONSTANT",
                    "name": "customField",
                    "value": "aux_status_leito",
                    "index": 0
                },
                {
                    "originStrategy": "CONSTANT",
                    "name": "value",
                    "value": "{{{status}}}",
                    "index": 0
                },
                {
                    "originStrategy": "CONSTANT",
                    "name": "customField",
                    "value": "aux_setor",
                    "index": 1
                },
                {
                    "originStrategy": "CONSTANT",
                    "name": "value",
                    "value": "{{{setor}}}",
                    "index": 1
                }
            ]
        }
    ]
}
```

### Anotações

| Conceito | Detalhe |
|---|---|
| `action: PARTIAL_UPDATE` | Gera `PATCH` na API destino |
| `entityReferenceId: referenceId` | O campo `referenceId` nos fieldMappings é o identificador único |
| `searchConnector` | Pré-busca: antes de montar o payload, busca dados via conector `ajustalistaLocal` |
| `SEARCH_CONNECTOR value` | Acessa `ajustalistaLocal.local.customFields.ID.externalValue` — resultado da pré-busca |
| `OBJECT_LIST_FROM_FIELDS` | Monta array de objetos. Cada par `customField`+`value` com mesmo `index` vira 1 item |
| `{{{status}}}` e `{{{setor}}}` | Handlebars — referencia os dados dos fieldMappings anteriores durante a transformação |
| URL com Handlebars | `{{{format (referenceId content)}}}` — monta a URL dinamicamente |

---

## Receita: Automação com condições e encadeamento (Prática)

> **Summary:** Exemplo de automação com conditions (barreiras lógicas AND) para filtrar execuções e advancedSettings para encadear a próxima ação em caso de erro.

### Cenário

Ao executar uma atividade, disparar apenas se um campo específico for "true" e encadear notificação de erro caso falhe.

### JSON do bloco automation

```json
{
    "context": "HISTORY",
    "entityReference": "task",
    "url": "https://api.umov.me/v2/task",
    "conditions": [
        {
            "operandLeft": {
                "originStrategy": "HISTORY_FIELD",
                "name": "operandLeft",
                "value": "6289231"
            },
            "operator": "EQUALS",
            "operandRight": {
                "originStrategy": "CONSTANT",
                "name": "operandRight",
                "value": "true"
            }
        }
    ],
    "advancedSettings": {
        "nextActionWhenError": ["Notificar_Email_Suporte"]
    },
    "fieldMappings": [
        {
            "originStrategy": "CONSTANT",
            "name": "active",
            "value": true
        },
        {
            "originStrategy": "HISTORY_FIELD",
            "name": "serviceLocal",
            "value": "6289233"
        },
        {
            "originStrategy": "HISTORY_FIELD",
            "name": "agent",
            "value": "6289232"
        },
        {
            "originStrategy": "HISTORY_FIELD",
            "name": "initialDate",
            "value": "6289236"
        },
        {
            "originStrategy": "CONSTANT",
            "name": "activityOriginList",
            "value": "7"
        }
    ]
}
```

### Anotações

| Conceito | Detalhe |
|---|---|
| `context: HISTORY` | Dados vêm do histórico de execução da atividade |
| `conditions` | Barreira: só executa se campo ID `6289231` = `"true"` |
| `HISTORY_FIELD` | Busca valor pelo ID numérico do campo de atividade no histórico |
| `nextActionWhenError` | Se a chamada falhar, dispara a ação "Notificar_Email_Suporte" |

---

## Receita: Automação com autenticação OAuth e headers customizados (Prática)

> **Summary:** Exemplo de automação com autenticação OAuth2 para obter token e headers HTTP customizados usando SYSTEM_SETUP para injetar variáveis de ambiente como Authorization.

### JSON dos blocos authentication e headers

```json
{
    "authentication": {
        "strategy": {
            "originStrategy": "OBJECT_LIST_FROM_FIELDS",
            "name": "OAuth",
            "values": [
                {
                    "originStrategy": "CONSTANT",
                    "name": "url",
                    "value": "https://api-cliente.com/token",
                    "index": 0
                },
                {
                    "originStrategy": "CONSTANT",
                    "name": "tokenPath",
                    "value": "access_token",
                    "index": 1
                },
                {
                    "originStrategy": "CONSTANT",
                    "name": "auth",
                    "value": "basic",
                    "index": 3
                },
                {
                    "originStrategy": "OBJECT_LIST_FROM_FIELDS",
                    "name": "basic",
                    "index": 4,
                    "values": [
                        {
                            "originStrategy": "CONSTANT",
                            "name": "user",
                            "value": "usuario_api",
                            "index": 0
                        },
                        {
                            "originStrategy": "CONSTANT",
                            "name": "pass",
                            "value": "senha_api",
                            "index": 1
                        }
                    ]
                }
            ]
        }
    },
    "headers": [
        {
            "originStrategy": "SYSTEM_SETUP",
            "name": "Authorization",
            "value": "ENV_MASTER_TOKEN"
        },
        {
            "originStrategy": "CONSTANT",
            "name": "Content-Type",
            "value": "application/json"
        }
    ]
}
```

### Anotações

| Conceito | Detalhe |
|---|---|
| `SYSTEM_SETUP` no header | Injeta variável de ambiente `ENV_MASTER_TOKEN` como Authorization |
| `OAuth > tokenPath` | Caminho no response onde buscar o token (`access_token`) |
| `OAuth > auth: basic` | Primeira autenticação é Basic Auth para obter o token OAuth |
| `headers` | Usa mesma estrutura de Tipo Padrão que fieldMappings |

---

## Referência Completa — advancedSettings (Prática)

> **Summary:** Os advancedSettings permitem configurar encadeamento fixo ou dinâmico de ações, tradução de status HTTP, encurtamento de URLs, adaptadores nativos e identificador alternativo para PARTIAL_UPDATE.

| Campo | Tipo | Descrição |
|---|---|---|
| `nextActionWhenSuccess` | Array de strings | IDs de ações a executar em caso de sucesso |
| `nextActionWhenError` | Array de strings | IDs de ações a executar em caso de erro |
| `chainedEvent` | Tipo Padrão | Encadeamento dinâmico — busca IDs de ações dinamicamente via originStrategy |
| `translation` | Object | Tradução de status HTTP da API destino (mapeia códigos para sucesso/erro) |
| `shortenUrl` | Boolean | Se `true`, encurta URLs nos campos do payload antes de enviar |
| `adapterType` | String | Tipo de adaptador nativo para formatação específica (ex: adaptadores de clientes) |
| `alternativeIdentifier` | Tipo Padrão | Identificador externo para `PARTIAL_UPDATE` — define qual campo é o ID único |

### Exemplo: encadeamento por sucesso e erro

```json
"advancedSettings": {
    "nextActionWhenSuccess": ["12345"],
    "nextActionWhenError": ["67890"]
}
```

### Exemplo: encadeamento dinâmico

```json
"advancedSettings": {
    "chainedEvent": {
        "originStrategy": "CONTEXT_FIELD",
        "name": "chainedEvent",
        "value": "history.task.customFields.CF_nextAction"
    }
}
```

### Exemplo: alternativeIdentifier para PARTIAL_UPDATE

```json
"advancedSettings": {
    "alternativeIdentifier": {
        "originStrategy": "CONTEXT_FIELD",
        "name": "alternativeIdentifier",
        "value": "serviceLocal.id"
    }
}
```

---

## Perguntas frequentes dos usuários (Teoria)

> **Summary:** Respostas para perguntas frequentes sobre configuração de automações, incluindo como diagnosticar erros, quando usar SEARCH_CONNECTOR e como funciona o encadeamento de ações.

### "Como sei qual context usar?"

- Se o evento é sobre **histórico/atividade** (momento 213, 215) → `HISTORY`
- Se o evento é sobre **tarefa** (momento 220, 221, 232) → `TASK`
- Se o evento é sobre **local** (momento 218, 219) → `LOCAL`
- Se os dados não estão no contexto do evento → `ANY` + obrigatório configurar `searchConnector`

### "Quando uso SEARCH_CONNECTOR?"

Use quando precisa de dados que **não estão no contexto da Automação**:
- Buscar dados de outro sistema/API
- Buscar customFields do local quando o context é HISTORY
- Validar informações externas em conditions

### "O que são os IDs numéricos no HISTORY_FIELD?"

São IDs de **campos de atividade** no banco de dados. Cada campo preenchido em uma atividade tem um ID numérico. O `HISTORY_FIELD` busca o valor desse campo específico no histórico.

### "Como funciona o encadeamento?"

Duas abordagens:
- **Fixa:** `advancedSettings.nextActionWhenSuccess` / `nextActionWhenError` com IDs das ações
- **Dinâmica:** `advancedSettings.chainedEvent` com Tipo Padrão (busca IDs dinamicamente)

### "Posso usar Handlebars nos fieldMappings?"

Sim. Helpers como `{{{ currentDate }}}`, `{{{ currentHour }}}` e `{{{format (referenceId content)}}}` podem ser usados em `value` de CONSTANT ou CONTEXT_FIELD.

---

## Troubleshooting — Diagnóstico de erros comuns (Prática)

> **Summary:** Guia de troubleshooting para diagnosticar erros comuns em automações, incluindo automação não executou, erro no Analyzer, circuit breaker aberto, reprocessamento travado e falha de autenticação na API do cliente.

### "Minha automação não executou, o que verificar?"

1. A **Ação** está ativa? (`active: true`) → verificar via `get_automation_by_action`
2. O **Evento** está ativo? → verificar via `get_event`
3. As **conditions** (se houver) estão sendo satisfeitas? → verificar operandos e operador
4. O `context` está compatível com os dados disponíveis? (ex: `CONTEXT_FIELD` em context `ANY` não funciona)
5. O `entityReference` aponta para um conector de saída válido?
6. O `moment` é 213 ou 215 e falta `activityIds`?

### "Erro no Analyzer — o que significa?"

O Analyzer é o serviço que descobre os dados (etapa 2 do pipeline). Erros comuns:
- `analyzer.validation.error` → campo obrigatório faltando ou valor inválido no fieldMappings
- `Action CALLBACK not scheduled` → configuração da ação incompatível com o tipo de agendamento
- Campo com valor `null` quando `IS_NULL` não está em conditions → searchConnector não retornou dados

**Diagnóstico:** use `get_automation_report` com o actionId exato para ver a mensagem de erro completa.

### "Circuit Breaker aberto — e agora?"

1. Verificar estado: `get_circuit_breaker_monitor` com o código da ação
2. Ver quantas notificações na contenção: `get_containment_notifications_count`
3. Listar notificações: `get_containment_notifications`
4. Quando a API do cliente voltar: `resume_reprocessing` para retomar fluxo normal
5. Se houver dados indevidos: `delete_processor_strategy` para limpar

### "Reprocessamento não está funcionando"

1. Verificar se há notificações pendentes no Sentinel: `get_monitor_report`
2. Verificar se o circuit breaker está aberto: `get_circuit_breaker_monitor`
3. Disparar reprocessamento manual: `reprocess_notification` com os actionIds
4. Se precisa reprocessar do início: passar `reprocessFromStart: true`

### "API do cliente retorna erro de autenticação"

1. Verificar se o bloco `authentication` está correto na configuração
2. Para OAuth: validar se `tokenPath` aponta para o campo correto no response de token
3. Para Basic: verificar se `user` e `pass` estão corretos no schema
4. Token expirado: verificar se `cache` está configurado no OAuth para renovação automática