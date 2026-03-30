---
Título: Automação — Operação e Observabilidade
resumo: Infraestrutura de deploy, monitoramento, SLOs e tratamento de incidentes do produto Automação
categoria: Técnica
tags: [operação, AWS, Kubernetes, Jenkins, Kibana, Grafana, SLO, circuit-breaker, reprocessamento]
entidades_chave: [AWS, Kubernetes, Jenkins, Kibana, Grafana, Sentinel, Quiron, Osiris]
produto: Automação
---

## Infraestrutura de Deploy (Teoria)

> **Summary:** A Automação roda em infraestrutura AWS com orquestração Kubernetes e pipeline de CI/CD automatizado via Jenkins.

- **Cloud:** AWS
- **Orquestração:** Kubernetes
- **CI/CD:** Jenkins (automatizado)

---

## Observabilidade (Teoria)

> **Summary:** A observabilidade da Automação é dividida entre Kibana para dashboards operacionais acessíveis ao Time de Soluções e Grafana para métricas técnicas do time de engenharia.

| Ferramenta | Público | Uso |
|---|---|---|
| **Kibana** | Operações / Time de Soluções | Dashboard de monitoramento operacional |
| **Grafana** | Time técnico / Engenharia | Métricas técnicas e performance |

---

## Monitoramento Interno — Sentinel (Teoria)

> **Summary:** O Sentinel é o serviço responsável pelo monitoramento interno das Automações, controlando ciclo de vida, classificando performance de APIs e analisando tempo de resposta para segregação de filas.

O serviço **Sentinel** é responsável pelo monitoramento interno das Automações:

- Controle do ciclo de vida (START → PROCESSING → REPROCESSING → FINISH)
- Classificação de APIs destino como lenta/rápida (média das últimas ~20 entregas, threshold ~10s)
- Métricas de tempo de resposta
- Para retornar a ser classificada como rápida, o critério é mais restritivo (tempo consistentemente abaixo do threshold)

---

## SLAs e SLOs (Teoria)

> **Summary:** A Automação não possui SLAs formais documentados, mas trabalha internamente com um SLO informal de 32 segundos como tempo máximo de entrega de uma automação.

- **SLAs formais:** Não existem
- **SLO informal:** Tempo de entrega de ~**32 segundos** (referência interna)

---

## Tratamento de Incidentes (Teoria)

> **Summary:** O tratamento de incidentes na Automação combina retentativas automáticas, circuit breaker com contenção e recuperação gradual, reprocessamento automático periódico, DLQ e API de reprocessamento manual.

### Camadas de resiliência

| Camada | Serviço | Ação |
|---|---|---|
| **1. Retentativas** | Jaminho | 3 tentativas (1min, 5min, 15min) para status codes reprocessáveis |
| **2. Retentativa HTTP 500** | Jaminho | 1 tentativa após 15min |
| **3. Circuit Breaker** | Quiron | Abre após ≥10 erros consecutivos em 15min. Contenção + lotes de 30 |
| **4. Reprocessamento Automático** | Osiris | A cada 30min, reprocessa automações não executadas em até 2h |
| **5. DLQ** | — | Gerada quando todas as tentativas falham |
| **6. Reprocessamento Manual** | API própria | Intervenção operacional via API |

### Duração do ciclo de resiliência

O reprocessamento automático ocorre durante até **4 dias** ou até API do cliente restabelecer.
