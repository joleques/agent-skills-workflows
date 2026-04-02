---
description: Orquestra os agentes api-documentador e api-documentador-revisor para gerar documentação de APIs em camadas com ciclo de revisão automática (máx 5x)
---

# Workflow: Doc API

Este workflow orquestra dois agentes especializados para produzir documentação de APIs em camadas, atendendo múltiplos públicos-alvo (devs, analistas, suporte). Inclui ciclo automático de geração e revisão.

## Pré-requisitos

- Skills disponíveis em:
  - `.agent/skills/api-documentador/SKILL.md`
  - `.agent/skills/api-documentador-revisor/SKILL.md`

---

## Passos do Workflow

### 1. Coletar parâmetros do usuário

Pergunte ao usuário:

1. **Título**: Qual o título/nome da documentação? (obrigatório)
   - Define o diretório e prefixo dos arquivos de saída

2. **Tipo de documentação**: Qual o tipo desejado?
   - `tecnica` — Referência Técnica (endpoints, schemas, auth, errors)
   - `nao-tecnica` — Getting Started + Casos de Uso + Suporte
   - `ambas` — Todas as 4 camadas
   - Se não informado, usar **ambas** como padrão

3. **Descrição de negócio** (opcional): O que a API resolve?

4. **Contexto adicional** (opcional): Links, specs OpenAPI, observações que ajudem a entender o projeto.

Aguarde a resposta antes de prosseguir.

---

### 2. Executar Agente Documentador (Iteração 1)

Leia a skill do Documentador:

```
.agent/skills/api-documentador/SKILL.md
```

Aplique todas as regras da skill para gerar a documentação, passando:

- **Título** informado pelo usuário
- **Tipo** de documentação escolhido (ou `ambas` por padrão)
- **Descrição de negócio** (se fornecida)
- **Contexto adicional** (se fornecido)

O agente deve:

1. Analisar o projeto (rotas, specs, models, auth, errors)
2. Decidir o particionamento (documento único ou por contexto/domínio)
3. Gerar os `.md` com as camadas correspondentes ao tipo
4. Salvar em `./doc-apis/{titulo}/`

Guarde os documentos gerados para o próximo passo.

---

### 3. Executar Agente Revisor

Leia a skill do Revisor:

```
.agent/skills/api-documentador-revisor/SKILL.md
```

Aplique os critérios de validação aos documentos gerados. O resultado deve ser:

- **✅ APROVADO**: Prossiga para o passo 5
- **⚠️ AJUSTAR** ou **❌ REESCREVER**: Prossiga para o passo 4

O relatório de revisão deve ser salvo em:

```
./doc-apis/{titulo}/{titulo}-revision-v{N}.md
```

---

### 4. Loop de Correção (se não aprovado)

Se o Revisor não aprovou a documentação:

1. Extraia a lista de problemas encontrados do relatório do Revisor
2. Volte ao passo 2, mas agora passe ao Documentador:
   - Os documentos atuais
   - A lista de problemas para correção
   - As sugestões do Revisor
3. O Documentador deve ajustar APENAS os pontos indicados, preservando o que já estava bom
4. Repita o passo 3 (revisão)

**Regra do loop:**

```
┌──────────────────────────────────────────────────────┐
│  Iteração 1–4: Revisor reprova → Documentador ajusta │
│  Iteração 5:   Se ainda reprovado → PARA             │
│                Entrega com ressalvas ao usuário       │
└──────────────────────────────────────────────────────┘
```

- **Máximo de 5 iterações** (geração + revisão) para evitar loops infinitos
- A cada iteração, registre mentalmente o número da iteração atual
- Se após 5 iterações ainda houver problemas, prossiga para o passo 5 com ressalvas

---

### 5. Gerar Índice (`index.md`)

Após o ciclo de revisão (aprovado ou entregue com ressalvas), gere o arquivo `index.md` seguindo as instruções da skill `api-documentador` (passo 6).

O `index.md` deve:

1. Listar **todos** os documentos de conteúdo gerados (excluir relatórios de revisão `*-revision-*.md`)
2. Organizar por camada (Getting Started, Casos de Uso, Referência Técnica, Suporte)
3. Incluir links relativos para cada documento
4. Incluir mapa de navegação por persona
5. Omitir seções de camadas não geradas (respeitar o tipo escolhido)

Salvar em:

```
./doc-apis/{titulo}/index.md
```

---

### 6. Notificar Usuário

Use a tool `notify_user` para informar ao usuário:

**Se APROVADO pelo Revisor:**

```
✅ Documentação APROVADA pelo Revisor

📄 Diretório: ./doc-apis/{titulo}/
📑 Documentos gerados: [lista de arquivos]
📇 Índice: ./doc-apis/{titulo}/index.md
🔄 Iterações: [número de iterações até aprovação]
📂 Tipo: [tecnica / nao-tecnica / ambas]
📝 Título: [titulo]
```

**Se entregue com RESSALVAS (5 iterações sem aprovação):**

```
⚠️ Documentação entregue com RESSALVAS

📄 Diretório: ./doc-apis/{titulo}/
📑 Documentos gerados: [lista de arquivos]
📇 Índice: ./doc-apis/{titulo}/index.md
🔄 Iterações: 5 (limite atingido)
📂 Tipo: [tecnica / nao-tecnica / ambas]
📝 Título: [titulo]

Problemas pendentes:
- [lista dos problemas que o Revisor ainda apontou na última revisão]

Recomendação: revise manualmente os pontos acima antes de publicar.
```

Inclua o diretório `./doc-apis/{titulo}/` em `PathsToReview` para o usuário revisar o conteúdo.

---

## Exemplo de Uso

```
/doc-api

> Qual o título da documentação?
API de Pedidos

> Qual o tipo? (tecnica / nao-tecnica / ambas)
ambas

> Descrição de negócio? (opcional)
API para gerenciamento de pedidos do e-commerce

> Algum contexto adicional? (opcional)
Temos uma spec OpenAPI em ./docs/openapi.yaml

> Analisando o projeto...
> Gerando documentação... (iteração 1/5)
> Documentos gerados:
>   - api-de-pedidos.md
>   - api-de-pedidos-checkout-tecnica.md
>   - api-de-pedidos-catalogo-tecnica.md
>   - api-de-pedidos-suporte.md
>
> Revisando...
> ⚠️ Ajustes necessários: glossário incompleto, exemplos genéricos
> Ajustando... (iteração 2/5)
> Revisando...
> ✅ APROVADO
>
> Gerando índice...
> ✅ index.md gerado
>
> 📄 Diretório: ./doc-apis/api-de-pedidos/
> 📑 4 documentos gerados
> 📇 Índice: ./doc-apis/api-de-pedidos/index.md
> 🔄 Iterações: 2
> 📂 Tipo: ambas
```
