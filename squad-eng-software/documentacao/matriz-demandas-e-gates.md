# Matriz de Demandas e Gates

## Objetivo

Definir protocolo mínimo por tipo de demanda para execução consistente da squad.

## Matriz Operacional

| Tipo | Plano obrigatório | Aprovação explícita | Teste pré-mudança | TDD cycle | Arquitetura proposta (execução) | Software principles (execução) | GRASP/GoF especialistas | Testes pós-mudança | Revisão arq | Revisão princípios | Revisão clean code | Segurança/Governança | Mutation testing |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `analise` | Não | Não | Não | Não | Não | Não | Opcional | Não | Opcional | Opcional | Opcional | Opcional | Não |
| `bug` | Sim | Sim | Sim | Sim | Sim | Sim | Condicional por complexidade | Sim | Sim | Sim | Sim | Condicional por risco | Condicional por criticidade |
| `implementacao` | Sim | Sim | Sim | Condicional por natureza da mudança | Sim | Sim | Condicional por complexidade | Sim | Sim | Sim | Sim | Condicional por risco | Condicional por criticidade |

## Regras de Bloqueio

Bloquear execução e escalar ao usuário quando:

1. Requisito ambíguo alterar comportamento funcional.
2. Teste pré-mudança falhar na área impactada.
3. Houver divergência material entre documentação e código.
4. Mudança de alto risco não tiver política clara de aceitação.
5. Não houver evidência de `tdd-cycle` quando o gate estiver obrigatório para a mudança.
6. Não houver evidência de `arquitetura-proposta` quando a demanda envolver implementação.
7. Não houver evidência de `software-principles` quando a demanda envolver implementação.
8. Não houver evidência de `grasp-patterns`/`design-patterns-specialist` quando acionadas por complexidade de design.

## Critérios para Risco Condicional

Acionar `security-revisor` e `governance-revisor` se houver:

- autenticação/autorização
- exposição de API externa
- dados sensíveis
- mudança de contrato público
- migração de dados
- impacto de deploy/rollback
- alteração de dependência crítica

## Evidências mínimas de saída

1. Escopo implementado versus escopo planejado.
2. Lista objetiva de arquivos alterados.
3. Resultado dos testes relevantes.
4. Evidências de execução de `arquitetura-proposta` e `software-principles`.
5. Evidências de execução de `grasp-patterns`/`design-patterns-specialist` quando acionadas.
6. Resultado da revisão arquitetural, de princípios e de clean code.
7. Justificativa de desvios aceitos conscientemente.
8. Riscos residuais e recomendações.
