# 03 — Arquitetura e Tecnologia

## Stack Tecnológica

| Componente | Tecnologia |
|---|---|
| **Linguagens** | Golang, Java, NodeJS |
| **Banco de Dados** | MongoDB (cada serviço com seu banco próprio) |
| **Mensageria / Streaming** | Redis Stream (pipeline principal), SQS (fluxos específicos) |
| **Cache / Locks** | Redis |
| **Comunicação** | Redis Stream, SQS, HTTP, gRPC |
| **Cloud** | AWS |
| **Orquestração** | Kubernetes |
| **CI/CD** | Jenkins |
| **Observabilidade** | Kibana (operações), Grafana (time técnico) |

## Arquitetura de Microsserviços (~16 serviços)

A Automação está dividida em **contextos delimitados de negócio** (Bounded Contexts), e dentro de cada contexto por **responsabilidade única** (SRP):

### Contexto: Core (Pipeline Principal)

| Serviço | Linguagem | Responsabilidade |
|---|---|---|
| **Alfred** | Java | Porta de entrada — captura eventos (via fila ou webhook), valida ações, inicia monitor de ciclo de vida |
| **Analyzer** | Java | Descobre os dados — analisa configurações e monta o "de" |
| **Bumblebee** | TypeScript | Transforma o dado — aplica template Handlebars (conector de saída) ao "de" |
| **Gerson** | Golang | Distribui o dado — classifica como lenta, rápida ou circuit breaker e encaminha à fila destino |
| **Jaminho** | Java | Entrega o dado — executa a chamada à API do cliente |

### Contexto: Monitoramento e Resiliência

| Serviço | Linguagem | Responsabilidade |
|---|---|---|
| **Sentinel** | Java | Monitora tudo que passa pela Automação (ciclo de vida, tempo de resposta). Classifica APIs como lenta/rápida (média das últimas ~20 entregas, threshold ~10s) |
| **Quiron** | Golang | Controla o circuit breaker quando APIs dos clientes estão com problemas |
| **Osiris** | Golang | Reprocessa dados de acordo com as políticas de reprocessamento |

### Contexto: Configuração / Gestão

| Serviço | Linguagem | Responsabilidade |
|---|---|---|
| **Automation Management** | Java | Gestão das automações (CRUD de configurações) |
| **Connector API** | NodeJS | Gestão dos conectores de saída |
| **Zico** | Java | Distribui informações dos conectores de saída entre serviços que precisam (Management e Bumblebee) |

## Decisões Arquiteturais

- **Redis Stream vs Kafka:** Escolha pelo Redis Stream por **custo**. O Redis entregou exatamente o que era necessário.
- **Microsserviços:** Organização por Bounded Contexts (core, monitoramento, configuração) + SRP dentro de cada contexto.
- **Banco por serviço:** Cada serviço possui seu próprio MongoDB, garantindo independência.

## Pontos em Aberto

- Detalhes dos ~5 serviços restantes (dos ~16 mencionados) — N/I
