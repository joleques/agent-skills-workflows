# 04 — Funcionalidades e Comportamento

## Funcionalidades Principais

### 1. Pipeline de Integração (Core)
Fluxo principal de processamento: captura de evento → descoberta de dados → transformação → distribuição → entrega.

### 2. Encadeamento de Automações
Configuração de ações de sucesso/erro nas configurações avançadas, permitindo fluxos de negócio encadeados.

### 3. Reprocessamento Automático
- 3 tentativas imediatas (1min, 5min, 15min)
- DLQ para reprocessamento manual
- Retry automático a cada 30min por 4 dias

### 4. Classificação Inteligente (Lenta/Rápida)
Sentinel analisa tempo de resposta das APIs e classifica automaticamente para segregação de filas.

### 5. Circuit Breaker
Quiron controla circuit breaker quando APIs de clientes estão com problemas.

## APIs Disponíveis

| API | Descrição |
|---|---|
| **Webhook (Alfred)** | Endpoint para disparo externo de Automações |
| **Automation Management** | CRUD de configurações de Automações |
| **Connector API** | Gestão de conectores de saída |
| **API de Reprocessamento Manual** | Permite reprocessar Automações com erro |
| **API de Relatórios/Reports** | Consulta de relatórios de execução |

## Monitoramento

- **Kibana:** Dashboard de monitoramento operacional
- **Grafana:** Métricas técnicas para o time de engenharia

## Processos Batch/Agendados

Não existem processos batch dentro da Automação em si. O reprocessamento do Osiris é event-driven (ciclo de vida aberto).

## Pontos em Aberto

- Nenhum ponto pendente neste eixo.
