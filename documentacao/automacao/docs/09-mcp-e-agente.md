---
Título: Automação — MCP e Agente Especialista
resumo: Documentação do protocolo MCP, 13 tools disponíveis (CRUD, monitoramento, resiliência, consultas), regras de uso pelo agente especialista e fluxo de decisão entre RAG e MCP
categoria: Técnica
tags: [MCP, agente, tools, reports, circuit-breaker, reprocessamento, CRUD, contenção, RAG]
entidades_chave: [MCP Server, create_automation, update_automation, get_automation_by_action, get_automation_rule, get_event, get_automation_report, get_circuit_breaker_monitor, get_containment_notifications_count, get_containment_notifications, get_monitor_report, resume_reprocessing, delete_processor_strategy, reprocess_notification]
produto: Automação
---

## O que é MCP e como o agente opera (Teoria)

> **Summary:** O agente especialista de Automação opera via MCP (Model Context Protocol) com 13 tools para CRUD de automações, monitoramento, consultas e resiliência. Usa a base de conhecimento RAG para perguntas conceituais e MCP tools para dados vivos e ações operacionais. O agente nunca chama APIs diretamente.

### Regra de decisão do agente

| Tipo de pergunta | Fonte | Exemplo |
|---|---|---|
| Conceitual/configuração | **RAG** (base de conhecimento) | "Como configuro uma Automação?" |
| Dados vivos/ações operacionais | **MCP** (tools) | "Cria automação para evento 219" |

O agente **nunca** chama APIs diretamente. Toda interação com os sistemas é feita via **MCP tools** registrados no servidor MCP.

### Servidor MCP da Automação

| Servidor | Endpoint | Propósito |
|---|---|---|
| `reportAutomation` | `/automation/mcp` | CRUD, relatórios, circuit breaker, contenção, reprocessamento |

Autenticação: **JWT Bearer Token** via header `Authorization`.

---

## Tools — CRUD de Automações (Teoria)

> **Summary:** As tools MCP de CRUD permitem criar, atualizar e consultar configurações de automações, buscar regras por contexto e obter detalhes de eventos configurados — toda gestão de configuração de automações é feita via essas tools.

| Tool | Descrição | Parâmetros |
|---|---|---|
| `create_automation` | Cria configuração de automação | `payload` (object: `action`, `automation`, `event`) |
| `update_automation` | Atualiza configuração existente (PATCH) | `id` (string), `payload` (object: `automation` obrigatório, `action` e `event` opcionais) |
| `get_automation_by_action` | Busca configuração detalhada por ID | `action` (string), `clientId` (string) |
| `get_automation_rule` | Busca últimas execuções por contexto | `contextId` (string), `context` (string: HISTORY/TASK/LOCAL/ANY), `clientId` (string) |
| `get_event` | Busca detalhamento de eventos configurados | `id` (string/number, opcional), `eventPlatformId` (string/number, opcional) |

### Payload da `create_automation` e `update_automation`

O payload segue a mesma estrutura documentada no Guia de Configuração (doc 08):

```json
{
  "payload": {
    "action": { "name": "...", "type": "CALLBACK", "active": true },
    "event": { "moment": 219, "name": "..." },
    "automation": { "context": "...", "entityReference": "...", "url": "...", "fieldMappings": [...] }
  }
}
```

---

## Tools — Monitoramento e relatórios (Teoria)

> **Summary:** As tools MCP de monitoramento permitem buscar relatórios de execução de automações, consultar o ciclo de vida completo de uma notificação no monitor e acompanhar status de processamento e reprocessamento.

| Tool | Descrição | Parâmetros |
|---|---|---|
| `get_automation_report` | Busca relatório detalhado de uma automação | `actionId` (string — usar EXATAMENTE como informado) |
| `get_monitor_report` | Busca ciclo de vida da automação no monitor (processamento e reprocessamento) | `actionId` (string, ex: `1320165-ANALYZER_25893`) |

### Regra do actionId

O `actionId` informado pelo usuário **nunca deve ser modificado**: não truncar, não remover sufixos, não converter para número. Usar **exatamente** como o usuário escreveu (ex: `1304049-ANALYZER_8542`).

### Regra especial: relatórios

Sempre que a pergunta contiver "relatório" ou "report", **obrigatoriamente** usar `get_automation_report` com o `actionId` informado.

---

## Tools — Circuit Breaker e contenção (Teoria)

> **Summary:** As tools MCP de circuit breaker permitem consultar o estado do monitor do Quiron, contar e listar notificações na fila de contenção e remover estratégias de processamento indevidas do Gerson.

| Tool | Descrição | Parâmetros |
|---|---|---|
| `get_circuit_breaker_monitor` | Consulta status e métricas do Circuit Breaker | `action` (string). `clientId` é injetado automaticamente |
| `get_containment_notifications_count` | Conta notificações na fila de contenção do CB | `action` (string) |
| `get_containment_notifications` | Lista notificações na fila de contenção do CB | `action` (string), `actionId` (string, opcional — para filtrar) |
| `delete_processor_strategy` | Remove estratégia de processamento (limpa dados indevidos) | `action` (string) |

---

## Tools — Reprocessamento (Teoria)

> **Summary:** As tools MCP de reprocessamento permitem reprocessar notificações com erro em lote e retomar o fluxo normal de processamento de ações que estavam em contenção no Circuit Breaker.

| Tool | Descrição | Parâmetros |
|---|---|---|
| `resume_reprocessing` | Retoma reprocessamento de notificações ao fluxo normal | `action` (string) |
| `reprocess_notification` | Reprocessa notificações em lote | `actionIds` (array de strings), `reprocessFromStart` (boolean, padrão: false) |

---

## Fluxo operacional do agente — Checklist (Prática)

> **Summary:** Checklist operacional do agente especialista em 9 etapas: descoberta, evento + ação, conectores de busca, conector de entrega, funções/modificadores, threads, validação, monitoramento e publicação. Cada etapa pode usar RAG para conhecimento e MCP tools para executar ações.

1. **Descoberta**: mapear objetivo, origem do evento, entidade/contexto e SLAs
2. **Evento + ação**: definir `action.type`, ordem, agendamentos → consultar eventos via `get_event`
3. **Conectores de busca**: criar quando faltar dado no contexto
4. **Conector de entrega**: detalhar template (`originStrategy`), metadado, validador
5. **Funções/modificadores**: transformações (listas simples/complexas, merges)
6. **Threads/estratégias**: indicar se segue Jaminho MAIN, SLOW ou filas dedicadas
7. **Validação/testes**: criar automação via `create_automation`, consultar via `get_automation_by_action`
8. **Monitoramento**: consultar relatórios via `get_automation_report`, circuit breaker via `get_circuit_breaker_monitor`
9. **Publicação**: documentar entrega e garantir rollback
