---
name: plano-implementacao
description: Gera o plano obrigatorio antes de implementar, detalhando o que vai mudar e onde vai mudar para bug e implementacao, e bloqueia a execucao ate aprovacao explicita do usuario.
---

# Plano de Implementacao

Use esta skill em toda demanda classificada como `bug` ou `implementacao`.
Nao use esta skill para `analise`.

## Objetivo

Criar um plano claro, verificavel e aprovavel pelo usuario antes de qualquer implementacao.

## Regras obrigatorias

- Nenhuma implementacao comeca sem plano.
- Nenhuma implementacao comeca sem aprovacao explicita do usuario.
- O plano deve ser detalhado o suficiente para que o usuario consiga revisar a abordagem proposta.
- O plano deve explicitar quando `GRASP` e/ou `GoF` sao necessarios e por que melhoram a solucao.
- O plano deve explicitar como a proposta preserva legibilidade e evita complexidade desnecessaria.

## Estrutura do plano

### Para `bug`

- Descrever o problema a ser corrigido.
- Informar o que vai mudar e onde vai mudar.
- Informar quais testes unitarios vao reproduzir o problema e impedir recorrencia.
- Informar como o `tdd-cycle` sera aplicado para proteger a correcao.
- Informar riscos de regressao ou pontos de impacto.

### Para `implementacao`

- Descrever o comportamento atual e o comportamento esperado apos a mudanca.
- Informar o que vai mudar e onde vai mudar.
- Informar impactos esperados em codigo, contratos ou fluxos.
- Informar testes unitarios que vao proteger o comportamento entregue.

## Gate de aprovacao

- O agente deve apresentar o plano e aguardar o usuario informar explicitamente que ele esta aprovado.
- Se o usuario pedir ajuste, o agente deve revisar o plano e reapresenta-lo.
- Enquanto nao houver aprovacao explicita, a execucao deve permanecer bloqueada.

## Gate de testes antes de implementar

Depois da aprovacao do plano e antes de editar arquivos:

1. rodar a suite de testes relevante;
2. se houver falha pre-existente, interromper a implementacao;
3. analisar a falha;
4. discutir com o usuario antes de seguir.

Regra adicional para `bug`:

5. quando o gate de `tdd-cycle` estiver aplicavel, executar o ciclo antes da implementacao;
6. registrar evidencia antes e depois da mudanca;
7. somente depois concluir a implementacao.

## Resultado esperado

Ao final desta skill, o chat deve ter:

- plano aprovado explicitamente pelo usuario;
- escopo de mudanca delimitado;
- testes previstos para a entrega;
- autorizacao para iniciar a implementacao.
