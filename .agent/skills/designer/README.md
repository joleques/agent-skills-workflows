# 🎨 Skill: Designer

A skill **Designer** transforma o agente de IA em uma Diretora de Arte Sênior focada em marketing de conteúdo e design de alto impacto. Ela é projetada para criar e estruturar peças visuais (imagens, carrosséis, slides e animações) sempre baseadas em um conteúdo textual de entrada.

## 🎯 Objetivo

Transformar textos, artigos ou resumos fornecidos pelo usuário em peças visuais coerentes e esteticamente atraentes, adaptadas ao formato ideal da plataforma de destino (Instagram, LinkedIn, TikTok, Apresentações).

## 🚀 Como Funciona

1. **Conteúdo Restrito:** A skill **não inventa** conteúdo do zero. O usuário deve obrigatoriamente fornecer o texto base ou o caminho de um arquivo (`.md`, `.txt`) que será a fundação da imagem.
2. **Abordagem Web-First:** Antes de gerar qualquer imagem, a skill cria a estrutura do design em código (`HTML/CSS`), salvando-o no diretório padronizado do projeto.
3. **Organização de Ativos:** Todo material gerado (HTMLs e Imagens finais) é salvo obrigatoriamente dentro de `/image/[tema-do-trabalho]/` na raiz do workspace.
4. **Formatos Suportados:**
   - **Instagram:** Posts feed, stories, carrosséis.
   - **LinkedIn:** Posts únicos, carrosséis informativos, infográficos estruturados.
   - **TikTok / Reels:** Roteiros ou drafts visuais verticais (1080x1920).
   - **Slides:** Apresentações Widescreen (16:9).

## 💻 Exemplo de Uso

Você pode acionar a skill solicitando algo como:

> *"Usando a skill designer, crie um infográfico para o LinkedIn baseado no conteúdo do arquivo `/artigos/meu-novo-artigo.md`. Salve os assets na pasta de acordo com o padrão."*

## 🗂️ Arquivos Relacionados

* `SKILL.md`: Contém o prompt de comportamento, tom e restrições arquiteturais da skill repassadas ao agente de IA.
