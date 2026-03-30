# 05 — Dados e Modelos

## Banco de Dados

- **Tecnologia:** MongoDB
- **Estratégia:** Cada serviço possui seu próprio banco (database per service)

## Documentação de APIs

> ⚠️ **N/I** — Não existe schema/modelo de dados documentado formalmente (Swagger/OpenAPI). Usuário indicou possibilidade de análise direta dos serviços.

## Estrutura de Configuração (Exemplo)

Arquivo de referência: `exemplo-resumido.json`

```json
{
    "context": "HISTORY",
    "entityReference": "task",
    "entityReferenceId": "taskAltId",
    "url": "https://dese-api.umov.me/v2/task/alt-id/{{{format (referenceId content)}}}",
    "action": "PARTIAL_UPDATE",
    "fieldMappings": [
        {
            "originStrategy": "FIELD",
            "name": "taskAltId",
            "value": "6339308"
        }
    ]
}
```

### Campos Principais

| Campo | Descrição | Valores |
|---|---|---|
| `context` | Contexto da Automação | HISTORY, TASK, LOCAL, ANY |
| `entityReference` | Referência ao conector de saída (template) | Nome da entidade |
| `entityReferenceId` | ID de referência da entidade | — |
| `url` | URL destino da API do cliente | Suporta templates Handlebars |
| `action` | Tipo de operação | INSERT (padrão), UPDATE, PARTIAL_UPDATE |
| `fieldMappings` | Mapa de campos (o "de") | Array de mapeamentos |

### Origin Strategies nos fieldMappings

| Strategy | Descrição | Status |
|---|---|---|
| `CONTEXT_FIELD` | Busca no contexto da Automação | ✅ Ativo |
| `SEARCH_CONNECTOR` | Busca via conector externo | ✅ Ativo |
| `CONSTANT` | Valor fixo | ✅ Ativo |
| `OBJECT_LIST_FROM_FIELDS` | Montagem de listas | ✅ Ativo |
| `FIELD` | Valor direto | ⚠️ Depreciado |

## Cache

- **Redis** utilizado como cache e distributed locks

## Contratos de API

> ⚠️ **N/I** — Swagger/contratos formais não disponíveis. Análise direta dos serviços seria necessária.

## Pontos em Aberto

- Schema/modelo de dados formal — não documentado
- Contratos de API (Swagger/OpenAPI) — não documentados
- Estratégia de migrations no MongoDB — N/I
