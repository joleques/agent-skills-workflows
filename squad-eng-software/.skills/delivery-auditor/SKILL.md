---
name: delivery-auditor
description: Audita o relatorio final da entrega e valida se as evidencias sustentam as afirmacoes tecnicas e os gates obrigatorios.
---

# Delivery Auditor

Use esta skill antes da resposta final ao usuario em demandas com implementacao.

## Objetivo

Impedir relatorio bonito com evidencia fraca.

## Verificacoes obrigatorias

- Tipo da demanda e escopo aprovado estao explicitos
- Arquivos alterados estao listados
- Teste pre-mudanca reportado
- Evidencia de `tdd-cycle` quando o gate estiver aplicavel
- Evidencia de `arquitetura-proposta` durante implementacao
- Evidencia de `software-principles` durante implementacao
- Evidencia de `grasp-patterns`/`design-patterns-specialist` quando acionadas por complexidade
- Testes pos-mudanca reportados
- Resultado de `arquitetura-revisor` e `software-principles-revisor`
- Resultado de revisores condicionais por risco (se aplicavel)
- Riscos residuais e desvios aceitos estao documentados
- Nao houve remocao oportunista de testes

## Decisao

- `aprovado`: evidencias completas e coerentes
- `ajustes`: faltam evidencias ou ha inconsistencia leve
- `bloqueado`: faltam evidencias criticas

## Saida obrigatoria

- Checklist com `ok|pendente|n.a.` por item
- Pendencias objetivas
- Decisao final (`aprovado|ajustes|bloqueado`)
