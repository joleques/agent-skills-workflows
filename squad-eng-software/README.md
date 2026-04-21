# Squad Engenharia de Software

Modelo operacional de squad para execução com agentes de IA, com autonomia alta e controle técnico por gates obrigatórios.

## Objetivo

Permitir execução autônoma sem abrir mão de:

- qualidade de código
- Clean Code
- arquitetura
- princípios de software
- segurança e governança
- evidência objetiva de entrega

## Artefatos principais

- `AGENTS.md`: contrato de operação da squad (classificação, gates, bloqueios e orquestração)
- `documentacao/project-context.md`: contexto canônico do projeto hospedeiro (produto, arquitetura, decisões e estado atual)
- `documentacao/matriz-demandas-e-gates.md`: protocolo por tipo de demanda
- `documentacao/template-relatorio-entrega.md`: padrão de relatório final
- `.skills/`: especialistas operacionais usados no fluxo

## Observação sobre arquitetura

As skills `arquitetura-proposta` e `arquitetura-revisor` estao baseadas na arquitetura de referencia:

- `https://github.com/joleques/proposta-arq`

Se o time utilizar outro padrao arquitetural, essas skills devem ser adaptadas para refletir a arquitetura real do projeto onde a squad sera aplicada.

## Papel do `documentacao/project-context.md`

Este arquivo nao documenta a squad. Ele documenta o projeto em que a squad foi instalada.

Regras operacionais:

- na primeira interacao, a squad deve ler o projeto hospedeiro e preencher/atualizar esse arquivo;
- nas interacoes seguintes, esse arquivo vira a base canonica de contexto;
- sempre que houver mudanca relevante de comportamento, arquitetura ou contrato, o arquivo deve ser atualizado.

## Tipos de demanda

- `analise`
- `bug`
- `implementacao`

## Fluxo padrão da squad

1. `triagem-demanda`
2. `context-consistency-checker`
3. `risk-classifier`
4. `plano-implementacao` (quando houver implementação)
5. `arquitetura-proposta`
6. `quality-assurance`
7. `tdd-cycle` (quando gate aplicável)
8. `clean-code`
9. `software-principles`
10. `arquitetura-revisor`
11. `software-principles-revisor`
12. `clean-code-revisor`
13. `delivery-auditor`

Revisores condicionais por risco:

- `security-revisor`
- `governance-revisor`
- `mutation-testing-revisor`

Especialistas condicionais por complexidade de design:

- `grasp-patterns`
- `design-patterns-specialist`

## Gating obrigatório

### Antes

- classificar demanda
- ler contexto obrigatório
- validar consistência doc x código
- classificar risco
- montar plano e obter aprovação explícita
- validar integridade da base com teste pré-mudança

### Durante

- não inventar comportamento ambíguo
- preservar legibilidade, coesão e baixo acoplamento
- aplicar `arquitetura-proposta` para orientar estrutura e dependências durante implementação
- aplicar `software-principles` e `clean-code` durante implementação
- acionar `grasp-patterns` e `design-patterns-specialist` quando houver complexidade de design

### Depois

- confirmar/ajustar testes
- executar testes relevantes
- rodar revisões técnicas obrigatórias
- auditar evidências com `delivery-auditor`
- emitir relatório final

## Como usar

1. Classifique a demanda.
2. Garanta que `documentacao/project-context.md` reflita o projeto hospedeiro (bootstrap na primeira execucao).
3. Siga o fluxo de skills definido no `AGENTS.md`.
4. Em implementação, só avance após aprovação explícita do plano.
5. Finalize usando o template de relatório em `documentacao/template-relatorio-entrega.md`.

## Estrutura

```text
squad-eng-software/
├── AGENTS.md
├── README.md
├── .skills/
└── documentacao/
    ├── project-context.md
    ├── matriz-demandas-e-gates.md
    └── template-relatorio-entrega.md
```
