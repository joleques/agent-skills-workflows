---
name: governance-revisor
description: Revisa impacto operacional e de governanca da mudanca: deploy, rollback, migracao, compatibilidade e dependencia externa.
---

# Governance Revisor

Use esta skill quando a entrega tiver impacto de operacao, release ou compliance tecnico.

## Checklist de revisao

- Compatibilidade retroativa de contrato
- Plano de deploy e rollback viavel
- Mudancas de schema/migracao com estrategia segura
- Dependencias novas com risco/licenca avaliados
- Configuracao por ambiente documentada
- Impacto em observabilidade (logs, metricas, alertas)
- Impacto em SLO/SLA e custo operacional

## Classificacao

- `aprovado`: sem bloqueio operacional
- `ajustes`: pendencias trataveis antes de release
- `bloqueado`: risco operacional alto sem plano seguro

## Saida obrigatoria

- Achados por severidade
- Itens obrigatorios para go-live
- Decisao final (`aprovado|ajustes|bloqueado`)
