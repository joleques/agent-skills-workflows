# criado workflow do documentador de apis

📅 Data: 2026-03-22 11:17
🔖 Ticket: Sem ticket
🔗 Commit:
👤 Branch: main

---

## Arquivos Alterados

| Arquivo | Tipo de Alteração |
|---------|-------------------|
| `.agent/workflows/doc-api.md` | Novo |
| `README.md` | Modificado |

---

## Resumo das Alterações

Criação do workflow `/doc-api` que orquestra as skills `api-documentador` e `api-documentador-revisor` para gerar documentação de APIs em camadas com ciclo de revisão automática de até 5 iterações. O workflow segue o padrão dos existentes (`/write-tech-article`, `/hermes`): coleta de parâmetros → execução do documentador → revisão → loop de correção → notificação. O `README.md` do projeto foi atualizado com o novo workflow na árvore de diretórios e na tabela de workflows disponíveis.

---

## Diff Resumido

- **doc-api.md**: Workflow completo com 5 passos (coleta de inputs, execução do documentador, revisão, loop de correção com máx 5 iterações, notificação), frontmatter no padrão, exemplo de uso e templates de mensagem para aprovação e ressalvas.
- **README.md**: Adicionadas 2 linhas — `/doc-api` na árvore de diretórios e na tabela de workflows disponíveis.
