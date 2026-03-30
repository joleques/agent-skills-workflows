# 02 — Domínio de Negócio

## Entidades Principais

| Entidade | Descrição |
|---|---|
| **Evento** | Informações da trigger e o momento em que executou. Porta de entrada da Automação. Um Evento pode ter **múltiplas Ações** (relação 1:N). |
| **Ação** | Entidade de agregação de contexto — define o contexto em que a Automação foi disparada. Após criada, não possui entidade mãe. |
| **Condição** | Regras que determinam se a Automação deve prosseguir. Usa a estrutura padrão (ex: SEARCH_CONNECTOR para validar dados externos). |
| **Autorização** | Regras de autenticação nas APIs do cliente. Suporta: **Basic Auth**, **OAuth2**, **Bearer Token**. |
| **Configurações Avançadas** | Configurações fora do escopo padrão, necessárias para alguns processos. Inclui ações de sucesso/erro (encadeamento). |
| **URL Destino** | Endpoint da API do cliente para integração. |
| **Mapa de Campos (fieldMappings)** | Configuração do "de" — define de onde vem cada dado e a estratégia de montagem. |

## Estrutura de Atributos Dinâmicos

> **Ponto forte da Automação:** Praticamente todos os atributos de todas as entidades podem ser configurados via estratégias de montagem (originStrategy). Isso permite atribuição dinâmica de valores às Automações.

### Origin Strategies (de onde vem o dado)

| Strategy | Descrição |
|---|---|
| `CONTEXT_FIELD` | Busca no contexto da Automação (disponível quando context ≠ ANY) |
| `SEARCH_CONNECTOR` | Busca em conector de busca (API externa) |
| `CONSTANT` | Valor fixo/constante |
| `OBJECT_LIST_FROM_FIELDS` | Para montagem de listas |
| `FIELD` | ⚠️ Depreciado — não é mais utilizado |

### Tipos de Contexto (context)

| Valor | Descrição |
|---|---|
| `HISTORY` | Contexto de histórico |
| `TASK` | Contexto de tarefas |
| `LOCAL` | Contexto de local de atendimento |
| `ANY` | Qualquer contexto — requer SEARCH_CONNECTOR para buscar dados |

### Actions (tipo de operação na API destino)

| Valor | Descrição |
|---|---|
| `INSERT` | Inserção (padrão quando não informado) |
| `UPDATE` | Atualização completa |
| `PARTIAL_UPDATE` | Atualização parcial |

## Triggers / Eventos

- **Eventos da plataforma:** Eventos disparados pela plataforma umov.me que acionam a Automação.
- **Webhook:** Endpoint disponibilizado pelo Alfred para disparo externo.
- **Eventos Agendados:** Outro produto chama o webhook via cron/agendamento.

## Conectores

### Conector de Busca
Usado na **Etapa 2 (descoberta de dados)** quando o dado necessário está fora do contexto da Automação. Padroniza o formato de entrada — busca dados em APIs JSON, XML, GraphQL mas para a Automação o dado sempre chega de forma padronizada.

> **Nota:** O CRUD de conectores de busca é um **produto paralelo** — não faz parte da Automação. Na configuração da Automação, referencia-se apenas o `identifier` (alias) do conector e seus `filters` (usando originStrategy CONSTANT/CONTEXT_FIELD), `connector_modifier` e `datasourceId`.

### Conector de Saída (Template)
Nome de negócio para os "templates". É o **de-para** — transforma os dados descobertos na Etapa 2 no formato esperado pela API do cliente. Referenciado por `entityReference`. Usa **Handlebars** como motor de templates com helpers customizados (`format`, `formatDate`, `hasAny`, `pipeToArray`, `#each`, `#unless @last`).

## Pipeline de Execução (Core)

```
Evento → Etapa 1 (Alfred)     → Captura evento, valida se existe ação, inicia monitor ciclo de vida
       → Etapa 2 (Analyzer)   → Descobre o dado: analisa configurações (CONTEXT_FIELD, SEARCH_CONNECTOR, etc.), monta o "de"
       → Etapa 3 (Bumblebee)  → Transformação: aplica template (conector de saída/entityReference) usando o "de"
       → Etapa 4 (Gerson)     → Distribui na fila conforme classificação (rápida, lenta, circuit breaker)
       → Etapa 5 (Jaminho)    → Entrega o dado à API do cliente
```

## Ciclo de Vida

| Estado | Descrição |
|---|---|
| `START` | Automação inicializada |
| `PROCESSING` | Em execução |
| `REPROCESSING` | Em fluxo de reprocessamento (dado não pronto ou erro reprocessável: 408, 429, 502, 503, 504) |
| `FINISH` | Finalizada |

## Política de Reprocessamento

1. **3 tentativas imediatas:** 1min → 5min → 15min
2. Se falhar todas: marca como **erro**, gera **DLQ** para reprocessamento manual
3. Ciclo de vida fica **aberto** (não finalizado)
4. **Reprocessamento automático:** a cada 30min durante **4 dias** (ou até API restabelecer)

## Encadeamento

Configurado nas **Configurações Avançadas** da própria Automação:
- Ações a executar em caso de **sucesso**
- Ações a executar em caso de **erro**

## Regras de Bloqueio

A Automação não executa quando:
- **Ação** está inativa
- **Evento** está inativo

## Circuit Breaker (Quiron)

- **Critério de abertura:** Baseado em erros seguidos da API do cliente (HTTP 408, 429, 502, 503, 504)
- **Quando atinge o limite:** Circuit breaker abre por alguns minutos
- **Contenção:** Tudo que chega durante abertura é guardado em contenção
- **Health check:** Após X tempo, Quiron verifica se a API voltou
- **Recuperação:** Quando volta, entrega tudo da contenção de forma gradual para não derrubar o cliente novamente

## Pontos em Aberto

- Detalhes sobre como a Condição é avaliada (expressão, operadores comparativos, etc.)
