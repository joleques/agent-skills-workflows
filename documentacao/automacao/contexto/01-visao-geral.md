# 01 — Visão Geral e Propósito

## O que é a Automação

A **Automação** é um módulo da plataforma **umov.me** responsável pela integração entre APIs. Utiliza **triggers** para inicialização e **conectores** tanto de busca (para enriquecer o de-para) quanto de saída (para transformar o dado conforme a API do cliente).

## Público-alvo

- **Usuários diretos:** Time de Soluções — departamento interno responsável por configurar as Automações para os clientes finais da plataforma.
- **Configuração:** Feita via API/JSON direto (sem UI/painel web).

## Problema que Resolve

A Automação resolve múltiplos problemas:

1. **Automatização de processos complexos** dentro da plataforma, transparentes ao cliente.
   - Exemplo (logística): quando o cliente cria um local de atendimento via API na plataforma, automaticamente é criada uma tarefa de entrega para aquele local.
2. **Integração bidirecional:** quando uma tarefa é realizada em campo (ex: produto entregue), os dados são integrados de volta às APIs do cliente.
3. **Fluxos de negócio encadeados:** de acordo com o retorno da API do cliente (sucesso ou erro), a Automação consegue disparar outra Automação.

## Referência de Mercado

O produto mais similar é o **Zapier**.

## Histórico

- **MVP lançado em:** 2019
- **Fase atual:** Produção estável

## Pontos em Aberto

- Nenhum ponto pendente neste eixo.
