---
name: tdd-cycle
description: Executa o ciclo de testes orientado por comportamento (RED, GREEN, REFACTOR quando aplicavel) e registra evidencias objetivas para suportar a implementacao.
---

# TDD Cycle

Use esta skill quando houver mudanca de comportamento observavel e necessidade de proteger implementacao por testes.

## Objetivo

Reduzir regressao e garantir que a implementacao seja guiada por teste e evidencia, nao por tentativa e erro.

## Fluxo

1. Definir o comportamento alvo que sera validado.
2. Criar ou ajustar teste para esse comportamento.
3. Executar teste e registrar estado inicial (RED quando aplicavel).
4. Implementar a mudanca minima necessaria.
5. Executar teste novamente e registrar estado final (GREEN).
6. Refatorar mantendo a suite verde (REFACTOR quando necessario).

## Saida obrigatoria

- Lista de testes criados/ajustados.
- Evidencia de execucao antes da mudanca.
- Evidencia de execucao apos a mudanca.
- Registro de refatoracao (quando houver).
