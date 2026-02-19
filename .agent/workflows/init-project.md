---
description: Inicializa um novo projeto executando skills de devcontainer, jenkins, kubernetes e opcionalmente go-initializer
---

# Workflow: Inicialização de Projeto

Este workflow orquestra a criação da estrutura completa de um novo projeto, executando as skills na ordem correta.

---

## Passo 1: COLETAR INFORMAÇÕES

Antes de executar as skills, pergunte ao usuário todas as informações necessárias de uma vez:

### Informações Básicas
> 1. **Qual é o nome do projeto?** (ex: `umovme-hermes`)
> 2. **Qual o diretório do projeto?** (caminho absoluto, ex: `/home/user/projetos/meu-projeto`)
> 3. **Qual a stack/linguagem principal?** (Go, Node.js, Python, Multi-stack)
> 4. **Usar extensões padrão da empresa?** (sim/não)

### Kubernetes
> 5. **Qual o namespace Kubernetes?** (padrão: `umovme`)
> 6. **Qual a porta da aplicação?** (padrão: `8080`)
> 7. **Qual a porta do health check?** (padrão: `9090`)
> 8. **Qual o path do health check?** (padrão: `/health`)
> 9. **Qual o host do Ingress de DEV?** (ex: `app.dev.umov.me`)
> 10. **Qual o host do Ingress de PROD?** (ex: `app-api.umov.me`)

### Jenkins
> 11. **Qual a URL do repositório Bitbucket?** (ex: `git@bitbucket.org:umovme/projeto.git`)
> 12. **Qual a URL do webhook Discord?** (pode deixar vazio)
> 13. **Quais squads para notificação de prod?** (ex: `["Automação", "GenAI"]`)

### Go Initializer (somente se stack for Go)
> 14. **Qual a versão do Go?** (padrão: `1.24`)

---

## Passo 2: VALIDAR INFORMAÇÕES

Após coletar, mostre um resumo para o usuário confirmar:

```
📋 RESUMO DO PROJETO

Nome do Projeto: {{PROJECT_NAME}}
Diretório: {{PROJECT_DIR}}
Stack: {{STACK}}

📦 Kubernetes:
- Namespace: {{NAMESPACE}}
- Porta App: {{APP_PORT}}
- Porta Health: {{HEALTH_PORT}}
- Path Health: {{HEALTH_PATH}}
- Ingress Dev: {{INGRESS_HOST_DEV}}
- Ingress Prod: {{INGRESS_HOST_PROD}}

🔧 Jenkins:
- Repo Bitbucket: {{BITBUCKET_REPO}}
- Discord Webhook: {{DISCORD_WEBHOOK}}
- Squads: {{SQUADS}}

Confirma? (sim/não)
```

---

## Passo 3: EXECUTAR SKILLS

Execute as skills na seguinte ordem:

### 3.1 - Go Initializer (CONDICIONAL)

**Executar apenas se o projeto for em Go.**

Leia a skill: `.agent/skills/go-initializer/SKILL.md`

Parâmetros:
- `PROJECT_NAME`: Nome do projeto
- `PROJECT_DIR`: Diretório do projeto
- `GO_VERSION`: Versão do Go (padrão: 1.24)

---

### 3.2 - Devcontainer Specialist

Leia a skill: `.agent/skills/devcontainer/SKILL.md`

Parâmetros:
- `PROJECT_NAME`: Nome do projeto
- `STACK`: Stack/linguagem (Go, Node.js, Python, Multi-stack)
- Usar extensões padrão da empresa

**Diretório de destino**: `{{PROJECT_DIR}}/.devcontainer/`

---

### 3.3 - Kubernetes Specialist

Leia a skill: `.agent/skills/kubernetes/SKILL.md`

Parâmetros:
- `PROJECT_NAME`: Nome do projeto
- `NAMESPACE`: Namespace Kubernetes
- `APP_PORT`: Porta da aplicação
- `HEALTH_PORT`: Porta do health check
- `HEALTH_PATH`: Path do health check
- `INGRESS_HOST_DEV`: Host do ingress de development
- `INGRESS_HOST_PROD`: Host do ingress de production
- `INGRESS_HOST_INTERNAL`: `{{PROJECT_NAME}}.umov.internal` (derivado automaticamente)

**Diretório de destino**: `{{PROJECT_DIR}}/infra/k8s/`

---

## Passo 4: AVISOS PÓS-CRIAÇÃO

Após criar todos os arquivos, mostre ao usuário:

> [!IMPORTANT]
> **Arquivos criados com sucesso!**
>
> Estrutura gerada:
> ```
> {{PROJECT_DIR}}/
> ├── .devcontainer/
> │   ├── devcontainer.json
> │   └── Dockerfile.dev
> ├── scripts/
> │   ├── install-extensions.sh
> │   └── install-extensions.js
> ├── infra/
> │   ├── k8s/
> │   │   ├── base/
> │   │   ├── development/
> │   │   └── production/
> │   └── jenkins/
> │       ├── development/
> │       │   └── Jenkinsfile
> │       └── production/
> │           └── Jenkinsfile
> ├── go.mod             (se Go)
> ├── Makefile           (se Go)
> └── src/main.go        (se Go)
> ```

> [!NOTE]
> **Próximos passos:**
> 1. Revise os arquivos gerados e ajuste conforme necessário
> 2. Configure os Secrets no Kubernetes (descomente no deployment.yaml)
> 3. Ajuste as variáveis de ambiente nos ConfigMaps
> 4. Habilite stages de Sonar/Testes no Jenkinsfile se necessário
> 5. Configure o webhook Discord se deixou em branco

---

# VARIÁVEIS CONSOLIDADAS

| Variável | Skill(s) | Descrição |
|----------|----------|-----------|
| `PROJECT_NAME` | Todas | Nome do projeto (lowercase-com-hifens) |
| `PROJECT_DIR` | Go Initializer | Diretório do projeto |
| `GO_VERSION` | Go Initializer | Versão do Go (se STACK = Go) |
| `STACK` | Devcontainer | Stack/linguagem principal |
| `NAMESPACE` | Kubernetes | Namespace K8s |
| `APP_PORT` | Kubernetes | Porta da aplicação |
| `HEALTH_PORT` | Kubernetes | Porta do health check |
| `HEALTH_PATH` | Kubernetes | Path do health check |
| `INGRESS_HOST_DEV` | Kubernetes | Host ingress development |
| `INGRESS_HOST_PROD` | Kubernetes | Host ingress production |
| `INGRESS_HOST_INTERNAL` | Kubernetes | Host ingress interno (derivado) |
| `BITBUCKET_REPO` | Jenkins | URL do repositório |
| `DISCORD_WEBHOOK` | Jenkins | Webhook Discord |
| `SQUADS` | Jenkins | Squads para notificação |
| `JENKINS_WORKSPACE_NAME` | Jenkins (prod) | Nome workspace Jenkins (derivado) |
