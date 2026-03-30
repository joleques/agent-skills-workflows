---
Título: Automação — Visão Geral e Propósito
resumo: O produto Automação é um módulo da plataforma umov.me responsável pela integração entre APIs usando triggers, conectores de busca e conectores de saída
categoria: Negócio
tags: [automação, integração, APIs, umov.me, triggers, conectores]
entidades_chave: [Automação, umov.me, Time de Soluções, Zapier]
produto: Automação
---

## Visão Geral (Teoria)

> **Summary:** A Automação é um módulo da plataforma umov.me para integração entre APIs, usando triggers (eventos) para inicialização e conectores de busca e saída para transformação de dados entre sistemas, semelhante ao Zapier.

A **Automação** é um módulo da plataforma **umov.me** responsável pela integração entre APIs. Utiliza **triggers** (chamados de **eventos**) para inicialização e **conectores** tanto de busca (para enriquecer o de-para com dados externos) quanto de saída (para transformar o dado conforme a API do cliente usando templates Handlebars).

O produto opera como uma engine de integração orientada a microsserviços (~16 serviços), processando eventos da plataforma e transformando dados em chamadas para APIs externas de forma configurável e resiliente.

---

## Público-alvo e Modelo de Uso (Teoria)

> **Summary:** O público-alvo da Automação são equipes internas de operações (Time de Soluções) que configuram integrações via API/JSON para clientes finais da plataforma umov.me.

- **Usuários diretos:** **Time de Soluções** — departamento interno responsável por configurar as Automações para os clientes finais da plataforma.
- **Modelo de configuração:** Feita exclusivamente via **API/JSON** direto (sem UI/painel web).
- **Clientes finais:** Empresas externas que contratam a plataforma umov.me.
- **Contexto:** A Automação é um módulo dentro de uma plataforma maior — a plataforma **umov.me**.

---

## Problemas que Resolve (Teoria)

> **Summary:** A Automação resolve problemas de automatização de processos complexos, integração bidirecional entre campo e sistemas do cliente, e encadeamento de fluxos de negócio baseados em sucesso ou erro.

A Automação resolve múltiplos problemas:

1. **Automatização de processos complexos** dentro da plataforma, transparentes ao cliente.
   - Exemplo (logística): quando o cliente cria um local de atendimento via API na plataforma, automaticamente é criada uma tarefa de entrega para aquele local.

2. **Integração bidirecional:** quando uma tarefa é realizada em campo (ex: produto entregue), os dados são integrados de volta às APIs do cliente.

3. **Fluxos de negócio encadeados:** de acordo com o retorno da API do cliente (sucesso ou erro), a Automação consegue disparar outra Automação, permitindo fluxos de negócio complexos.

---

## Referência de Mercado e Histórico (Teoria)

> **Summary:** A Automação é comparável ao Zapier como produto de referência de mercado, teve seu MVP lançado em 2019 e encontra-se em produção estável.

- **Produto mais similar:** **Zapier**
- **MVP lançado em:** 2019
- **Fase atual:** Produção estável
