# Contexto Consolidado — Automação

**Data:** 2026-03-26
**Fontes:** Entrevista (Fase 1) + Artefatos Extras

---

## Fontes Extras Analisadas

| Fonte | Tipo | Arquivos Relevantes | Eixos Complementados |
|-------|------|---------------------|----------------------|
| wiki-docs | Documentação interna (65 arquivos) | services.md, arquitetura.md, eventos.md, resiliencia.md, auth.md, funcoes.md | Domínio, Arquitetura, Funcionalidades, Operação |
| automation-management-api | Código-fonte + README (API V1/V2) | README.md (contratos API) | Dados/Modelos, Funcionalidades |
| umovme-analyzer | Código-fonte + README | README.md (env vars, diagrama) | Arquitetura |
| templates-bumblebee | Templates Handlebars | CallbackTemplate.ts, EmailOrSMSTemplate.ts, entity/ | Domínio, Dados/Modelos |

---

## Complementos Identificados

### Eixo 2 (Domínio) — Serviços NÃO mencionados na entrevista

**Informação nova:** A wiki-docs revela **5 serviços adicionais** não mencionados na entrevista:

| Serviço | Linguagem | Responsabilidade | Contexto |
|---------|-----------|------------------|----------|
| **Pepper** | TypeScript | Agendamento de Automações — executa automações em momento futuro | Engine |
| **Severino** | TypeScript | Valida se o dado ('DE') tem todas as informações necessárias | Engine |
| **Custom-API** | TypeScript | API REST para clientes usarem Automações sem precisar de eventos | Management |
| **Chapa** | Golang | Engine de processamento em lote — descarrega carga do cliente em tópico | Engine |
| **BatchService** | Java | Processamento em lote — envia cada operação do lote à API destino | Engine |

> **Total de serviços identificados:** 16 (11 da entrevista + 5 novos)

### Eixo 2 (Domínio) — Eventos Disponíveis

**Informação nova:** A wiki-docs cataloga **32 eventos** (IDs 213-244) suportados pela plataforma:

Exemplos: Ao executar Atividade (213), Ao Aprovar Histórico (215), Ao criar Local (218), Ao criar Tarefa (221), Eventos Agendados (222), Ao executar Automação com sucesso (234), Ao executar Automação com erro (235), Execução direta de automações (238), processamento em lote (239-242).

### Eixo 2 (Domínio) — Condições (detalhamento)

**Informação nova:** O README do automation-management-api mostra a estrutura real de conditions:

```json
"conditions": [
  {
    "operandLeft": { "type": "CONTEXT_FIELD", "name": "operandLeft", "value": "history.approvalStatus" },
    "operator": "EQUALS",
    "operandRight": { "type": "CONSTANT", "name": "operandRight", "value": "4" }
  }
]
```

Resolve o ponto em aberto sobre como condições são avaliadas: operandLeft + operator + operandRight.

### Eixo 2 (Domínio) — Origin Strategy adicional: SYSTEM_SETUP

**Informação nova:** O README mostra uma origin strategy não mencionada na entrevista: `SYSTEM_SETUP` (busca valores de configuração do sistema, ex: `contextId`).

### Eixo 2 (Domínio) — Action Types

**Informação nova:** Além de INSERT/UPDATE/PARTIAL_UPDATE, a Automação suporta tipos de ação como `CALLBACK` e `SMS` (action.type no V2).

### Eixo 2 (Domínio) — Arquitetura detalhada (wiki-docs)

**Confirmação:** A wiki confirma 3 macro-contextos com nomes ligeiramente diferentes:
- **Management** (Settings + Monitoring) = Configuração + Monitoramento da entrevista
- **Engine** (Discovery + Transformer + Delivery) = Core da entrevista
- **Adapters** = Contexto NOVO — exceções ao processo, tratamento específico por cliente

### Eixo 2 (Domínio) — Autenticação detalhada (wiki-docs)

**Complemento:** A wiki detalha 3 tipos de auth com exemplos JSON completos:
- **Basic:** user/pass ou hash direto
- **JWT (Bearer):** token direto
- **OAuth:** URL de autorização → token → cache configurável (timeUnit, expiryStatusCode, pathTimeExpiration, patternTimeExpiration)
- **Cache de token OAuth:** Configurável com expiração por segundos ou data

### Eixo 6 (Operação) — Resiliência detalhada (wiki-docs)

**Complemento:** A wiki detalha políticas com mais precisão:
- **Retentativas:** 1min → 5min → 15min (confirmado)
- **Novo:** HTTP 500 tem regra separada: 1 retentativa após 15min
- **Circuit breaker abertura:** ≥10 erros consecutivos em 15 minutos
- **Circuit breaker verificação:** 3min para 429, 7min para demais
- **Circuit breaker reprocessamento:** Lotes de 30, com 1s delay entre lotes
- **Reprocessamento automático:** A cada 30min, reprocessa automações não executadas em até 2 horas antes

### Eixo 3 (Arquitetura) — Variáveis de Ambiente do Analyzer

**Informação nova (umovme-analyzer):** Revela dependências e endpoints:
- MongoDB own database (`analyzer`)
- Redis (cache) e Redis Stream (separados por host/porta)
- Connector API, Sentinel API, Severino API como dependências HTTP

### Eixo 5 (Dados) — API V2 com contratos completos

**Informação nova (automation-management-api):** API V2 documentada com:
- CRUD completo: POST, GET (por actionId e por cliente), PATCH (JSON, Ação, Evento), DELETE
- Vinculação/desvinculação de atividades à ação
- URLs de dev e produção documentadas
- Respostas tipadas com statusCode + messages

---

## Inconsistências Detectadas

### Zico — Linguagem diferenciada
- **Contexto (Fase 1):** Usuário informou Zico como NodeJS
- **Artefato (wiki-docs):** services.md diz Zico como Java
- **Ação necessária:** Baixo impacto, pode ter havido mudança recente. Considerar Java conforme wiki.

### Osiris — Linguagem diferenciada
- **Contexto (Fase 1):** Usuário informou Osiris como Golang
- **Artefato (wiki-docs):** services.md diz Osiris como TypeScript
- **Ação necessária:** Verificar com usuário qual é a informação atualizada.

### Bumblebee — Linguagem
- **Contexto (Fase 1):** Usuário informou Bumblebee como NodeJS
- **Artefato (wiki-docs):** services.md diz Bumblebee como TypeScript
- **Nota:** TypeScript roda em NodeJS, são compatíveis. Considerar TypeScript como mais preciso.

---

## Resumo de Cobertura

| Eixo | Fase 1 | Extras | Status |
|------|--------|--------|--------|
| Visão Geral | ✅ | — | ✅ Completo |
| Domínio de Negócio | ✅ | ➕ 5 serviços, 32 eventos, conditions detalhadas, SYSTEM_SETUP, action types | ✅ Enriquecido |
| Arquitetura | ✅ | ➕ Adapters como 4º contexto, env vars Analyzer | ✅ Enriquecido |
| Funcionalidades | ✅ | ➕ API V2 completa, batch processing, Custom-API | ✅ Enriquecido |
| Dados e Modelos | ⚠️ | ➕ Contratos API V1/V2 completos, auth JSON schemas | ✅ Completo |
| Operação | ✅ | ➕ Circuit breaker detalhado (10 erros, lotes 30, delays) | ✅ Enriquecido |
| Histórico | ✅ | — | ✅ Completo |
