---
Título: Automação — Domínio de Negócio
resumo: Entidades, regras de negócio, fluxos de execução, ciclo de vida, reprocessamento e circuit breaker do produto Automação
categoria: Negócio
tags: [entidades, eventos, ações, fieldMappings, originStrategy, pipeline, resiliência, circuit-breaker]
entidades_chave: [Evento, Ação, Condição, Autorização, fieldMappings, originStrategy, Alfred, Analyzer, Bumblebee, Gerson, Jaminho, Sentinel, Quiron, Osiris]
produto: Automação
---

## Entidades do Domínio (Teoria)

> **Summary:** As entidades centrais da Automação incluem Evento (trigger), Ação (contexto de execução), Condição (regras de prosseguimento), Autorização (auth nas APIs), fieldMappings (mapa de campos com estratégias dinâmicas) e Configurações Avançadas (encadeamento sucesso/erro).

| Entidade | Descrição |
|---|---|
| **Evento** | Informações da trigger e o momento em que executou. Porta de entrada da Automação. Um Evento pode ter **múltiplas Ações** (relação 1:N). |

### Tabela de Eventos Disponíveis (32 moments)

| Moment | Nome | Restrição |
|---|---|---|
| 213 | Ao executar uma Atividade | **Obrigatório `activityIds`** |
| 215 | Ao Aprovar Histórico | **Obrigatório `activityIds`** |
| 218 | Ao criar Local | — |
| 219 | Ao editar Local | — |
| 220 | Ao editar Tarefa | — |
| 221 | Ao criar Tarefa | — |
| 222 | Eventos Agendados | — |
| 223 | Ao criar Dataset | — |
| 224 | Ao editar Dataset | — |
| 225 | Ao deletar Dataset | — |
| 226 | Ao criar Item | — |
| 227 | Ao editar Item | — |
| 228 | Ao criar Agente | — |
| 229 | Ao editar Agente | — |
| 230 | Ao retornar tarefa de campo | — |
| 231 | Ao processar um lote de itens com sucesso | — |
| 232 | Ao enviar para campo a tarefa | — |
| 233 | Ao aplicar Route Machine | — |
| 234 | Ao executar Automação com sucesso | — |
| 235 | Ao executar Automação com erro | — |
| 236 | Ao enviar tarefas em lote (exclusiva Correios) | Uso restrito |
| 237 | Ao executar ação de escrita com gatilho para Automação | — |
| 238 | Execução direta de automações (Automação chama Alfred diretamente) | — |
| 239 | Ao finalizar qualquer processamento em lote | — |
| 240 | Ao finalizar processamento de lote com sucesso | — |
| 241 | Ao finalizar processamento de lote com sucesso parcial | — |
| 242 | Ao finalizar processamento de lote com erro | — |
| 243 | Ao alterar pessoa responsável do local | — |
| 244 | Ao alterar o status do local | — |
| **Ação** | Entidade de agregação de contexto — define o contexto em que a Automação foi disparada. Após criada, não possui entidade mãe. Pode ser do tipo `CALLBACK`, `SMS`, entre outros. |
| **Condição** | Regras que determinam se a Automação deve prosseguir. Estrutura: `operandLeft` + `operator` + `operandRight`. Usa originStrategy para buscar valores (ex: SEARCH_CONNECTOR para validar dados externos). |
| **Autorização** | Regras de autenticação nas APIs do cliente. Suporta: **Basic Auth**, **OAuth2** (com cache de token configurável), **Bearer Token (JWT)**. |
| **Configurações Avançadas** | Configurações fora do escopo padrão, necessárias para alguns processos. Inclui ações de sucesso/erro (encadeamento de Automações). |
| **URL Destino** | Endpoint da API do cliente para integração. Suporta templates Handlebars na URL. |
| **Mapa de Campos (fieldMappings)** | Configuração do "de" — define de onde vem cada dado e a estratégia de montagem via `originStrategy`. |

### Ponto forte da Automação

Praticamente **todos os atributos de todas as entidades** podem ser configurados via estratégias de montagem (`originStrategy`). Isso permite atribuição dinâmica de valores às Automações.

---

## Estrutura de Atributos Dinâmicos (Teoria)

> **Summary:** O sistema de atributos dinâmicos da Automação usa originStrategy para definir de onde vem cada dado — podendo buscar no contexto local, em APIs externas, usar valores constantes ou montar listas de objetos.

### Origin Strategies (de onde vem o dado)

| Strategy | Descrição | Status |
|---|---|---|
| `CONSTANT` | Valor fixo/constante — usa o que for digitado em `value` | ✅ Ativo |
| `CONTEXT_FIELD` | Busca no contexto da Automação (disponível quando context ≠ ANY). Campos customizados acessíveis via prefixo `CF_` | ✅ Ativo |
| `HISTORY_FIELD` | Resgata um dado preenchido no histórico — `value` referencia o ID numérico do campo de atividade | ✅ Ativo |
| `SEARCH_CONNECTOR` | Busca em conector de busca (API externa). Referencia via `<identifier>.<campo>` | ✅ Ativo |
| `OBJECT_LIST_FROM_FIELDS` | Montagem de listas e objetos compostos. Suporta `valueSource` para iterar sobre listas externas | ✅ Ativo |
| `SYSTEM_SETUP` | Busca valores de configuração do sistema. Prefixos: `ENV_` (variável de ambiente), `SP_` (parâmetro de sistema no banco), ou `contextId` | ✅ Ativo |
| `FIELD` | Valor direto | ⚠️ Depreciado |

### Tipos de Contexto (context)

| Valor | Descrição | CONTEXT_FIELD disponível? |
|---|---|---|
| `HISTORY` | Contexto de histórico | ✅ Sim |
| `TASK` | Contexto de tarefas | ✅ Sim |
| `LOCAL` | Contexto de local de atendimento | ✅ Sim |
| `ANY` | Qualquer contexto — requer SEARCH_CONNECTOR | ❌ Necessita busca externa |

### Actions (tipo de operação na API destino)

| Valor | Descrição |
|---|---|
| `INSERT` | Inserção (padrão quando não informado) |
| `UPDATE` | Atualização completa |
| `PARTIAL_UPDATE` | Atualização parcial |

---

## Triggers e Eventos (Teoria)

> **Summary:** Os triggers (chamados de eventos) são a porta de entrada da Automação, podendo ser eventos da plataforma umov.me, webhooks externos, ou eventos agendados, totalizando 32 tipos de eventos catalogados.

### Tipos de trigger

- **Eventos da plataforma:** Eventos disparados pela plataforma umov.me que acionam a Automação.
- **Webhook:** Endpoint disponibilizado pelo Alfred para disparo externo.
- **Eventos Agendados:** Outro produto chama o webhook via cron/agendamento. O serviço Pepper gerencia agendamentos.

### Eventos Disponíveis (IDs 213-244)

| ID | Evento |
|---|---|
| 213 | Ao executar uma Atividade |
| 215 | Ao Aprovar Histórico |
| 218 | Ao criar Local |
| 219 | Ao editar Local |
| 220 | Ao editar Tarefa |
| 221 | Ao criar Tarefa |
| 222 | Eventos Agendados |
| 223 | Ao criar Dataset |
| 224 | Ao editar Dataset |
| 225 | Ao deletar Dataset |
| 226 | Ao criar Item |
| 227 | Ao editar Item |
| 228 | Ao criar Agente |
| 229 | Ao editar Agente |
| 230 | Ao retornar tarefa de campo |
| 231 | Ao processar um lote de itens com sucesso |
| 232 | Ao enviar para campo a tarefa |
| 233 | Ao aplicar Route Machine |
| 234 | Ao executar Automação com sucesso |
| 235 | Ao executar Automação com erro |
| 236 | Ao enviar tarefas em lote (exclusiva Correios) |
| 237 | Ao executar ação de escrita com gatilho p/ Automação |
| 238 | Execução direta de automações (Automação chama Alfred diretamente) |
| 239 | Ao finalizar qualquer processamento em lote |
| 240 | Ao finalizar processamento de lote com sucesso |
| 241 | Ao finalizar processamento de lote com sucesso parcial |
| 242 | Ao finalizar processamento de lote com erro |
| 243 | Ao alterar pessoa responsável do local |
| 244 | Ao alterar o status do local |

---

## Conectores (Teoria)

> **Summary:** Os conectores de busca são um produto paralelo que padronizam dados de APIs externas (JSON, XML, GraphQL) para a Automação, enquanto os conectores de saída (templates Handlebars) transformam dados no formato da API do cliente.

### Conector de Busca

Usado na **Etapa 2 (descoberta de dados)** quando o dado necessário está fora do contexto da Automação. Padroniza o formato de entrada — busca dados em APIs JSON, XML, GraphQL mas para a Automação o dado sempre chega de forma padronizada.

O **CRUD de conectores de busca é um produto paralelo** — não faz parte da Automação. Na configuração da Automação, referencia-se apenas o `identifier` (alias) do conector e seus `filters` (usando originStrategy CONSTANT/CONTEXT_FIELD), `connector_modifier` e `datasourceId`.

### Conector de Saída (Template)

Nome de negócio para os "templates". É o **de-para** — transforma os dados descobertos na Etapa 2 no formato esperado pela API do cliente. Referenciado por `entityReference`. Usa **Handlebars** como motor de templates com helpers customizados (`format`, `formatDate`, `hasAny`, `pipeToArray`, `#each`, `#unless @last`).

---

## Pipeline de Execução — Core (Teoria)

> **Summary:** O pipeline core da Automação é composto por 5 etapas sequenciais executadas por microsserviços especializados: captura de evento (Alfred), descoberta de dados (Analyzer), transformação (Bumblebee), distribuição (Gerson) e entrega (Jaminho).

```
Evento → Etapa 1 (Alfred)     → Captura evento, valida se existe ação, inicia monitor ciclo de vida
       → Etapa 2 (Analyzer)   → Descobre o dado: analisa configurações (CONTEXT_FIELD, SEARCH_CONNECTOR, etc.), monta o "de"
       → Etapa 3 (Bumblebee)  → Transformação: aplica template Handlebars (conector de saída/entityReference) usando o "de"
       → Etapa 4 (Gerson)     → Distribui na fila conforme classificação (rápida, lenta, circuit breaker)
       → Etapa 5 (Jaminho)    → Entrega o dado à API do cliente
```

---

## Ciclo de Vida (Teoria)

> **Summary:** O ciclo de vida de uma Automação possui quatro estados: START (inicializada), PROCESSING (em execução), REPROCESSING (em fluxo de reprocessamento por erro retornável) e FINISH (finalizada).

| Estado | Descrição |
|---|---|
| `START` | Automação inicializada |
| `PROCESSING` | Em execução |
| `REPROCESSING` | Em fluxo de reprocessamento (dado não pronto ou erro reprocessável: 408, 429, 500, 502, 503, 504) |
| `FINISH` | Finalizada |

---

## Resiliência — Retentativas (Teoria)

> **Summary:** A política de retentativas da Automação executa reprocessamento automático em intervalos progressivos quando APIs de clientes retornam erros específicos, com regra especial para erro 500 e fallback para DLQ e reprocessamento automático a cada 30 minutos.

### Política padrão de retentativas

1. **1ª retentativa:** 1 minuto após o erro
2. **2ª retentativa:** 5 minutos após o erro
3. **3ª retentativa:** 15 minutos após o erro

Status codes que acionam retentativas: **408** (Request Timeout), **429** (Too Many Requests), **502** (Bad Gateway), **503** (Service Unavailable), **504** (Gateway Timeout).

### Regra especial para HTTP 500

Quando a API do cliente retorna **500** (Internal Server Error), é realizada **1 retentativa** após **15 minutos**.

### Após falhar todas as tentativas

- Automação é marcada com **erro**
- Gera **DLQ** (Dead Letter Queue) para reprocessamento manual
- Ciclo de vida fica **aberto** (não finalizado)
- **Reprocessamento automático:** a cada 30 minutos, reprocessa automações não executadas em até 2 horas antes
- Duração: até **4 dias** ou até API do cliente restabelecer

---

## Resiliência — Circuit Breaker (Teoria)

> **Summary:** O circuit breaker (proteção contra travamento) é gerenciado pelo serviço Quiron, monitorando erros consecutivos das APIs dos clientes e protegendo o sistema com contenção temporária e recuperação gradual.

### Critério de abertura

O circuito é aberto quando a API do cliente retorna pelo menos **10 erros consecutivos** em um período de **15 minutos**, com status codes: 408, 429, 502, 503 ou 504.

### Comportamento durante abertura

- Tudo que chega é guardado em **contenção**

### Verificação periódica (health check)

- A cada **3 minutos** para status code 429
- A cada **7 minutos** para os demais status codes

### Recuperação

- Quando a API volta, o Quiron entrega tudo da contenção em **lotes de 30**
- Delay de **1 segundo** entre lotes
- Se o circuito reabrir durante o reprocessamento, o processo é interrompido

---

## Encadeamento e Configurações Avançadas (Teoria)

> **Summary:** As configurações avançadas (advancedSettings) controlam encadeamento de automações por sucesso/erro, tradução de status HTTP, encurtamento de URLs, adaptadores customizados e assinatura alternativa.

A gaveta `advancedSettings` controla o comportamento pós-disparo:

| Campo | Tipo | Descrição |
|---|---|---|
| `nextActionWhenSuccess` | Lista de Textos | IDs fixos de ações a executar no sucesso (abordagem legada) |
| `nextActionWhenError` | Lista de Textos | IDs fixos de ações a executar no erro (abordagem legada) |
| `chainedEvent` | Objeto | Encadeamento dinâmico — usa Tipo Padrão para descobrir próxima ação (substitui versão fixa) |
| `translation` | Objeto | Traduz retornos HTTP — mapeia `before` → `after` para status codes ou valores |
| `alternativeIdentifier` | Tipo Padrão | Sobrescreve a assinatura primária da execução com ID externo |
| `shortenUrl` | Booleano | Ativa encurtamento de URLs grandes no payload |
| `shortnerType` | Texto | Serviço encurtador (ex: `NATIVE_SERVICE`) |
| `shortnerEntity` | Texto | Metadado para agrupamento de métricas (ex: campanha de marketing) |
| `adapterType` | Texto | Adaptador nativo — formatador especializado por fornecedor |

Eventos específicos para encadeamento: **234** (sucesso) e **235** (erro).

---

## Regras de Bloqueio (Teoria)

> **Summary:** A Automação não executa quando a Ação ou o Evento associado estão inativos, funcionando como um mecanismo de desativação sem excluir a configuração.

A Automação não executa quando:
- **Ação** está inativa
- **Evento** está inativo

---

## Condições — Detalhamento (Prática)

> **Summary:** As condições (barreiras lógicas) na Automação são avaliadas usando operandLeft, operador de comparação e operandRight, com 6 tipos de operadores e regra AND entre múltiplas condições.

### Estrutura de condições

As conditions formam um grupo de testes **AND** — todas devem ser verdadeiras para a Automação prosseguir. Se o pacote de testes não for satisfeito, a ação não executa.

| Campo | Obrigatório | Descrição |
|---|---|---|
| `operandLeft` | ✅ | Lado esquerdo — usa originStrategy para buscar o valor |
| `operator` | ✅ | Operador de comparação |
| `operandRight` | ❌ | Lado direito — não necessário para `IS_NULL` e `NOT_NULL` |

### Operadores disponíveis

| Operador | Descrição | Requer operandRight? |
|---|---|---|
| `EQUALS` | Verdadeiro se ambos forem idênticos (texto ou número) | ✅ |
| `NOT_EQUALS` | Verdadeiro se forem diferentes | ✅ |
| `CONTAINS` | Verdadeiro se o texto da esquerda contiver o da direita | ✅ |
| `GREATER_THAN` | Verdadeiro se esquerda for numericamente maior | ✅ |
| `IS_NULL` | Verdadeiro se o valor da esquerda não existir | ❌ |
| `NOT_NULL` | Verdadeiro se o valor da esquerda existir e tiver valor | ❌ |

### Exemplo com múltiplas condições (AND)

```json
"conditions": [
  {
    "operator": "EQUALS",
    "operandLeft": { "originStrategy": "HISTORY_FIELD", "name": "operandLeft", "value": "9005" },
    "operandRight": { "originStrategy": "CONSTANT", "name": "operandRight", "value": "CANAL_VIP" }
  },
  {
    "operator": "IS_NULL",
    "operandLeft": { "originStrategy": "HISTORY_FIELD", "name": "operandLeft", "value": "205_suspenso_em" }
  }
]
```

---

## Autenticação — Configuração (Prática)

> **Summary:** A configuração de autenticação nas APIs dos clientes suporta Basic Auth (user/pass ou hash direto), JWT/Bearer Token e OAuth2 com cache de token configurável.

### Basic Auth — com usuário e senha

```json
"authentication": {
    "strategy": {
        "originStrategy": "OBJECT_LIST_FROM_FIELDS",
        "name": "basic",
        "values": [
            { "originStrategy": "CONSTANT", "name": "user", "value": "userTest", "index": 0 },
            { "originStrategy": "CONSTANT", "name": "pass", "value": "123456", "index": 1 }
        ]
    }
}
```

### Basic Auth — com hash direto

```json
"authentication": {
    "strategy": {
        "originStrategy": "OBJECT_LIST_FROM_FIELDS",
        "name": "basic",
        "values": [
            { "originStrategy": "CONSTANT", "name": "hash", "value": "token-aqui", "index": 0 }
        ]
    }
}
```

### JWT (Bearer Token)

```json
"authentication": {
    "strategy": {
        "originStrategy": "OBJECT_LIST_FROM_FIELDS",
        "name": "jwt",
        "values": [
            { "originStrategy": "CONSTANT", "name": "hash", "value": "eyJ0eXAi...", "index": 0 }
        ]
    }
}
```

### OAuth2 — com Basic Auth para obter token

```json
"authentication": {
    "strategy": {
        "originStrategy": "OBJECT_LIST_FROM_FIELDS",
        "name": "OAuth",
        "values": [
            { "originStrategy": "CONSTANT", "name": "url", "value": "https://api-cliente/token", "index": 0 },
            { "originStrategy": "CONSTANT", "name": "tokenPath", "value": "token", "index": 1 },
            { "originStrategy": "CONSTANT", "name": "auth", "value": "basic", "index": 3 },
            {
                "originStrategy": "OBJECT_LIST_FROM_FIELDS",
                "name": "basic",
                "index": 4,
                "values": [
                    { "originStrategy": "CONSTANT", "name": "user", "value": "usuario", "index": 0 },
                    { "originStrategy": "CONSTANT", "name": "pass", "value": "senha", "index": 1 }
                ]
            }
        ]
    }
}
```

### OAuth2 — Cache de Token

| Campo | Descrição |
|---|---|
| `timeUnit` | Unidade de tempo de expiração: `SECOND` ou `DATE` |
| `expiryStatusCode` | Status code que indica token expirado (transformado em 429 internamente) |
| `pathTimeExpiration` | Caminho no response onde está o tempo de expiração |
| `patternTimeExpiration` | Padrão de data se timeUnit for DATE (ex: `yyyy-MM-dd'T'HH:mm:ss`) |

Regra: se `timeUnit` for informado sem `pathTimeExpiration`, o padrão é 900 segundos de cache.

---

## Conector de Busca — Configuração (Prática)

> **Summary:** O searchConnector é o interrogador externo da Automação — pausa a montagem, busca dados em APIs externas e disponibiliza os resultados via originStrategy SEARCH_CONNECTOR para fieldMappings, conditions e headers.

### Estrutura do searchConnector

| Campo | Obrigatório | Descrição |
|---|---|---|
| `identifier` | ✅ | Nome da variável onde os resultados ficam salvos. Referenciado depois via `<identifier>.<campo>` |
| `component` | ✅ | Tipo Padrão — chave de API ou formulário de pesquisa |
| `componentAction` | ❌ | Tipo Padrão — verbo/ação de pesquisa do componente |
| `filters` | ❌ | Lista de Tipos Padrão — parâmetros de filtro da busca |

### Exemplo com component e consumo do resultado

```json
"searchConnector": [
  {
    "identifier": "busca_cli",
    "component": { "originStrategy": "CONSTANT", "name": "componenteBusca", "value": "API_CLIENTES_LEGADO" },
    "filters": [
      { "originStrategy": "HISTORY_FIELD", "name": "id_usuario", "value": "142" }
    ]
  }
],
"fieldMappings": [
  { "originStrategy": "SEARCH_CONNECTOR", "name": "empresa", "value": "busca_cli.detalhes.nome_empresa" }
]
```

### Exemplo com connector_modifier e datasourceId

```json
"searchConnector": [
    {
        "identifier": "historyValues",
        "filters": [
            { "originStrategy": "CONSTANT", "name": "filter[0].name", "value": "HISTORY_ID" },
            { "originStrategy": "CONTEXT_FIELD", "name": "filter[0].values", "value": "history.id" },
            { "originStrategy": "CONSTANT", "name": "connector_modifier", "value": "HistoryItemsByHistoryAndGroupByItem" },
            { "originStrategy": "CONSTANT", "name": "datasourceId", "value": "17" }
        ]
    }
]
```
