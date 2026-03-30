# 06 — Operação e Observabilidade

## Deploy

- **Cloud:** AWS
- **Orquestração:** Kubernetes
- **CI/CD:** Jenkins (automatizado)

## Observabilidade

| Ferramenta | Público | Uso |
|---|---|---|
| **Kibana** | Operações / Time de Soluções | Dashboard de monitoramento operacional |
| **Grafana** | Time técnico / Engenharia | Métricas técnicas e performance |

## Monitoramento Interno

O serviço **Sentinel** é responsável pelo monitoramento interno das Automações:
- Controle do ciclo de vida (START → PROCESSING → REPROCESSING → FINISH)
- Classificação de APIs destino como lenta/rápida
- Métricas de tempo de resposta

## SLAs / SLOs

- **SLAs formais:** Não existem
- **SLO informal:** Tempo de entrega de ~**32 segundos** (referência interna)

## Tratamento de Incidentes

- **Circuit Breaker:** Serviço Quiron monitora saúde das APIs dos clientes
- **Reprocessamento:** Serviço Osiris gerencia políticas de retry
- **DLQ:** Gerada quando todas as tentativas falham, permite reprocessamento manual
- **API de reprocessamento manual:** Disponível para intervenção operacional

## Pontos em Aberto

- Runbooks ou playbooks de operação — N/I
- Detalhes sobre alertas e notificações de incidentes — N/I
