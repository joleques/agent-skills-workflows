---
description: Orquestra as skills engineering-writer e engineering-writer-revisor para produzir artigos técnicos sobre arquitetura de software com ciclo de revisão automática
---

# Workflow: Write Article

Este workflow orquestra dois agentes especializados para produzir artigos técnicos sobre arquitetura de software com ciclo de escrita e revisão automática. Utiliza a skill `researcher` para pesquisar referências automaticamente com base no tema. Quando o formato alvo é **rede social** (LinkedIn, Instagram), a skill `social-media-psychology` é acionada para otimizar o conteúdo para a plataforma.

## Pré-requisitos

- Skills disponíveis em:
  - `.agent/skills/engineering-writer/SKILL.md`
  - `.agent/skills/engineering-writer-revisor/SKILL.md`
  - `.agent/skills/researcher/SKILL.md`
  - `.agent/skills/designer/SKILL.md`
  - `.agent/skills/social-media-psychology/SKILL.md`

---

## Passos do Workflow

### 1. Coletar parâmetros do usuário

Pergunte ao usuário:

1. **Tema**: Qual o tema ou assunto do artigo?

2. **Descrição**: Uma breve descrição do que o artigo deve abordar — contexto, ângulo, público-alvo ou problema que motivou o texto.

3. **Formato**: Qual o formato desejado?
   - Post LinkedIn (150–300 palavras) → **rede social**
   - Artigo médio (600–1000 palavras) → **blog**
   - Artigo aprofundado (1000–1800 palavras) → **blog**
   - Se não informado, usar **Artigo médio** como padrão

4. **Plataforma visual** (se aplicável): Se no futuro o Designer for acionado, para qual plataforma?
   - LinkedIn, Instagram ou Nenhuma (apenas blog)
   - Essa informação é usada para decidir se o Designer deve consultar `social-media-psychology`
   - Se não informado, inferir da plataforma do formato (Post LinkedIn → LinkedIn; casos ambíguos → perguntar)

Aguarde a resposta antes de prosseguir.

> [!NOTE]
> **Regra de ativação:** A skill `social-media-psychology` é acionada **somente** quando o formato ou a plataforma visual é de rede social (LinkedIn ou Instagram). Para artigos de blog, ela **não** é consultada.

5. **Diretório de saída**: Após coletar os parâmetros, gere o slug do título em `kebab-case` (sem acentos, espaços ou caracteres especiais) e defina o diretório base de trabalho:

```
artigos/{titulo-slug}/
├── content/    ← artigo final + revisões
├── search/     ← resultados de pesquisa
└── image/      ← imagens geradas
```

Crie as pastas automaticamente caso não existam.

---

### 2. Pesquisar Referências (Skill Researcher)

Após coletar os parâmetros, execute a skill `researcher` para buscar referências automaticamente:

1. Leia a skill do Pesquisador:

```
.agent/skills/researcher/SKILL.md
```

2. Execute a skill passando:
   - **Tema**: o mesmo tema informado pelo usuário no passo 1
   - **Diretório de output**: `artigos/{titulo-slug}/search/` (a skill deve salvar os resultados neste diretório em vez do padrão `search/`)
   - Deixe que a skill pergunte ao usuário as demais informações necessárias (como período e quantidade de links).

3. Após a pesquisa, apresente os resultados ao usuário no seguinte formato:

```
🔍 Encontrei as seguintes referências sobre "[TEMA]":

1. [Título do Resultado] — [Resumo breve]
   🔗 [URL]

2. [Título do Resultado] — [Resumo breve]
   🔗 [URL]

(... até N resultados)

Quais links você quer usar como referência para o artigo?
Informe os números separados por vírgula (ex: 1, 3, 5) ou "nenhum" para prosseguir sem referências.
```

4. Aguarde a seleção do usuário antes de prosseguir

> [!IMPORTANT]
> O usuário decide quais links serão usados. Não assuma que todos os resultados serão aproveitados.

---

### 3. Preparar Contexto

Antes de acionar o Escritor:

1. Para cada link **selecionado pelo usuário** no passo 2, leia o conteúdo completo usando a tool `read_url_content`
2. Organize o material coletado como contexto suplementar para o Escritor
3. Não copie os links — use-os como **inspiração e base técnica**

> [!NOTE]
> Se o usuário escolheu "nenhum" no passo 2, pule a leitura de links e prossiga direto para o passo 4.

---

### 4. Consultar Social Media Psychology (Condicional)

**Condição:** Execute este passo **SOMENTE** se o formato for de rede social (Post LinkedIn).

Se for artigo de blog (médio ou aprofundado), **pule para o passo 5**.

1. Leia a skill:

```
.agent/skills/social-media-psychology/SKILL.md
```

2. Execute no **Modo Consulta** passando:
   - `plataforma_alvo`: `linkedin` (ou a plataforma identificada)
   - `formato`: `post-texto` ou `carrossel` (conforme o caso)
   - `objetivo`: inferir do contexto (default: `engajamento`)

3. A skill retornará **Diretrizes de Otimização** com:
   - Fatores de algoritmo relevantes
   - Estrutura recomendada (hook, corpo, CTA, hashtags)
   - Gatilhos psicológicos recomendados
   - Anti-patterns a evitar

4. **Passe essas diretrizes como contexto adicional** para o Escritor no passo seguinte.

---

### 5. Executar Agente Escritor (Iteração 1)

Leia a skill do Escritor:

```
.agent/skills/engineering-writer/SKILL.md
```

Aplique todas as regras da skill para gerar o artigo, passando:

- **Tema** informado pelo usuário
- **Descrição** e contexto fornecido
- **Formato** solicitado (LinkedIn, médio, aprofundado)
- **Material de referência** coletado dos links selecionados (se houver)
- **Diretrizes de Social Media** (se geradas no passo 4 — apenas para rede social)

O artigo deve seguir a estrutura das 5 seções:

1. Problema ou Provocação Inicial
2. Contexto Técnico
3. Experiência Prática
4. Explicação ou Análise
5. Conclusão

Guarde o artigo gerado para o próximo passo.

---

### 6. Executar Agente Revisor

Leia a skill do Revisor:

```
.agent/skills/engineering-writer-revisor/SKILL.md
```

Aplique o checklist de validação ao artigo gerado. O resultado deve ser:

- **✅ APROVADO**: Prossiga para o passo 6.5
- **⚠️ AJUSTAR** ou **❌ REESCREVER**: Prossiga para o passo 7

---

### 6.5. Revisão Social Media Psychology (Condicional)

**Condição:** Execute este passo **SOMENTE** se o formato for de rede social (Post LinkedIn) **E** o Revisor técnico já aprovou (✅).

Se for artigo de blog, **pule para o passo 8**.

1. Leia a skill:

```
.agent/skills/social-media-psychology/SKILL.md
```

2. Execute no **Modo Revisão** passando:
   - `plataforma_alvo`: `linkedin` (ou a plataforma identificada)
   - `formato`: `post-texto` ou `carrossel`
   - `conteudo_base`: o artigo aprovado pelo revisor técnico

3. A skill retornará um **Checklist de Conformidade** com veredicto:
   - **✅ OTIMIZADO**: Prossiga para o passo 8
   - **⚠️ AJUSTAR**: Aplique as sugestões de melhoria e prossiga para o passo 8
   - **❌ RETRABALHAR**: Volte ao passo 5 com as sugestões como contexto adicional

> [!NOTE]
> A revisão de engajamento **não substitui** a revisão técnica — ela complementa. O artigo deve ser bom tecnicamente E otimizado para a plataforma.

---

### 7. Loop de Correção (se não aprovado)

Se o Revisor técnico não aprovou o artigo:

1. Extraia a lista de problemas encontrados do relatório do Revisor
2. Volte ao passo 5, mas agora passe ao Escritor:
   - O artigo atual
   - A lista de problemas para correção
   - As sugestões do Revisor
3. O Escritor deve ajustar APENAS os pontos indicados, preservando o que já estava bom
4. Repita o passo 6 (revisão técnica)

**Regra do loop:**

```
┌──────────────────────────────────────────────────────┐
│  Iteração 1–4: Revisor reprova → Escritor ajusta     │
│  Iteração 5:   Se ainda reprovado → PARA             │
│                Entrega com ressalvas ao usuário       │
└──────────────────────────────────────────────────────┘
```

- **Máximo de 5 iterações** (escrita + revisão) para evitar loops infinitos
- A cada iteração, registre mentalmente o número da iteração atual
- Se após 5 iterações ainda houver problemas, prossiga para o passo 8 com ressalvas

---

### 8. Salvar Artigo Final

Salve o artigo no diretório `artigos/{titulo-slug}/content/` na raiz do projeto, criando-o caso não exista.

**Regras para o nome do arquivo:**
- Use o tema como base para o nome
- Formato: `kebab-case.md` (ex: `microservicos-trade-offs.md`)
- Sem acentos, espaços ou caracteres especiais
- Relatórios de revisão também devem ser salvos em `content/` (ex: `revisao-v1.md`, `revisao-v2.md`)

---

### 9. Notificar Usuário

Use a tool `notify_user` para informar ao usuário:

**Se APROVADO pelo Revisor:**

```
✅ Artigo APROVADO pelo Revisor

📄 Arquivo: [caminho completo]
🔄 Iterações: [número de iterações até aprovação]
📏 Formato: [formato]
📝 Tema: [tema]
🔗 Referências: [quantidade de links selecionados]
```

**Se entregue com RESSALVAS (5 iterações sem aprovação):**

```
⚠️ Artigo entregue com RESSALVAS

📄 Arquivo: [caminho completo]
🔄 Iterações: 5 (limite atingido)
📏 Formato: [formato]
📝 Tema: [tema]
🔗 Referências: [quantidade de links selecionados]

Problemas pendentes:
- [lista dos problemas que o Revisor ainda apontou na última revisão]

Recomendação: revise manualmente os pontos acima antes de publicar.
```

Inclua o caminho do arquivo em `PathsToReview` para o usuário revisar o conteúdo.

---

### 10. Geração de Imagens (Skill Designer)

Após a finalização e notificação do artigo, ofereça a criação de materiais visuais (imagens, infográficos, slides, carrosséis) baseados no texto recém-escrito.

1. Pergunte ao usuário:
   `Gostaria de gerar imagens ou materiais visuais (ex: carrossel para LinkedIn, infográfico) baseados neste artigo usando a skill Designer? (S/N)`
2. Aguarde a resposta.
3. Se "Sim", pergunte qual formato e quantidade de imagens deseja.

#### 10.1. Consultar Social Media Psychology para Design (Condicional)

**Condição:** Execute este sub-passo **SOMENTE** se a plataforma visual for de rede social (LinkedIn ou Instagram).

Se for conteúdo para blog ou sem plataforma específica, **pule para 10.2**.

1. Leia a skill:

```
.agent/skills/social-media-psychology/SKILL.md
```

2. Execute no **Modo Consulta** passando:
   - `plataforma_alvo`: `linkedin` ou `instagram-feed` / `instagram-reels` / `instagram-stories`
   - `formato`: `post-imagem`, `carrossel` ou `reel`
   - `conteudo_base`: o artigo final

3. A skill retornará diretrizes específicas para o design na plataforma (tamanho, densidade de texto, hooks visuais, etc.)

4. **Passe essas diretrizes como contexto adicional** para o Designer.

#### 10.2. Executar Skill Designer

Leia a skill do Designer:

```
.agent/skills/designer/SKILL.md
```

Execute a skill passando:
   - O conteúdo do artigo final como base para a criação visual
   - **Diretório de output**: `artigos/{titulo-slug}/image/` (a skill deve salvar as imagens neste diretório em vez do padrão `image/`)
   - **Diretrizes de Social Media** (se geradas no passo 10.1 — apenas para rede social)
   - Siga as regras da skill

#### 10.3. Revisão Social Media Psychology do Design (Condicional)

**Condição:** Execute este sub-passo **SOMENTE** se a plataforma visual for de rede social (LinkedIn ou Instagram) **E** o Designer já gerou os materiais.

Se for conteúdo para blog, **pule este passo**.

1. Leia a skill:

```
.agent/skills/social-media-psychology/SKILL.md
```

2. Execute no **Modo Revisão** passando:
   - `plataforma_alvo`: a plataforma identificada
   - `formato`: o formato visual gerado
   - `conteudo_base`: o caption/texto do design gerado

3. Se houver ajustes recomendados pela revisão de engajamento, aplique-os no design antes de finalizar.

---

## Exemplos de Uso

### Exemplo 1 — Artigo de Blog (sem social-media-psychology)

```
/write-tech-article

> Qual o tema do artigo?
Microserviços prematuros

> Descreva brevemente o que o artigo deve abordar:
Sobre como equipes adotam microserviços cedo demais, antes de entender
os limites do domínio, e como isso cria mais problemas do que resolve.

> Qual o formato? (LinkedIn / médio / aprofundado)
Artigo médio

> 🔍 Pesquisando referências sobre "Microserviços prematuros"...
> (... resultados da pesquisa ...)
> Quais links você quer usar? (ex: 1, 3, 5)

> 1, 3

> Preparando contexto com 2 referências selecionadas...
> ℹ️ Formato: artigo de blog — social-media-psychology não acionada
> Escrevendo artigo... (iteração 1/5)
> Revisando (revisor técnico)...
> ⚠️ Ajustes necessários: tom, trade-offs
> Reescrevendo... (iteração 2/5)
> Revisando...
> ✅ APROVADO
>
> Arquivo salvo em: ./artigos/microservicos-prematuros/content/microservicos-prematuros.md
```

### Exemplo 2 — Post LinkedIn (com social-media-psychology)

```
/write-tech-article

> Qual o tema do artigo?
Clean Architecture mal aplicada

> Descreva brevemente o que o artigo deve abordar:
Como times criam pastas domain/use_case/infra sem entender o porquê

> Qual o formato? (LinkedIn / médio / aprofundado)
Post LinkedIn

> 🔍 Pesquisando referências...
> Quais links você quer usar?

> nenhum

> 🧠 Formato: rede social — consultando social-media-psychology...
> Diretrizes recebidas: hook provocativo, 1-3 hashtags, Golden Hour
>
> Escrevendo post... (iteração 1/5)
> Revisando (revisor técnico)...
> ✅ APROVADO
> 🧠 Revisando engajamento (social-media-psychology)...
> ⚠️ Hook pode ser mais forte, CTA mais direto
> Aplicando ajustes de engajamento...
> ✅ OTIMIZADO
>
> Arquivo salvo em: ./artigos/clean-architecture-mal-aplicada/content/clean-architecture-mal-aplicada.md
>
> Gostaria de gerar imagens para este post? (S/N)

> S — carrossel de 5 imagens para LinkedIn

> 🧠 Consultando social-media-psychology para design LinkedIn...
> Diretrizes: 1080x1080, texto curto por slide, hook visual no slide 1
> Gerando carrossel...
> 🧠 Revisando design para engajamento LinkedIn...
> ✅ OTIMIZADO
> Imagens salvas em: ./artigos/clean-architecture-mal-aplicada/image/
```

