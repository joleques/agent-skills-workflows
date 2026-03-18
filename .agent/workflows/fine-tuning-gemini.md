---
description: Orquestra a geração e revisão de datasets para Fine-Tuning de LLMs, em um ciclo iterativo de curadoria (máx 5x).
---

# Fluxo de Geração e Revisão de Dataset (SFT Pipeline)

Siga rigorosamente os passos abaixo para orquestrar a montagem de um dataset de alta qualidade, garantindo que o sintatizador e o revisor conversem entre si até atingir a excelência.

1. **Coleta de Insumos:**
   Pergunte ao usuário todos os parâmetros iniciais, se não tiverem sido fornecidos: Título do produto, Arquivo de Perguntas (obrigatório para a base de inicial de QA), Diretório do Log de Interações (Langfuse), Diretório da Documentação do Produto, e Número de Linhas a Gerar.

2. **Geração de Base de Respostas (Skill `answers-questions`):**
   Invoque a skill `answers-questions` fornecendo explicitamente o Arquivo de Perguntas, o Diretório da Documentação e o Título do Produto (para usar no arquivo final gerado, ex. `respostas-meu-produto.md`). Deixe a skill gerar o arquivo com as respostas.

3. **Ciclo de Revisão das Respostas (MÁXIMO DE 5 ITERAÇÕES):**
   Inicie um laço de repetição no qual você assumirá um contador de 1 a 5 para tentar aprovar as respostas geradas.
   
   **A. Rodar Revisor (Skill `answers-questions-revisor`):**
   Acione a skill `answers-questions-revisor` apontando para o arquivo `.md` de respostas gerado pela etapa 2. O revisor criará um relatório de melhorias.

   **B. Avaliar Relatório:**
   - Se o relatório gerado na etapa A não apontar falhas estruturais, de AI-splaining, ou robóticas severas, considere o QA APROVADO e **AVANCE PARA A PRÓXIMA ETAPA (Etapa 4)**.
   - Se o relatório apontar falhas, siga para a etapa C.

   **C. Rodar Correção (Skill `answers-questions`):**
   Se o limite de 5 iterações NÃO tiver sido atingido, acione novamente a skill `answers-questions` em **MODO DE CORREÇÃO**. Forneça obrigatoriamente a ela o título atual do arquivo de respostas e o relatório atual do revisor apontando as melhorias.

   **D. Tratamento de Exaustão do QA:**
   Se bater na 5ª iteração e o revisor ainda apontar que existem melhorias, interrompa este ciclo do QA e avise no chat a pendência. Peça explicitamente autorização para o usuário: *"As respostas do QA falharam na 5ª revisão. Deseja utilizar o material atual e avançar para a geração do dataset de fine-tuning mesmo assim?"* Se o usuário disser que sim, siga para a etapa 4.

4. **Geração Inicial do Dataset (Skill `dataset-synthesizer`):**
   Invoque a skill `dataset-synthesizer` passando todos os parâmetros (Título, Logs, Diretório Docs, Número de Linhas). **OBRIGATORIAMENTE**, diga à skill para incluir/cruzar o arquivo de respostas `.md` validado da etapa 3 como insumo extra na hora em que ela for processar ou sintetizar as perguntas. O agente gerará a primeira versão do dataset (ex: `./agentAI/fine-tuning/meu-produto/dataset/meu-produto.jsonl`).

5. **Ciclo de Revisão e Correção do Dataset (MÁXIMO DE 5 ITERAÇÕES):**
   Inicie um novo laço de repetição. Você (o Agente Orquestrador) manterá um contador de iterações, de 1 até 5.
   
   **A. Rodar Revisor (Skill `dataset-synthesizer-revisor`):**
   Acione a skill `dataset-synthesizer-revisor` apontando estritamente para o último `.jsonl` gerado. O revisor auditará o conteúdo e criará um relatório `.md` na mesma pasta (ex: `meu-produto-revisao-vX.md`).
   
   **B. Avaliar Relatório:**
   Leia o relatório `.md`. 
   - Se o relatório apontar **Total de Linhas Problemáticas: 0** (ou apenas apontar que não há falhas críticas), **ENCERRE O FLUXO COM SUCESSO** e avise o usuário que o dataset está perfeito e pronto para subir no Vertex AI.
   - Se o relatório apontar falhas, siga para a etapa C.

   **C. Rodar Correção (Skill `dataset-synthesizer`):**
   Se o limite de 5 iterações NÃO tiver sido atingido, acione novamente a skill `dataset-synthesizer`. Você DEVE passar explicitamente o caminho do dataset `.jsonl` E o caminho do relatório `.md` atual. Peça que a skill execute em **MODO DE CORREÇÃO**, ajustando apenas as linhas criticadas no relatório.

6. **Tratamento de Exaustão do Dataset (Limite de 5x atingido):**
   Se o fluxo bater na 5ª iteração real de JSON e o revisor AINDA apontar problemas no 5º relatório `.md`, **INTERROMPA O CICLO AUTOMATICAMENTE**. 
   Entregue ao usuário o arquivo `.jsonl` atual e alerte-o na tela: 
   > ⚠️ *"Atenção: O dataset final foi gerado e revisado 5 vezes, porém paralisamos o ciclo de correções automáticas para evitar loop infinito. O arquivo possui ressalvas remanescentes que você precisa avaliar manualmente. Consulte o último relatório de revisão gerado."*
