# 🛠️ Agent Skills & Workflows

Repositório de **Skills** e **Workflows** para agentes de IA (como Gemini Code Assist, Antigravity e similares) que auxiliam desenvolvedores no dia a dia.

Aqui você encontra **36 skills** e **6 workflows** prontos para uso que automatizam tarefas repetitivas, padronizam a criação de projetos, garantem qualidade de código, geram documentação RAG-ready, publicam conteúdo em redes sociais e aceleram o ciclo de desenvolvimento — tudo orquestrado por agentes inteligentes diretamente na sua IDE.

---

## 🧩 Nova Squad de Engenharia

Este repositório agora também inclui uma **squad operacional de engenharia de software** pronta para ser aplicada em projetos reais:

- Diretório: [`squad-eng-software/`](squad-eng-software/)
- Objetivo: executar demandas com governança explícita, gates técnicos e evidências de entrega
- Tipos de demanda: `analise`, `bug`, `implementacao`
- Fluxo: triagem → plano → implementação guiada por skills → revisões → auditoria final

Principais diferenciais da squad:

- `documentacao/project-context.md` como memória canônica do **projeto hospedeiro**
- separação entre skills de implementação e skills de revisão
- checklist e template de relatório final para reduzir subjetividade

Se você quer usar o pacote completo de skills/workflows, siga com `.agent/`.
Se você quer uma operação de engenharia mais controlada fim a fim, use `squad-eng-software/`.

---

## 📦 O que são Skills?

Skills são conjuntos de instruções, templates e scripts que estendem as capacidades de um agente de IA. Cada skill transforma o agente em um **especialista** em determinado assunto — seja criar pipelines CI/CD, configurar Kubernetes, revisar arquitetura ou gerar documentação pronta para RAG.

Cada skill possui seu próprio `SKILL.md` (instruções para o agente) e `README.md` (documentação para humanos). Consulte o README de cada skill para detalhes.

> 📖 Para uma visão detalhada de cada agente, seus papéis, comportamentos e como interagem nos workflows, consulte o **[AGENTS.md](AGENTS.md)**.

---

## 🗂️ Estrutura do Repositório

```
.agent/
├── skills/                            # 36 habilidades especializadas do agente
│   ├── answers-questions/              # Responde perguntas com base em documentação
│   ├── answers-questions-revisor/      # Revisão de QA para fine-tuning
│   ├── api-documentador/              # Documentação de APIs em camadas (técnica/não-técnica)
│   ├── api-documentador-revisor/      # Revisão de documentação de APIs
│   ├── architectural-principles/       # Princípios arquiteturais
│   ├── bounded-context-analyzer/      # Análise de domínio e linguagem ubíqua (DDD)
│   ├── arquitetura/                    # Padrão de arquitetura proposta-arq
│   ├── arquitetura-revisor/            # Revisão de conformidade arquitetural
│   ├── dataset-synthesizer/            # Geração de datasets JSONL para fine-tuning
│   ├── dataset-synthesizer-revisor/    # Revisão de datasets JSONL
│   ├── design-patterns/                # Especialista pragmático em GoF
│   ├── designer/                       # Design de conteúdo visual e estrutural
│   ├── devcontainer-merger/            # Unificação de DevContainers de Bounded Context
│   ├── devcontainer/                   # Configuração de Dev Containers
│   ├── documentador/                   # Geração de docs para RAG
│   ├── documentador_revisor/           # Validação de docs RAG
│   ├── engineering-writer/             # Escrita de artigos técnicos
│   ├── engineering-writer-revisor/     # Revisão de artigos técnicos
│   ├── git-ops/                        # Operações Git com atalhos compostos
│   ├── go-initializer/                 # Scaffolding de projetos Go
│   ├── grasp/                          # Padrões GRASP
│   ├── instagram-poster/               # Publicação no Instagram via Graph API
│   ├── jira-workflow/                  # Gestão de tickets Jira
│   ├── kubernetes/                     # Manifests K8s com Kustomize
│   ├── linkedin-poster/                # Publicação no LinkedIn via Posts API
│   ├── mongodb-ops/                    # Conexões e operações seguras (CRUD/Agregações) no MongoDB
│   ├── package-principles/             # Princípios de pacotes de Robert C. Martin
│   ├── product-context-aggregator/     # Agrega artefatos extras de produto via symlinks
│   ├── product-documenter/             # Documentação de produto RAG-ready para Agentes de IA
│   ├── product-interviewer/            # Entrevista estruturada para extração de conhecimento de produto
│   ├── product-interviewer-revisor/    # Revisão do contexto extraído pela entrevista
│   ├── quality/                        # Regras de testes e qualidade
│   ├── researcher/                     # Pesquisador de temas com Google
│   ├── social-media-psychology/        # Psicologia de redes sociais e algoritmos de distribuição
│   ├── software-principles/            # Princípios SOLID, OO, Pragmáticos
│   └── software-principles-revisor/    # Revisão de aderência a princípios
└── workflows/                         # 6 orquestrações multi-skill
    ├── doc-api.md                       # Documentação de APIs em camadas
    ├── doc-produto.md                   # Documentação de produto RAG-ready (absorve /hermes)
    ├── fine-tuning-gemini.md            # Pipeline de fine-tuning de LLMs
    ├── init-bounded-context.md          # Inicialização de Bounded Context com análise DDD
    ├── init-project.md                  # Inicialização completa de projetos
    └── write-tech-article.md            # Produção de artigos técnicos

squad-eng-software/
├── AGENTS.md                            # Contrato operacional da squad
├── README.md                            # Guia da squad
├── .skills/                             # Skills usadas no fluxo da squad
└── documentacao/
    ├── project-context.md               # Contexto canônico do projeto hospedeiro
    ├── matriz-demandas-e-gates.md       # Matriz de gates por tipo de demanda
    └── template-relatorio-entrega.md    # Template de evidências finais
```

---

## 🔄 Workflows Disponíveis

| Comando | Descrição |
|---------|-----------|
| `/doc-api` | Orquestra **api-documentador** e **api-documentador-revisor** para gerar documentação de APIs em camadas com ciclo de revisão automática (máx. 5x) |
| `/doc-produto` | Orquestra **product-interviewer**, **product-interviewer-revisor**, **product-context-aggregator** e **product-documenter** para gerar documentação de produto RAG-ready. Suporta Modo Completo (entrevista + pipeline) e Modo Rápido (transformação de `.md` existentes). Absorve a funcionalidade do antigo `/hermes` |
| `/fine-tuning-gemini` | Orquestra geração e revisão de datasets para **Fine-Tuning de LLMs**, em ciclo iterativo de curadoria (máx. 5x) |
| `/init-bounded-context` | Mapeia serviços via symlinks, executa **bounded-context-analyzer** para extrair Linguagem Ubíqua e gerar `context.md`, e opcionalmente aciona **devcontainer-merger** para unificar ambientes de desenvolvimento |
| `/init-project` | Inicializa um novo projeto executando skills de **Dev Container**, **Kubernetes** e opcionalmente **Go Initializer** |
| `/write-tech-article` | Orquestra **Pesquisador**, **Escritor**, **Revisor** e **Designer** para pesquisar referências, produzir artigos técnicos com revisão automática (máx. 5 iterações) e gerar materiais visuais — tudo organizado em `artigos/{titulo}/` |

---

## 📥 Como Instalar no Seu Projeto

### Opção 1 — Copiar a pasta `.agent/`

Copie a pasta `.agent/` inteira para a raiz do seu projeto:

```bash
cp -r .agent/ /caminho/do/seu/projeto/
```

### Opção 2 — Copiar apenas as skills desejadas

Se preferir instalar apenas skills específicas:

```bash
# Criar a estrutura no projeto de destino
mkdir -p /caminho/do/seu/projeto/.agent/skills/

# Copiar skills individuais
cp -r .agent/skills/kubernetes/ /caminho/do/seu/projeto/.agent/skills/
cp -r .agent/skills/devcontainer/ /caminho/do/seu/projeto/.agent/skills/
```

### Opção 3 — Copiar skills + workflows

Para utilizar os workflows (`/doc-produto`, `/init-project`, `/doc-api`, etc.), copie também a pasta de workflows:

```bash
cp -r .agent/ /caminho/do/seu/projeto/
```

### Após a instalação

1. Abra o projeto em uma IDE compatível (VS Code com Gemini Code Assist, Antigravity, etc.)
2. O agente detectará automaticamente as skills disponíveis em `.agent/skills/`
3. Use os comandos de slash (`/init-project`, `/init-bounded-context`, `/doc-produto`, `/doc-api`) para acionar os workflows

---

## 🤝 Contribuindo

Cada skill deve seguir a estrutura:

```
.agent/skills/nome-da-skill/
├── SKILL.md    # Instruções para o agente (YAML frontmatter + Markdown)
└── README.md   # Documentação para humanos
```

O `SKILL.md` deve conter:
- **Frontmatter YAML** com `name` e `description`
- **ROLE** — papel do agente ao usar a skill
- **OBJETIVO** — o que a skill faz
- **FLUXO** — passos de execução
- **TEMPLATES** — arquivos/código gerados (quando aplicável)
- **REGRAS** — restrições e boas práticas

---

## 📄 Licença

Este projeto é disponibilizado como código aberto para a comunidade de desenvolvedores.
