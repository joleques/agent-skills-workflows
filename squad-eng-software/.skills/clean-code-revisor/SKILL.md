---
name: clean-code-revisor
description: Revisa aderencia a Clean Code na entrega implementada e aponta riscos de legibilidade e manutencao antes da auditoria final.
---

# Clean Code Revisor

Use esta skill apos implementacao e antes do `delivery-auditor`.

## Objetivo

Bloquear entrega tecnicamente funcional, mas com baixa legibilidade ou manutencao ruim.

## Criterios de revisao

- Nomes comunicam intencao (sem genericos como `Helper`, `Manager`, `Utils` sem contexto).
- Responsabilidades estao bem separadas (coesao alta).
- Funcoes e metodos nao acumulam tarefas desconexas.
- Fluxo de controle e simples de seguir (sem labirinto de if/else).
- Acoplamento entre modulos esta controlado.
- Comentarios explicam decisoes, nao obviedades.
- Nao houve pattern por vaidade arquitetural.

## Classificacao

- `aprovado`: sem achados relevantes de manutenibilidade.
- `ajustes`: ha pontos que degradam legibilidade/manutencao.
- `bloqueado`: qualidade estrutural compromete evolucao segura.

## Saida obrigatoria

- Achados por severidade (`alto|medio|baixo`).
- Referencia de arquivo e ponto impactado.
- Recomendacao objetiva por achado.
- Decisao final (`aprovado|ajustes|bloqueado`).
