---
description: Orquestra as skills engineering-writer e engineering-writer-revisor para produzir artigos técnicos sobre arquitetura de software com ciclo de revisão automática
---

# Workflow: Write Article

Este workflow orquestra dois agentes especializados para produzir artigos técnicos sobre arquitetura de software com ciclo de escrita e revisão automática.

## Pré-requisitos

- Skills disponíveis em:
  - `.agent/skills/engineering-writer/SKILL.md`
  - `.agent/skills/engineering-writer-revisor/SKILL.md`

---

## Passos do Workflow

### 1. Coletar parâmetros do usuário

Pergunte ao usuário:

1. **Tema**: Qual o tema ou assunto do artigo?

2. **Descrição**: Uma breve descrição do que o artigo deve abordar — contexto, ângulo, público-alvo ou problema que motivou o texto.

3. **Formato**: Qual o formato desejado?
   - Post LinkedIn (150–300 palavras)
   - Artigo médio (600–1000 palavras)
   - Artigo aprofundado (1000–1800 palavras)
   - Se não informado, usar **Artigo médio** como padrão

4. **Links de referência** (opcional): URLs de artigos, documentações ou conteúdos que servem como referência ou inspiração. Se fornecidos, leia o conteúdo dos links para enriquecer o artigo.

5. **Diretório de saída**: Onde salvar o artigo final?
   - Caminho absoluto ou relativo para o diretório de destino

Aguarde a resposta antes de prosseguir.

---

### 2. Preparar Contexto

Antes de acionar o Escritor:

1. Se o usuário forneceu **links de referência**, leia o conteúdo de cada link usando a tool `read_url_content`
2. Organize o material coletado como contexto suplementar para o Escritor
3. Não copie os links — use-os como **inspiração e base técnica**

---

### 3. Executar Agente Escritor (Iteração 1)

Leia a skill do Escritor:

```
.agent/skills/engineering-writer/SKILL.md
```

Aplique todas as regras da skill para gerar o artigo, passando:

- **Tema** informado pelo usuário
- **Descrição** e contexto fornecido
- **Formato** solicitado (LinkedIn, médio, aprofundado)
- **Material de referência** coletado dos links (se houver)

O artigo deve seguir a estrutura das 5 seções:

1. Problema ou Provocação Inicial
2. Contexto Técnico
3. Experiência Prática
4. Explicação ou Análise
5. Conclusão

Guarde o artigo gerado para o próximo passo.

---

### 4. Executar Agente Revisor

Leia a skill do Revisor:

```
.agent/skills/engineering-writer-revisor/SKILL.md
```

Aplique o checklist de validação ao artigo gerado. O resultado deve ser:

- **✅ APROVADO**: Prossiga para o passo 6
- **⚠️ AJUSTAR** ou **❌ REESCREVER**: Prossiga para o passo 5

---

### 5. Loop de Correção (se não aprovado)

Se o Revisor não aprovou o artigo:

1. Extraia a lista de problemas encontrados do relatório do Revisor
2. Volte ao passo 3, mas agora passe ao Escritor:
   - O artigo atual
   - A lista de problemas para correção
   - As sugestões do Revisor
3. O Escritor deve ajustar APENAS os pontos indicados, preservando o que já estava bom
4. Repita o passo 4 (revisão)

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
- Se após 5 iterações ainda houver problemas, prossiga para o passo 6 com ressalvas

---

### 6. Salvar Artigo Final

Salve o artigo no diretório de saída informado pelo usuário no passo 1.

**Regras para o nome do arquivo:**
- Use o tema como base para o nome
- Formato: `kebab-case.md` (ex: `microservicos-trade-offs.md`)
- Sem acentos, espaços ou caracteres especiais

---

### 7. Notificar Usuário

Use a tool `notify_user` para informar ao usuário:

**Se APROVADO pelo Revisor:**

```
✅ Artigo APROVADO pelo Revisor

📄 Arquivo: [caminho completo]
🔄 Iterações: [número de iterações até aprovação]
📏 Formato: [formato]
📝 Tema: [tema]
```

**Se entregue com RESSALVAS (5 iterações sem aprovação):**

```
⚠️ Artigo entregue com RESSALVAS

📄 Arquivo: [caminho completo]
🔄 Iterações: 5 (limite atingido)
📏 Formato: [formato]
📝 Tema: [tema]

Problemas pendentes:
- [lista dos problemas que o Revisor ainda apontou na última revisão]

Recomendação: revise manualmente os pontos acima antes de publicar.
```

Inclua o caminho do arquivo em `PathsToReview` para o usuário revisar o conteúdo.

---

## Exemplo de Uso

```
/write-article

> Qual o tema do artigo?
Microserviços prematuros

> Descreva brevemente o que o artigo deve abordar:
Sobre como equipes adotam microserviços cedo demais, antes de entender
os limites do domínio, e como isso cria mais problemas do que resolve.

> Qual o formato? (LinkedIn / médio / aprofundado)
Artigo médio

> Tem links de referência? (opcional)
https://martinfowler.com/bliki/MonolithFirst.html

> Onde salvar o artigo?
./artigos

> Escrevendo artigo... (iteração 1/5)
> Revisando...
> ⚠️ Ajustes necessários: tom, trade-offs
> Reescrevendo... (iteração 2/5)
> Revisando...
> ✅ APROVADO
>
> Arquivo salvo em: ./artigos/microservicos-prematuros.md
> Iterações: 2
```
