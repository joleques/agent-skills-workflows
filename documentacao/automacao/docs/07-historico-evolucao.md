---
Título: Automação — Histórico e Evolução
resumo: Decisões arquiteturais, depreciações e evolução técnica do produto Automação
categoria: Técnica
tags: [decisões-arquiteturais, Redis-Stream, Kafka, microsserviços, depreciação]
entidades_chave: [Redis-Stream, Kafka, FIELD, CONTEXT_FIELD]
produto: Automação
---

## Decisões Arquiteturais (Teoria)

> **Summary:** As decisões arquiteturais documentam tradeoffs como Redis Stream por custo em detrimento do Kafka, e microsserviços por bounded contexts com responsabilidade única.

### ADR-001: Redis Stream vs Kafka

- **Decisão:** Adotar Redis Stream
- **Motivo:** Custo. O Redis entregou exatamente o que era necessário.

### ADR-002: Microsserviços por Bounded Context + SRP

- **Decisão:** Dividir em ~16 serviços por contextos delimitados (Engine, Management, Monitoramento, Adapters) + SRP.

### ADR-003: Banco por serviço

- **Decisão:** Cada serviço possui seu próprio MongoDB para independência.

---

## Depreciações (Teoria)

> **Summary:** A origin strategy FIELD foi depreciada e substituída por CONTEXT_FIELD, CONSTANT, SEARCH_CONNECTOR e OBJECT_LIST_FROM_FIELDS.

- `FIELD` — ⚠️ Depreciado. Substituído por `CONTEXT_FIELD`, `CONSTANT`, `SEARCH_CONNECTOR`, `OBJECT_LIST_FROM_FIELDS`.

---

## Pontos em Aberto (Teoria)

> **Summary:** Os pontos em aberto incluem dívidas técnicas não identificadas, ausência de roadmap e falta de runbooks operacionais.

- Dívidas técnicas — N/I
- Roadmap — N/I
- Histórico de refatorações — N/I
- Runbooks/playbooks — N/I
