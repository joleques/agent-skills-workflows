---
name: clean-code
description: Diretrizes de Clean Code para orientar implementacao com legibilidade, coesao, baixo acoplamento e simplicidade pragmatica.
---

# Clean Code

Use esta skill durante planejamento e implementacao de `bug` e `implementacao`.

## Objetivo

Garantir codigo legivel, sustentavel e com responsabilidade bem distribuida.

## Regras essenciais

- Usar nomes claros e intencionais para classes, funcoes e variaveis.
- Manter funcoes pequenas e com responsabilidade unica.
- Evitar indirecao artificial, abstracao prematura e complexidade acidental.
- Favorecer coesao alta e acoplamento baixo entre modulos.
- Evitar branching excessivo quando uma estrategia mais clara resolver.
- Manter fluxo de leitura simples, sem surpresas de comportamento.

## Checklist de aplicacao

1. O nome comunica a intencao sem comentario auxiliar?
2. A unidade (funcao/classe) possui um motivo principal para mudar?
3. O fluxo pode ser entendido linearmente por quem nao escreveu o codigo?
4. A complexidade introduzida e proporcional ao problema real?
5. O codigo novo reduz ou aumenta debito tecnico da area tocada?

## Saida esperada

- Decisoes de design com justificativa objetiva de simplicidade.
- Registro de trade-offs quando optar por solucao mais complexa.
