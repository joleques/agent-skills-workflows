---
name: risk-classifier
description: Classifica a mudanca em baixo, medio ou alto risco e define revisores obrigatorios adicionais por criticidade.
---

# Risk Classifier

Use esta skill antes da implementacao e atualize a classificacao se o escopo mudar.

## Objetivo

Evitar aplicar o mesmo nivel de rigor para mudancas triviais e mudancas criticas.

## Criterios de classificacao

### Baixo risco

- Ajuste textual, refatoracao mecanica, mudanca local sem impacto de contrato.

### Medio risco

- Mudanca de fluxo de aplicacao, validacoes relevantes, comportamento de API interna.

### Alto risco

- Autenticacao/autorizacao
- Dados sensiveis
- Regras de dominio criticas (financeiro, calculo, consistencia)
- Contrato publico externo
- Migracao de dados/configuracao operacional

## Acionamento de gates por risco

- `baixo`: fluxo base
- `medio`: fluxo base + revisar riscos e regressao
- `alto`: fluxo base + `security-revisor` + `governance-revisor` + avaliacao de `mutation-testing-revisor`

## Saida obrigatoria

- Nivel de risco (`baixo|medio|alto`)
- Justificativa objetiva
- Lista de revisores obrigatorios acionados
