# 🛠️ Agent Skills & Workflows

Repositório de **Skills** e **Workflows** para agentes de IA (como Gemini Code Assist, Antigravity e similares) que auxiliam desenvolvedores no dia a dia.

Aqui você encontra habilidades prontas para uso que automatizam tarefas repetitivas, padronizam a criação de projetos, garantem qualidade de código e aceleram o ciclo de desenvolvimento — tudo orquestrado por agentes inteligentes diretamente na sua IDE.

---

## 📦 O que são Skills?

Skills são conjuntos de instruções, templates e scripts que estendem as capacidades de um agente de IA. Cada skill transforma o agente em um **especialista** em determinado assunto — seja criar pipelines CI/CD, configurar Kubernetes, revisar arquitetura ou gerar documentação pronta para RAG.

Cada skill possui seu próprio `SKILL.md` (instruções para o agente) e `README.md` (documentação para humanos). Consulte o README de cada skill para detalhes.

> 📖 Para uma visão detalhada de cada agente, seus papéis, comportamentos e como interagem nos workflows, consulte o **[AGENTS.md](AGENTS.md)**.

---

## 🗂️ Estrutura do Repositório

```
.agent/
├── skills/                      # Habilidades especializadas do agente
│   ├── architectural-principles/  # Princípios arquiteturais
│   ├── arquitetura/               # Padrão de arquitetura proposta-arq
│   ├── arquitetura-revisor/       # Revisão de conformidade arquitetural
│   ├── design-patterns/           # Especialista pragmático em GoF
│   ├── designer/                  # Design de conteúdo visual e estrutural (HTML/Imagens)
│   ├── devcontainer/              # Configuração de Dev Containers
│   ├── documentador/              # Geração de docs para RAG
│   ├── documentador_revisor/      # Validação de docs RAG
│   ├── engineering-writer/        # Escrita de artigos técnicos
│   ├── engineering-writer-revisor/ # Revisão de artigos técnicos
│   ├── go-initializer/            # Scaffolding de projetos Go
│   ├── grasp/                     # Padrões GRASP
│   ├── jira-workflow/             # Gestão de tickets Jira
│   ├── kubernetes/                # Manifests K8s com Kustomize
│   ├── package-principles/        # Princípios de pacotes
│   ├── quality/                   # Regras de testes e qualidade
│   ├── software-principles/       # Princípios SOLID, OO, Pragmáticos
│   └── software-principles-revisor/ # Revisão de aderência a princípios de software
└── workflows/                   # Orquestrações multi-skill
    ├── hermes.md                  # Pipeline de documentação RAG
    ├── init-project.md            # Inicialização completa de projetos
    └── write-tech-article.md      # Produção de artigos técnicos
```

---

## 🔄 Workflows Disponíveis

| Comando | Descrição |
|---------|-----------|
| `/hermes` | Orquestra os agentes **Documentador** e **Revisor** para processar arquivos `.md` e gerar documentação RAG-ready |
| `/init-project` | Inicializa um novo projeto executando skills de **Dev Container**, **Kubernetes** e opcionalmente **Go Initializer** |
| `/write-tech-article` | Orquestra **Pesquisador**, **Escritor**, **Revisor** e **Designer** para pesquisar referências, produzir artigos técnicos sobre engenharia de software com revisão automática (máx. 5 iterações) e gerar materiais visuais |

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

Para utilizar os workflows (`/hermes`, `/init-project`), copie também a pasta de workflows:

```bash
cp -r .agent/ /caminho/do/seu/projeto/
```

### Após a instalação

1. Abra o projeto em uma IDE compatível (VS Code com Gemini Code Assist, Antigravity, etc.)
2. O agente detectará automaticamente as skills disponíveis em `.agent/skills/`
3. Use os comandos de slash (`/init-project`, `/hermes`) para acionar os workflows

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
