---
name: context-consistency-checker
description: Verifica consistencia entre documentacao e implementacao, identifica divergencias materiais e define bloqueio ou continuidade.
---

# Context Consistency Checker

Use esta skill quando houver mudanca de comportamento, duvida de contrato, ou risco de conflito entre documentacao e codigo.

## Objetivo

Evitar implementacao baseada em suposicao quando documentacao e codigo contam historias diferentes.

## Entradas minimas

- Arquivos de documentacao relevantes (`README`, `documentacao/`, RFCs, contratos)
- Arquivos de codigo impactados
- Escopo aprovado da demanda

## Fluxo

1. Identificar contratos esperados na documentacao (entradas, saidas, regras, erros, side effects).
2. Comparar com comportamento atual do codigo.
3. Classificar divergencias:
- `editorial`: texto desatualizado sem impacto funcional
- `moderada`: naming/fluxo diferente com baixo impacto
- `material`: comportamento, contrato ou regra de negocio diferente
4. Para divergencia `material`, bloquear continuidade e escalar ao usuario.
5. Para divergencia `editorial` e `moderada`, seguir com alerta e plano de atualizacao documental.

## Saida obrigatoria

- Lista de divergencias por severidade
- Decisao de gate: `seguir` ou `bloquear`
- Recomendacao objetiva de correcao
