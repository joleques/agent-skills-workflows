---
name: mutation-testing-revisor
description: Define quando mutation testing e obrigatorio, recomendado ou opcional e avalia a qualidade real dos testes em modulos criticos.
---

# Mutation Testing Revisor

Use esta skill para mudancas de dominio com logica relevante.

## Politica

- `obrigatorio`: modulo critico de dominio (regras de negocio, calculo, permissao)
- `recomendado`: dominio com condicionais relevantes e risco medio
- `opcional`: UI simples, CRUD trivial, refactor mecanico, docs

## Objetivo

Validar se os testes detectam quebra de comportamento, nao apenas cobertura cosmetica.

## Fluxo

1. Classificar criticidade do modulo alterado.
2. Decidir gate (`obrigatorio|recomendado|opcional`).
3. Se executado, registrar mutation score e principais mutantes sobreviventes.
4. Propor reforco de testes quando score estiver abaixo do nivel esperado da equipe.

## Saida obrigatoria

- Decisao de gate de mutacao
- Justificativa da decisao
- Resultado (quando executado)
- Acoes recomendadas
