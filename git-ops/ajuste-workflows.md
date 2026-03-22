# ajuste workflows

📅 Data: 2026-03-22 16:30
🔖 Ticket: Sem ticket
🔗 Commit: ec776c5 (ec776c5ec67d5791d7b81df753d59b527dafff0a)
👤 Branch: main

---

## Arquivos Alterados

| Arquivo | Tipo de Alteração |
|---------|-------------------|
| `.agent/skills/designer/README.md` | Modificado |
| `.agent/skills/designer/SKILL.md` | Modificado |
| `.agent/skills/instagram-poster/README.md` | Modificado |
| `.agent/skills/instagram-poster/SKILL.md` | Modificado |
| `.agent/skills/instagram-poster/scripts/post-instagram.sh` | Modificado |
| `.agent/skills/linkedin-poster/README.md` | Novo |
| `.agent/skills/linkedin-poster/SKILL.md` | Novo |
| `.agent/skills/linkedin-poster/scripts/post-linkedin.sh` | Novo |
| `.agent/skills/researcher/README.md` | Modificado |
| `.agent/skills/researcher/SKILL.md` | Modificado |
| `.agent/workflows/write-tech-article.md` | Modificado |
| `AGENTS.md` | Modificado |
| `README.md` | Modificado |

---

## Resumo das Alterações

Criação da skill `linkedin-poster` (SKILL.md + script `post-linkedin.sh` + README) para publicação no LinkedIn via Posts API v2 gratuita, com suporte a posts de texto, imagem e artigos com link preview.

Unificação do arquivo de configuração de redes sociais: ambas as skills (`instagram-poster` e `linkedin-poster`) agora leem credenciais de `artigos/.config-social-media.json` com seções separadas `instagram` e `linkedin`, substituindo o antigo `.config-instagram.json`.

Reorganização da estrutura de output do workflow `write-tech-article`: todo conteúdo gerado agora fica organizado em `artigos/{titulo-slug}/` com subpastas `content/` (artigo + revisões), `search/` (pesquisa) e `image/` (imagens). Skills `researcher` e `designer` foram atualizadas para aceitar diretório de output opcional — quando chamadas standalone mantêm comportamento padrão.

Remoção do passo de publicação em redes sociais do workflow (será melhorado separadamente). Atualização de todos os READMEs e AGENTS.md para refletir as mudanças.

---

## Diff Resumido

- **linkedin-poster/SKILL.md**: Nova skill com onboarding guiado, fluxo de texto/imagem/artigo, tratamento de erros, limites da API
- **linkedin-poster/scripts/post-linkedin.sh**: Script com suporte a 3 tipos de post (text, image, article), upload direto de imagem, funções auxiliares reutilizáveis
- **instagram-poster/SKILL.md**: Refatorado config de `.config-instagram.json` → `artigos/.config-social-media.json` seção `instagram`
- **instagram-poster/scripts/post-instagram.sh**: Leitura de config com `.instagram.account_id` em vez de `.instagram_account_id`
- **researcher/SKILL.md**: Adicionado suporte a diretório de output opcional
- **designer/SKILL.md**: Adicionado suporte a diretório de output opcional
- **write-tech-article.md**: Passo 1 gera slug e define `artigos/{titulo}/`, passos redirecionam output, removido passo 10 de social media
- **AGENTS.md**: Adicionadas skills `instagram-poster` e `linkedin-poster`
- **README.md**: Árvore de diretórios e descrição do workflow atualizados
