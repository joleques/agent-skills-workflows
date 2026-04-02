---
description: Inicializa um ambiente de Bounded Context mapeando múltiplos serviços via links simbólicos e gerando o context.md consolidado (técnico + negócio).
---

# 🏗️ Workflow: Init Bounded Context (`/init-bounded-context`)

Este workflow orquestra a inicialização de um ambiente de Bounded Context, mapeando múltiplos serviços via links simbólicos e acionando análises especializadas para gerar documentação completa de domínio (técnica e de negócio) e, opcionalmente, um DevContainer unificado.

## Pré-requisitos

- Skills disponíveis em:
  - `.agent/skills/bounded-context-analyzer/SKILL.md`
  - `.agent/skills/devcontainer-merger/SKILL.md`

---

## Passos do Workflow

### 1. Coletar Caminhos dos Serviços

Pergunte ao usuário:

1. **Caminhos dos serviços**: Lista (separada por vírgula ou por linhas) contendo os **caminhos absolutos ou relativos** dos diretórios que representam os microsserviços (ou aplicações) pertencentes a este Bounded Context.

Aguarde a resposta antes de prosseguir.

---

### 2. Entrevista de Negócio (Opcional)

Apresente as seguintes perguntas **em bloco** ao usuário para extrair o contexto de negócio que o código sozinho não revela:

```
Para gerar um context.md completo, preciso entender a camada de negócio.
Responda o que puder — quanto mais contexto, mais rico o documento.
Se preferir gerar apenas a parte técnica, responda "pular".

1. **Propósito de negócio:** Qual o propósito de negócio dessa plataforma/domínio?
   (ex: permitir que clientes tenham agentes de IA rodando nos ambientes deles)

2. **Personas:** Quem são os usuários/personas que interagem com esses serviços?
   (ex: desenvolvedor configurando agentes, operador de campo interagindo com chat)

3. **Fluxos de negócio:** Quais são os fluxos de negócio principais de ponta a ponta?
   (ex: configurar agente → associar knowledge base → publicar → usuário conversa)

4. **Regras de negócio:** Existe alguma regra de negócio crítica?
   (ex: isolamento por ambiente/cliente, limites de token, controle de custo)

5. **Contexto adicional:** Algo mais que dê significado ao que esses serviços fazem juntos?
```

Aguarde a resposta. Salve o conteúdo como **contexto de negócio** para uso no passo 5.

- Se o usuário responder **"pular"**: prossiga sem contexto de negócio. As seções de negócio ficarão com `[A ser documentado]`.
- Se o usuário responder **parcialmente**: documente apenas o que foi dito, sem inventar.

---

// turbo-all
### 3. Criar Estrutura Base

Crie o diretório `services/` na raiz do workspace atual:

```bash
mkdir -p services
```

---

### 4. Validar e Criar Links Simbólicos

Itere sobre os caminhos fornecidos pelo usuário. Para **cada** caminho:

1. **Valide** que o diretório existe (`test -d <caminho>`)
2. Se **não existir**, notifique o usuário indicando o caminho inválido e pergunte se deseja corrigir ou pular
3. Se **existir**, crie o link simbólico:

```bash
ln -s -f <caminho_fornecido> services/<nome_do_servico>
```

Repita para todos os caminhos fornecidos. Ao final, confirme no terminal que todos os links foram criados com `ls -la services/`.

---

### 5. Executar Análise de Bounded Context (Skill bounded-context-analyzer)

Leia a skill do Analisador:

```
.agent/skills/bounded-context-analyzer/SKILL.md
```

Execute a skill passando:
- O diretório `services/` como alvo
- O **contexto de negócio** coletado no Passo 2 (se disponível)

A skill irá:

- **Pular** a fase de entrevista interna (já foi feita no Passo 2)
- Varrer controladores, routers, entidades, modelos e adaptadores
- Extrair a Linguagem Ubíqua do domínio
- Identificar Agregados Raiz e fronteiras de integração
- Incorporar o contexto de negócio nas seções correspondentes
- Gerar/atualizar o artefato `context.md` na raiz do workspace

> **Nota:** Se o contexto de negócio não foi coletado (Passo 2 pulado), a skill deve preencher as seções de negócio com `[A ser documentado]`.

---

### 6. Executar Unificação de DevContainer (Skill devcontainer-merger) — Opcional

Leia a skill do Merger:

```
.agent/skills/devcontainer-merger/SKILL.md
```

Execute a skill passando o diretório `services/` como alvo. A skill irá:

- Buscar configurações de DevContainer nos serviços
- Se **nenhuma** for encontrada: abortar com mensagem informativa (comportamento esperado)
- Se **encontradas**: mesclar e criar `.devcontainer/` unificado na raiz do workspace

---

### 7. Notificar Usuário

Use a tool `notify_user` para informar ao usuário:

**Se tudo foi gerado com sucesso:**

```
✅ Bounded Context inicializado com sucesso

📁 Diretório: services/
🧩 Serviços mapeados: [lista dos serviços com symlinks]
📄 context.md: Gerado na raiz do workspace
🏢 Camada de negócio: [Incluída / Pendente — entrevista pulada]
🐳 DevContainer: [Gerado na raiz / Não aplicável — nenhum devcontainer encontrado nos serviços]

Resumo do domínio:
[Breve parágrafo sintetizando a descoberta — Propósito, Personas, Linguagem Ubíqua, agregados principais e fronteiras de integração identificadas]
```

**Se houve caminhos inválidos:**

```
⚠️ Bounded Context inicializado com RESSALVAS

📁 Diretório: services/
🧩 Serviços mapeados: [lista dos que funcionaram]
❌ Caminhos inválidos: [lista dos que falharam]
📄 context.md: Gerado (baseado nos serviços válidos)
🏢 Camada de negócio: [status]
🐳 DevContainer: [status]
```

Inclua o caminho do `context.md` em `PathsToReview`.

---

## Exemplo de Uso

```
/init-bounded-context

> Informe os caminhos dos serviços deste Bounded Context:
/home/jorge/workspace/genai,
/home/jorge/workspace/umovme-mcp-server,
/home/jorge/workspace/umovme-hermes

> 🏢 Entrevista de Negócio:
> Para gerar um context.md completo, preciso entender a camada de negócio...

> Propósito: Permitir que clientes da uMov tenham agentes de IA conversacionais
> rodando nos ambientes deles, capazes de operar sobre dados e componentes uMov.
> Personas: Desenvolvedor/Arquiteto de Soluções, Time de Produto, Time de Tecnologia,
> Cliente Final.
> Fluxos: Gestão de Knowledge Base, Configuração de Agentes, Gestão de Ferramentas MCP,
> Conversação com usuário final.
> Regras: Isolamento por ambiente/client_id, controle de tokens, autenticação via API key.

> 📁 Criando services/...
> 🔗 Link: services/genai → OK
> 🔗 Link: services/umovme-mcp-server → OK
> 🔗 Link: services/umovme-hermes → OK

> 🧠 Analisando Bounded Context...
> (varredura de código, endpoints, modelos, integrações + contexto de negócio)

> 📄 context.md gerado na raiz

> 🐳 Verificando DevContainers nos serviços...
> Encontrados 2 devcontainers (Python + Node)
> DevContainer unificado gerado em .devcontainer/

✅ Bounded Context inicializado com sucesso

📁 Diretório: services/
🧩 Serviços: genai, umovme-mcp-server, umovme-hermes
📄 context.md: Gerado
🏢 Camada de negócio: Incluída (propósito, personas, 4 fluxos, 5 regras)
🐳 DevContainer: Gerado (Python 3.x + Node 20 | Postgres, MongoDB, Redis)

Domínio identificado: Contexto da Fábrica de Agentes Inteligentes — governa a
criação, configuração, treinamento e execução de agentes de IA conversacionais.
Agregados raiz: Agent, Chat, Cluster, Knowledge Base, MCP Session.
Comunicação interna via MCP Protocol. Fronteiras externas: OpenAI, Google AI,
PostgreSQL, MongoDB, Qdrant, ChromaDB, AWS S3/SQS, Redis, Langfuse.
```
