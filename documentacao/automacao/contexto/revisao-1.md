# Relatório de Revisão de Contexto — Automação

**Diretório:** /documentacao/automacao/contexto/
**Arquivos analisados:** 01-visao-geral.md, 02-dominio-negocio.md, 03-arquitetura.md, 04-funcionalidades.md, 05-dados-e-modelos.md, 06-operacao.md, 07-historico.md, entrevista-log.md (38 perguntas), exemplo-resumido.json

## Resumo

| Categoria | Status | Problemas |
|-----------|--------|-----------|
| Completude | ⚠️ | 3 |
| Fidelidade (log vs temáticos) | ✅ | 0 |
| Profundidade (suficiente para IA) | ⚠️ | 4 |
| Coerência (entre arquivos) | ✅ | 0 |

## Veredicto: ⚠️ APROFUNDAR

---

## Problemas Encontrados

### Completude

#### Problema 1 — Falta clareza sobre o que é "Ação" vs "Evento"
- **Arquivo:** 02-dominio-negocio.md
- **Trecho:** "Ação — Entidade de agregação de contexto — define o contexto em que a Automação foi disparada."
- **Problema:** A relação entre Evento e Ação não está clara. No log (P9), o usuário diz que Evento contém "informações da trigger" e Ação é "agregação de contexto". Mas no pipeline (P13), Alfred "valida se para esse evento existe uma ação a ser disparada" — isso sugere uma relação 1:N entre Evento e Ação, mas não está documentado.
- **Pergunta de Detalhamento:** Qual a relação entre Evento e Ação? Um Evento pode ter múltiplas Ações? A Ação pertence a qual entidade mãe?

#### Problema 2 — Autorização pouco detalhada
- **Arquivo:** 02-dominio-negocio.md
- **Trecho:** "Autorização — Regras de autenticação nas APIs do cliente."
- **Problema:** Mencionada no log (P9) como entidade, mas sem detalhes. Um agente de IA não saberia quais tipos de autenticação são suportados (Basic, OAuth, API Key, Bearer?).
- **Pergunta de Detalhamento:** Quais tipos de autenticação a Automação suporta para APIs de clientes? (Basic Auth, OAuth2, API Key, Bearer Token?)

#### Problema 3 — Conector de busca: configuração e protocolos
- **Arquivo:** 02-dominio-negocio.md
- **Trecho:** "busca dados em APIs JSON, XML, GraphQL mas para a Automação o dado sempre chega de forma padronizada"
- **Problema:** Sabe-se que suporta JSON/XML/GraphQL, mas falta detalhe de como é configurado. Existe um CRUD de conectores de busca? É no mesmo Automation Management?
- **Pergunta de Detalhamento:** Como o conector de busca é configurado? Existe uma API para CRUD de conectores de busca? É gerida pelo mesmo Automation Management ou por outro serviço?

### Profundidade

#### Problema 4 — Distribuição de linguagens por serviço
- **Arquivo:** 03-arquitetura.md
- **Trecho:** "Distribuição de linguagens por serviço (quais são Go, Java, NodeJS) — N/I"
- **Problema:** Para um agente de IA operar com confiança em tasks de código, saber qual serviço usa qual linguagem é essencial. O N/I é legítimo (usuário não respondeu), mas impacta a utilidade para RAG.
- **Pergunta de Detalhamento:** Dos serviços listados (Alfred, Analyzer, Bumblebee, Gerson, Jaminho, Sentinel, Quiron, Osiris, Automation Management, Connector API, Zico), qual linguagem cada um usa?

#### Problema 5 — Circuit Breaker: critérios e comportamento
- **Arquivo:** 02-dominio-negocio.md / 04-funcionalidades.md
- **Trecho:** "Quiron o que controla o circuit breaker"
- **Problema:** Quiron é mencionado mas sem critérios: quando o circuit breaker abre? Fecha automaticamente? Quais métricas usa?
- **Pergunta de Detalhamento:** Quais critérios o Quiron usa para abrir o circuit breaker? Como/quando ele fecha? O que acontece com as Automações enquanto o circuit breaker está aberto?

#### Problema 6 — Template do conector de saída: estrutura
- **Arquivo:** 05-dados-e-modelos.md
- **Trecho:** "entityReference" como referência ao template
- **Problema:** O exemplo JSON mostra a estrutura de configuração de uma Automação, mas o template em si (conector de saída) não é mostrado. Como é a estrutura do template? É um JSON com placeholders tipo Handlebars?
- **Pergunta de Detalhamento:** Poderia mostrar um exemplo de template/conector de saída? É um JSON com placeholders Handlebars? Qual a estrutura?

#### Problema 7 — URL com template Handlebars
- **Arquivo:** 05-dados-e-modelos.md
- **Trecho:** `"url": "https://dese-api.umov.me/v2/task/alt-id/{{{format (referenceId content)}}}"`
- **Problema:** A URL usa sintaxe Handlebars (`{{{...}}}`). É Handlebars mesmo? O Bumblebee usa Handlebars para templating? Isso é relevante para entender como funciona a transformação.
- **Pergunta de Detalhamento:** A URL e os templates usam Handlebars? O Bumblebee usa algum motor de templates específico?

---

## Perguntas Pendentes para o Usuário

1. Qual a relação entre **Evento e Ação**? Um Evento pode ter múltiplas Ações? A Ação pertence a qual entidade mãe?
2. Quais **tipos de autenticação** a Automação suporta para APIs de clientes? (Basic Auth, OAuth2, API Key, Bearer Token?)
3. Como o **conector de busca é configurado**? Existe uma API para CRUD de conectores de busca? É gerida por qual serviço?
4. Dos serviços listados, qual **linguagem cada um usa**?
5. Quais critérios o **Quiron** usa para abrir o circuit breaker? O que acontece com Automações durante circuit breaker aberto?
6. Poderia mostrar um **exemplo de template/conector de saída**?
7. O motor de templates é **Handlebars**?

---

## Pontos Fortes

- Excelente cobertura do pipeline de execução (5 etapas bem detalhadas)
- Mapeamento claro dos serviços em 3 bounded contexts (core, monitoramento, configuração)
- Ciclo de vida e política de reprocessamento detalhados com valores concretos
- Exemplo JSON real fornecido pelo usuário (exemplo-resumido.json)
- Todas as Origin Strategies documentadas com status de uso
- Decisões arquiteturais documentadas com justificativa (Redis vs Kafka)

## Recomendações

1. **Alta prioridade:** Resolver relação Evento ↔ Ação (impacta entendimento do domínio)
2. **Alta prioridade:** Detalhar tipos de autenticação (impacta qualquer task de integração)
3. **Média prioridade:** Documentar conector de busca (CRUD, configuração)
4. **Média prioridade:** Linguagem por serviço (impacta tasks de código)
5. **Baixa prioridade:** Detalhes do circuit breaker e motor de templates
