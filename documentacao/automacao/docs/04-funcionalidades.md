---
Título: Automação — Funcionalidades e Comportamento
resumo: Funcionalidades principais, APIs disponíveis, processamento em lote e cenários de uso do produto Automação
categoria: Técnica
tags: [funcionalidades, APIs, webhook, relatórios, batch, processamento-lote, Custom-API]
entidades_chave: [Alfred, Automation-Management, Connector-API, Sentinel, Chapa, BatchService, Custom-API]
produto: Automação
---

## Funcionalidades Principais (Teoria)

> **Summary:** As funcionalidades da Automação incluem pipeline de integração em 5 etapas, encadeamento de automações por sucesso/erro, reprocessamento automático com retentativas, classificação inteligente de APIs, circuit breaker, processamento em lote e API REST direta.

### 1. Pipeline de Integração (Core)
Fluxo principal de processamento: captura de evento → descoberta de dados → transformação → distribuição → entrega.

### 2. Encadeamento de Automações
Configuração de ações de sucesso/erro nas configurações avançadas, permitindo fluxos de negócio encadeados.

### 3. Reprocessamento Automático
- 3 tentativas imediatas (1min, 5min, 15min)
- DLQ para reprocessamento manual
- Retry automático a cada 30min por até 4 dias

### 4. Classificação Inteligente (Lenta/Rápida)
Sentinel analisa tempo de resposta das APIs e classifica automaticamente para segregação de filas.

### 5. Circuit Breaker
Quiron controla circuit breaker quando APIs de clientes estão com problemas. Contenção + recuperação gradual em lotes.

### 6. Processamento em Lote
Serviços Chapa (descarrega carga) e BatchService (envia operações) permitem automações em lote.

### 7. Agendamento
Serviço Pepper permite execução de Automações em momento futuro via agendamento.

### 8. API REST Direta (Custom-API)
API REST disponibilizada aos clientes para usar Automações sem precisar de eventos.

### 9. Validação de Dados
Serviço Severino valida se o dado ("DE") tem todas as informações necessárias antes de seguir no pipeline.

---

## APIs Disponíveis (Teoria)

> **Summary:** As APIs da Automação incluem webhook do Alfred para disparo, Automation Management V2 para CRUD de configurações via MCP tools, Connector API para gestão de conectores de saída, APIs de reprocessamento e relatórios, e Custom-API para acesso REST externo.

| API | Serviço | Descrição |
|---|---|---|
| **Webhook** | Alfred | Endpoint para disparo externo de Automações |
| **Automation Management V2** | Automation Management | CRUD de configurações via MCP tools (`create_automation`, `update_automation`, `get_automation_by_action`) |
| **Connector API** | Connector API | Gestão dos conectores de saída e templates |
| **API de Reprocessamento Manual** | — | Permite reprocessar Automações com erro |
| **API de Relatórios/Reports** | — | Consulta de relatórios de execução |
| **Custom-API** | Custom-API | API REST para clientes usarem Automações sem eventos |
| **Sentinel API** | Sentinel | Monitoramento e métricas |

---

## Monitoramento (Teoria)

> **Summary:** O monitoramento da Automação é feito com Kibana para dashboards operacionais do Time de Soluções e Grafana para métricas técnicas do time de engenharia.

- **Kibana:** Dashboard de monitoramento operacional (acessível ao Time de Soluções)
- **Grafana:** Métricas técnicas para o time de engenharia

---

## API Automation Management V2 — Contratos (Prática)

> **Summary:** A API V2 do Automation Management oferece CRUD completo de automações com separação entre action, event e automation. O agente acessa todas essas operações via MCP tools (`create_automation`, `update_automation`, `get_automation_by_action`).

### Criar Automação → MCP tool: `create_automation`

Payload: objeto com `action`, `event` e `automation`.

```json
{
  "action": {
    "name": "Criar tarefa ao executar atividade",
    "type": "CALLBACK",
    "active": true,
    "order": 1
  },
  "event": {
    "moment": 213,
    "name": "Ao executar uma atividade",
    "activityIds": [1103379]
  },
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

Resposta de sucesso: `201` com `actionId` retornado.

### Buscar Automação → MCP tool: `get_automation_by_action`

Parâmetros: `action` (ID da automação), `clientId`.

### Atualizar Automação → MCP tool: `update_automation`

Parâmetros: `id` (ID da automação), `payload` (objeto com `automation` obrigatório, `action` e `event` opcionais).

### Vincular/Desvincular Atividade à Ação

Restrição: evento moment deve ser **213 ou 215**.

> Nota: vinculação/desvinculação de atividades é feita via API direta (não há MCP tool dedicada).

---

## Ambientes (Prática)

> **Summary:** Os ambientes da Automação incluem desenvolvimento (dese-) e produção com URLs padronizadas no domínio umov.me.

| Ambiente | Base URL |
|---|---|
| Desenvolvimento | `https://dese-automation-api.umov.me` |
| Produção | `https://automation-api.umov.me` |
