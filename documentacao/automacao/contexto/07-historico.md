# 07 — Histórico e Evolução

## Decisões Arquiteturais

### Redis Stream vs Kafka
- **Decisão:** Adotar Redis Stream
- **Motivo:** Custo. O Redis entregou exatamente o que era necessário, tornando o Kafka desnecessário para o caso de uso.

### Microsserviços por Bounded Context + SRP
- **Decisão:** Dividir a aplicação em ~16 serviços
- **Motivo:** A aplicação está dividida em contextos delimitados de negócio (core, monitoramento, configuração) e dentro de cada contexto por responsabilidade única, onde cada serviço é responsável por uma necessidade de negócio específica.

## Dívidas Técnicas

> ⚠️ **N/I** — Usuário não identificou dívidas técnicas de imediato.

## Origin Strategy Depreciada

- `FIELD` não é mais utilizado — substituído por `CONTEXT_FIELD`, `CONSTANT`, `SEARCH_CONNECTOR` e `OBJECT_LIST_FROM_FIELDS`.

## Pontos em Aberto

- Dívidas técnicas conhecidas — N/I
- Planos de evolução / Roadmap — N/I
- Histórico de refatorações passadas — N/I
