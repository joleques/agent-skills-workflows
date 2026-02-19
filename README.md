# 🛠️ Agent Skills & Workflows

Repositório de **Skills** e **Workflows** para agentes de IA (como Gemini Code Assist, Antigravity e similares) que auxiliam desenvolvedores no dia a dia.

Aqui você encontra habilidades prontas para uso que automatizam tarefas repetitivas, padronizam a criação de projetos, garantem qualidade de código e aceleram o ciclo de desenvolvimento — tudo orquestrado por agentes inteligentes diretamente na sua IDE.

---

## 📦 O que são Skills?

Skills são conjuntos de instruções, templates e scripts que estendem as capacidades de um agente de IA. Cada skill transforma o agente em um **especialista** em determinado assunto — seja criar pipelines CI/CD, configurar Kubernetes, ou gerar documentação pronta para RAG.

Basta copiar a pasta `.agent/` para o seu projeto e o agente terá acesso automático a todas as skills.

> 📖 Para uma visão detalhada de cada agente, seus papéis, comportamentos e como interagem nos workflows, consulte o **[AGENTS.md](AGENTS.md)**.

---

## 🗂️ Estrutura do Repositório

```
.agent/
├── skills/                  # Habilidades especializadas do agente
│   ├── arquitetura/         # Padrões de arquitetura limpa
│   ├── arquitetura-revisor/ # Revisão de conformidade arquitetural
│   ├── devcontainer/        # Configuração de Dev Containers
│   ├── design-patterns/     # Especialista pragmático em GoF e GRASP
│   ├── documentador/        # Geração de docs para RAG
│   ├── documentador_kb/     # Publicação em Base de Conhecimento
│   ├── documentador_revisor/# Validação de docs RAG
│   ├── go-initializer/      # Scaffolding de projetos Go
│   ├── jenkins/             # Pipelines CI/CD Jenkins
│   ├── jira-workflow/       # Gestão de tickets Jira
│   ├── kubernetes/          # Manifests K8s com Kustomize
│   └── quality/             # Regras de testes e qualidade
└── workflows/               # Orquestrações multi-skill
    ├── hermes.md            # Pipeline de documentação RAG
    └── init-project.md      # Inicialização completa de projetos
```

---

## 🚀 Skills Disponíveis

### 🏗️ Arquitetura

| | |
|---|---|
| **Skill** | `arquitetura-proposta` |
| **Descrição** | Define regras de estrutura de pastas e fluxo de dependências baseado em Clean Architecture + Hexagonal + DDD |

Estabelece o padrão arquitetural com camadas bem definidas (`/domain`, `/use_case`, `/application`, `/infra`, `/shared`), garantindo que as dependências fluam somente **de fora para dentro**. Baseada no repositório [proposta-arq](https://github.com/joleques/proposta-arq).

---

### 🔍 Arquitetura — Revisor

| | |
|---|---|
| **Skill** | `arquitetura-revisor` |
| **Descrição** | Revisa código e aponta problemas de aderência ao padrão proposta-arq |

Analisa projetos existentes e gera um **relatório de conformidade** detalhado, verificando:
- Estrutura de pastas
- Fluxo de dependências entre camadas
- Violações por camada (Application, Use Case, Domain, Infrastructure, Shared)

O relatório é gerado em Markdown com tabela de resumo e lista acionável de problemas encontrados.

---

### 📦 Dev Container

| | |
|---|---|
| **Skill** | `devcontainer-specialist` |
| **Descrição** | Cria, atualiza e melhora configurações de Dev Container (`.devcontainer`) |

Gera ambientes de desenvolvimento containerizados completos com suporte a múltiplas stacks:
- **Go** — com protobuf, mockgen e Node.js
- **Node.js/TypeScript** — com ESLint, Prettier
- **Python** — com Poetry e ferramentas de linting
- **Multi-stack** — combinações personalizadas

Inclui sistema automático de instalação de extensões VS Code e set padrão de extensões da empresa.

---

### 📝 Documentador RAG

| | |
|---|---|
| **Skill** | `documentador-rag` |
| **Descrição** | Converte dados não estruturados em documentos Markdown canônicos para ingestão em Base Vetorial |

Transforma áudios, notas, JSONs, Swagger e documentos técnicos em **documentação RAG-ready** com:
- Chunking semântico determinístico (separação `teoria` / `prática`)
- Bloco de metadados YAML obrigatório
- Hierarquia rígida para recuperação de alta precisão
- Fidelidade total ao input — **proibido resumir**

---

### ✅ Revisor de Documentação RAG

| | |
|---|---|
| **Skill** | `documentador-revisor` |
| **Descrição** | Valida documentos Markdown produzidos para RAG, garantindo conformidade estrutural e semântica |

Atua como **agente de controle de qualidade** (Critic Agent) no pipeline de documentação, validando:
- Bloco YAML obrigatório
- Estrutura de seções teóricas e práticas
- Hierarquia Markdown
- Autossuficiência de chunks
- Proibição de resumo

Resultado: **APROVADO** ou **REPROVADO** com lista explícita de violações.

---

### 🐹 Go Initializer

| | |
|---|---|
| **Skill** | `go-initializer` |
| **Descrição** | Cria estrutura base Go para inicializar um novo projeto com `go.mod`, `main.go` e `Makefile` |

Gera o scaffolding de um projeto Go funcional com:
- `go.mod` configurado com o nome do módulo
- `src/main.go` com ponto de entrada
- `Makefile` com targets: `run`, `build`, `test`, `clean`, `tidy`

---

### 🎯 Design Patterns

| | |
|---|---|
| **Skill** | `design-patterns-specialist` |
| **Descrição** | Especialista pragmático em GoF e GRASP — sabe quando usar e quando NÃO usar patterns |

Analisa e recomenda Design Patterns com foco em **simplicidade primeiro**:
- Tabelas de decisão para todos os patterns GoF (Creational, Structural, Behavioral)
- Princípios GRASP com aplicação pragmática
- Sinais de alerta contra over-engineering (YAGNI, KISS, Regra dos 3)
- Fluxo de validação: só aplica pattern se houver problema concreto em 3+ locais

---

### 📋 Jira Workflow

| | |
|---|---|
| **Skill** | `jira-workflow` |
| **Descrição** | Gestão de tickets, hierarquia de demandas no Jira e documentação local em Markdown |

Define convenções para:
- Hierarquia de pastas (Épico → Task → Subtask)
- Fluxo de criação de tickets
- Template padronizado com BDD (DADO/QUANDO/ENTÃO)
- Integração com Jira via MCP

---

### ☸️ Kubernetes

| | |
|---|---|
| **Skill** | `kubernetes-specialist` |
| **Descrição** | Cria manifests Kubernetes com Kustomize para development e production |

Gera a estrutura `infra/k8s/` completa com:
- **Base:** Deployment e Service compartilhados
- **Development:** ConfigMap, Ingress, HPA (1 réplica)
- **Production:** ConfigMap, Ingress público + privado, HPA (3–6 réplicas)

Inclui probes de health check, rolling update strategy e resource limits.

---

### 🧪 Quality Assurance

| | |
|---|---|
| **Skill** | `quality-assurance` |
| **Descrição** | Regras para TDD, cobertura de testes e validação de código |

Estabelece padrões de qualidade:
- Todo artefato novo exige teste correspondente
- Foco em testes unitários + integração em pontos críticos
- Mocks obrigatórios para HTTP/DB
- Definition of Done: código limpo, testado, sem nomes genéricos, com logs estruturados

---

## 🔄 Workflows Disponíveis

### `/hermes` — Pipeline de Documentação RAG
Orquestra os agentes **Documentador** e **Revisor** para processar arquivos `.md` e gerar documentação RAG-ready em um fluxo completo de produção → validação → publicação.

### `/init-project` — Inicialização de Projeto
Inicializa um novo projeto executando em sequência as skills de **Dev Container**, **Jenkins**, **Kubernetes** e opcionalmente **Go Initializer**, criando toda a infraestrutura necessária de uma só vez.

---

## 📥 Como Usar

1. **Clone** este repositório ou copie a pasta `.agent/` para a raiz do seu projeto
2. Abra o projeto em uma IDE compatível (VS Code com Gemini Code Assist, Antigravity, etc.)
3. O agente detectará automaticamente as skills disponíveis
4. Use os comandos de slash (`/init-project`, `/hermes`) para acionar os workflows

```bash
# Copiar skills para seu projeto
cp -r .agent/ /caminho/do/seu/projeto/
```

---

## 🤝 Contribuindo

Sinta-se à vontade para contribuir com novas skills! Cada skill deve seguir a estrutura:

```
.agent/skills/nome-da-skill/
└── SKILL.md    # Instruções no formato YAML frontmatter + Markdown
```

O `SKILL.md` deve conter:
- **Frontmatter YAML** com `name` e `description`
- **ROLE** — papel do agente ao usar a skill
- **OBJETIVO** — o que a skill faz
- **FLUXO** — passos de execução
- **TEMPLATES** — arquivos/código gerados
- **REGRAS** — restrições e boas práticas

---

## 📄 Licença

Este projeto é disponibilizado como código aberto para a comunidade de desenvolvedores.
