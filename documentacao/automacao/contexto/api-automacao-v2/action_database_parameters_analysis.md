# Configuração de Parâmetros de Ação (Ações de Análise)

Este documento descreve a estrutura esperada para as configurações de parâmetros associadas a uma regra de análise (coluna `aca_parentradalivre` no banco de dados). O formato baseia-se em um objeto JSON contendo propriedades que definem o comportamento, destino e fluxo de uma ação processada pelo ambiente.

Abaixo encontra-se a relação completa de todos os campos esperados, seus propósitos, regras de obrigatoriedade e os valores aceitáveis.

---

## 📋 Lista de Campos

### 1. `context` (Texto)
- **Descrição:** Identifica sob qual contexto primário de dados a ação buscará informações e será executada (em qual domínio de negócio ela resolve suas propriedades de origem).
- **Obrigatoriedade:** **Obrigatório**. A ausência dessa propriedade interrompe o processamento da regra com erro.
- **Valores possíveis:** "HISTORY" (Dados da Trilha de Histórico), "LOCAL" (Memória Transitória), "TASK" (Tarefa Sistêmica) ou "ANY" (Qualquer).

### 2. `url` (Texto)
- **Descrição:** URL de destino para onde a ação deverá ser enviada, caso se trate de uma integração externa com outras APIs ou sistemas via requisição web.
- **Obrigatoriedade:** **Obrigatório**.
- **Valores possíveis:** Endereço de web válido (ex: "https://api.exemplo.com/endpoint").

### 3. `target` (Numérico)
- **Descrição:** Especifica um identificador numérico do ambiente de destino ou código do cliente alvo durante a configuração do espaço de trabalho (Workspace) da ação, útil para roteamento de integrações.
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:** Números inteiros ou longos.

### 4. `action` (Texto)
- **Descrição:** Classifica e tipifica o método HTTP que será utilizado para a requisição web na integração com o destino.
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:** "INSERT" (Mapeia para POST) é o default, "UPDATE" (Mapeia para PUT) ou "PARTIAL_UPDATE" (Mapeia para PATCH).

### 5. `entityReference` (Texto)
- **Descrição:** Funcionam como metadados para indicar a qual é o conector de saida/entrega das Automações, pois é por ele que as automação fazem o de-para para api do cliente.
- **Obrigatoriedade:** **obrigatório**.
- **Valores possíveis:** Textos mapeando o alias do conector de saida/entrega.

### 5. `entityReferenceId` (Texto)
- **Descrição:** É o campo dentro do fieldMappings que define qual é o identificador único da api do cliente
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:** valor Alphanumerico.

### 6. `fieldMappings` (Lista de Objetos)
- **Descrição:** Define, na prática, os dados que comporão a carga (corpo) da execução dessa ação (o "payload"). Descreve de onde pegar a informação, o tipo do dado e como preenchê-lo na montagem dinâmica.
- **Obrigatoriedade:** **Obrigatório**. O JSON deve possuir o array de mapeamentos para execução. Omissão falha o processo.
- **Valores possíveis:** Uma lista estruturada de campos contendo:
    - **Modo de Origem (`originStrategy`):** Informa de onde o sistema tira esse valor (texto fixo, do banco, avaliado em execução, etc).
    - **Nome do Campo (`name`):** A chave ou título da propriedade.
    - **Valor de Reforço (`value`):** Texto complementar informacional.

### 7. `headers` (Lista de Objetos)
- **Descrição:** Permite configurar cabeçalhos do protocolo HTTP que devem ser enviados junto de uma requisição caso a ação demande se conectar externamente (muito usado para `Content-Type`, `Accept`, etc).
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:** Uma lista utilizando a mesma estrutura de campos flexíveis do `fieldMappings`.

### 8. `conditions` (Lista de Objetos)
- **Descrição:** Adiciona lógicas de "guarda". Se o conjunto de condições para a execução não for satisfeito, a ação em si não corre. É a regra de "sim ou não" atrelada aos dados.
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:** Uma lista de condições matemáticas lógicas contendo:
    - **Dado de avaliação 1:** Da mesma natureza dos `fieldMappings`.
    - **Operador de Teste:** O teste avaliativo em inglês: `"EQUALS"` (igual), `"NOT_EQUALS"` (diferente), `"CONTAINS"` (contém), `"GREATER_THAN"` (maior que), etc.
    - **Dado de avaliação 2 (opcional):** O valor a ser comparado (também suporta estrutura do `fieldMappings`).

### 9. `authentication` (Objeto)
- **Descrição:** Usado caso a URL de destino referenciada necessite de credenciais contínuas para aceitar comunicação (tokens que exigem cálculo interno do sistema, auth strategies pré-configuradas de clientes).
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:** Um objeto cujo conteúdo expressa em forma de campo (estrutura do `fieldMappings`) o meio/tática de autenticar e qual será a credencial.


### 11. `advancedSettings` (Objeto de Configurações Gerais/Avançadas)
- **Descrição:** Opções suplementares aplicadas após, ou antes, o transcorrer do disparo da ação, alteram como a Engine reage, traduz, reencaminha ou manipula fluxos.
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:**
    - **Ações Encadeadas (`chainedEvent`):** Quais chamadas engatilhar após este passo finalizar.
    - **Fluxos Simples (`nextActionWhenSuccess` / `nextActionWhenError`):** Qual roteamento primário seguir em caso de êxito ou erro (Listas de texto).
    - **Tradutor de Status (`translation`):** Altera respostas ou status de uma requisição de volta ao sistema por formatações locais de domínio ("De -> Para" condicional).
    - **Identidade Alternativa (`alternativeIdentifier`):** Troca qual dado assina univocamente a ação da original.
    - **Encurtador de Links (`shortenUrl`, `shortnerType`, `shortnerEntity`):** Flags indicando se dados da execução devem passar pelo encurtador e como registrar essas métricas de rastreamento.
    - **Extensões Especiais (`adapter`):** Determina serviços extras na plataforma que farão ponte com os dados.

### 12. `searchConnector` (Lista de Objetos)
- **Descrição:** Usada mais em automações completas, serve para interrogar serviços de busca e pré-carregar outras entidades do sistema à disposição para comporem o `payload` antes do disparo em si.
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:** Array de configuração de busca listando o `identifier` para salvar o que achou, e listas de `filters` baseados em `fieldMappings` indicando os parâmetros de refino a serem passados pro serviço buscador.

### 13. `reprocess` (Lista de Objetos)
- **Descrição:** Orienta as regras de tentativas baseando-se em cenários de falha. Exemplo: se falhar o envio para uma API, esta configuração dita quantas vezes ou qual tática usar (ex: esperar N min e tentar novo).
- **Obrigatoriedade:** Opcional.
- **Valores possíveis:** Lista de campos de mapeamento que apontam o serviço a ser vigiado para reprocessamento, e sua estratégia corretiva atrelada (quais filas cairão e quanto tempo dormir).



## 📋 Tabela de Campos e Configurações

| Nome do campo | Chave (nome do objeto JSON) | Tipo de Dado | Obrigatório | Descrição | Valores Possíveis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Contexto de Atuação** | `context` | Texto | **Sim** | Identifica sob qual contexto base a ação extrai as informações para montar seu escopo (em qual domínio ela opera). A ausência gera falha do disparo. | "HISTORY", "LOCAL", "TASK" ou "ANY". |
| **URL de Destino** | `url` | Texto | **Sim** | Endereço para roteamento e envio da ação caso seja uma integração externa web. | Endereço URL válido (ex: "https://api.empresa.com"). |
| **Ambiente Alvo** | `target` | Numérico | Não | Identificador numérico do ambiente de destino ou código do cliente alvo, usado para direcionar mensagens em integrações. | Números inteiros. |
| **Classificação de Ação** | `action` | Texto | Não | Classifica o método HTTP utilizado na requisição web de integração com o serviço de destino. | "INSERT", "UPDATE" ou "PARTIAL_UPDATE". |
| **Referência de Entidade** | `entityReference` | Texto | Sim | Metadado informando a qual "entidade" ou "tipo de dado" essa configuração age diretamente e se refere. | Textos com os nomes de referência (ex: "Pedido"). |
| **Identificador da Entidade** | `entityReferenceId` | Texto | Não | Código de rastreio que complementa a entidade; ajuda a auditar onde a operação ocorreu exatamente. | Códigos de referência em formato de texto numérico. |
| **Mapeamento de Dados** | `fieldMappings` | Lista de Objetos | **Sim** | Base do envio ("payload"). Mapeia as propriedades que serão montadas, de qual origem o valor virá, qual será o título (chave) e como deve ser formatado (texto, número, etc). Se omitido, falha a execução da regra. | Objeto informando tática de montagem de valor, nome descritivo e tipo formacional primário. |
| **Cabeçalhos de Requisição** | `headers` | Lista de Objetos | Não | Configura metadados para as requisições web caso a ação demande enviar tráfego à clientes externos (parametrizando tipo ou permissões do pacote). | Mesma estrutura que o mapeamento de dados. |
| **Condições Lógicas** | `conditions` | Lista de Objetos | Não | Adiciona lógicas de validação. A ação só executará se o pacote de testes condicionais for satisfeito na avaliação das propriedades que chegaram. | Objeto de teste contendo um dado a verificar e operadores como "Igual a", "Diferente", "Maior que". |
| **Autenticação Contínua** | `authentication` | Objeto | Não | Habilita configurações de senhas, credenciais dinâmicas ou tokens de cálculo se o destino exigir acessos barrados com validações de sessão contínuas. | Objeto base descrevendo o modelo de autenticação pela tática de montagem de valores. |
| **Configuração de Agrupador**| `grouper` | Objeto | Não | Permite que uma sequência de execuções soltas seja agrupada, ordenando concorrentes em caixas únicas (pacotes controlados) com base em um valor identificador. | Objeto com ordem posicional (número) e um identificador primário. |
| **Configurações Avançadas** | `advancedSettings` | Objeto | Não | Opções suplementares e flexíveis para traduzir fluxos, engatilhar passos sucessores, manipular links e invocar adaptadores nativos do sistema sobre a regra. | Objeto estrutural, pode mapear: Encurtadores de Links, Tradução de Retornos e Filas Encadeadas ("Próximo passo na Falha/Sucesso"). |
| **Buscas e Conectores** | `searchConnector` | Lista de Objetos | Não | Permite interrogar outras áreas e entidades da plataforma antes do disparo da regra atual para recuperar e incrementar (fazer pré-busca) os dados montados. | Configuração listando o filtro necessário à busca, modo de varredura global e nome do salvamento provisório. |
| **Tentativas e Falhas** | `reprocess` | Lista de Objetos | Não | Orienta a política de retentativa quando ocorre erro. Define serviços sentinelas, tempo adormecido e persistência em canais corretivos ou de reprocessamento. | Lista identificando um serviço de validação e a tática temporal da correção de filas falhadas. |


---

## 📦 Estrutura dos Subobjetos (Listas e Configurações Complexas)

Muitos dos campos principais exigem listas ou objetos aninhados para funcionar, agregando flexibilidade. Abaixo o detalhamento com as tabelas de cada "Subobjeto".

### 🔸 1. Tipo Padrão
Objeto mais utilizado do sistema, serve como a base para parâmetros (`fieldMappings`), cabeçalhos (`headers`) ou chaves identificadoras.

| Nome do campo | Chave JSON | Tipo de Dado | Obrigatório | Descrição | Valores Possíveis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Modo de Origem** | `originStrategy` | Texto | **Sim** | Instrui a plataforma de onde o valor desse campo deve ser extraído ou se é fixo. | "CONSTANT" (Valor Fixo), "HISTORY_FIELD" (Consulta por ID de campo), "CONTEXT_FIELD" (Vem do Ambiente), "SEARCH_CONNECTOR" (Resultado de Pré-Busca) ou "OBJECT_LIST_FROM_FIELDS" (Monta uma Sublista). |
| **Nome da Propriedade** | `name` | Texto | **Sim** | O título, a chave final que será montada no pacote ou no cabeçalho. | Palavras que formam chaves JSON de destino (ex: "id_pedido"). |
| **Conteúdo Fixo / Padrão** | `value` | Texto | Não | O texto estático ou código da variável usado para preencher a propriedade corrente. | Qualquer texto, numérico ou expressão que a Origem saiba processar. |
| **Sub-Valores (Listas)** | `values` | Lista de Objetos | Não | Quando a origem é uma lista complexa, as sub-propriedades que ela deve extrair são aninhadas aqui. | Mesma estrutura primária de Mapeamento de Dados. |
| **Ordenação** | `index` | Numérico | Não | Quando há concorrência numa coleção matricial de dados, informa em qual índice deve ser inserido. | Números inteiros maiores ou iguais a zero. |
| **Origem Externa da Lista** | `valueSource` | Objeto | Não | Quando ativado o modo `OBJECT_LIST_FROM_FIELDS`, define em qual lista complexa do evento o sistema deve iterar para formar a sublista atual. | Objeto interno contendo sua própria `originStrategy` ("HISTORY_FIELD" ou "SEARCH_CONNECTOR") e o caminho para o Array em `value`. |

### 🔸 2. Condições Lógicas (`Condition`)
Define testes matemáticos que barram ou liberam a regra de agir (área de `conditions`).

| Nome do campo | Chave JSON | Tipo de Dado | Obrigatório | Descrição | Valores Possíveis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Operando Esquerdo** | `operandLeft` | Objeto | **Sim** | O dado alvo principal extraído do pacote que será testado pela condição. | Estrutura de `Tipo Padrão`. |
| **Operador de Teste** | `operator` | Texto | **Sim** | A condicional ou texto da cláusula de comparação matemática/lógica. | "EQUALS", "NOT_EQUALS", "CONTAINS", "GREATER_THAN", etc. |
| **Operando Direito** | `operandRight` | Objeto | Não | O controle de referência contra o qual o valor testado da esquerda precisa bater. | Estrutura de `Tipo Padrão`. |

### 🔸 3. Agrupador (`Grouper`)
Forma pacotes contendo diversas ações filhas em uma única janela quando ativados no `grouper`.

| Nome do campo | Chave JSON | Tipo de Dado | Obrigatório | Descrição | Valores Possíveis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Chave de Agrupamento** | `identifier` | Objeto | Não | Configura qual dado único de execução garante que aqueles disparos parecidos pertençam ao mesmo grupo. | Estrutura de `Tipo Padrão`. |
| **Ordem Posicional** | `order` | Numérico | Não | Se em conflito com outros componentes de grupo, especifica a prioridade que tem de ser adotada. | Número de ordenação inteiro positivo. |

### 🔸 4. Conectores de Buscas (`SearchConnector`)
Responsável por conectar a plataforma externamente antes do disparo corrente (no parâmetro `searchConnector`).

| Nome do campo | Chave JSON | Tipo de Dado | Obrigatório | Descrição | Valores Possíveis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Identificação do Retorno**| `identifier` | Texto | Não | O nome de variável sob o qual os registros extraídos ficarão salvos na memória local para uso do payload. | Nomes descritivos e sem espaços (ex: "vendas_canceladas"). |
| **Filtros da Busca** | `filters` | Lista de Objetos | Não | Critérios que engessam a busca baseados em variáveis temporárias ou de payload pregressas. | Lista de `Tipo Padrão`. |
| **Componente Alvo** | `component` | Objeto | Não | Caso a integração busque num sistema global, qual formulário ou sub-aplicativo será interrogado. | Estrutura de `Tipo Padrão`. |
| **Verbo / Ação do Alvo** | `componentAction` | Objeto | Não | Tipo do roteiro de pesquisa acionado neste componente (ex: pegar listagem, detalhar único reg, etc). | Estrutura de `Tipo Padrão`. |

### 🔸 5. Configurações Avançadas (`AdvancedSettings`)
Dita o comportamento adicional de roteamento especial em `advancedSettings`.

| Nome do campo | Chave JSON | Tipo de Dado | Obrigatório | Descrição | Valores Possíveis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Adaptador Customizado** | `adapterType` | Texto | Não | Indica serviço acoplado de formatação do pacote (se haverá conversões antes do disparo para o cliente final). | Nomes base de adaptadores estáticos. |
| **Fluxos Encadeados** | `chainedEvent` | Objeto | Não | Dispara ações dinâmicas em cascata (sucesso e falhas), extraindo o ID do próximo passo da execução corrente. |  Sub-objeto definindo gatilhos (`success` e `error`) por meio de `Tipo Padrão`. |
| **Próxima Regra (Sucesso)**| `nextActionWhenSuccess`| Lista de Textos | Não | Fluxo Estático: Nome engessado da próxima ação a rodar se esta for um sucesso. | Texto nominal da Ação Cadastrada (IDs ou nomes das regras). |
| **Próxima Regra (Falha)** | `nextActionWhenError` | Lista de Textos | Não | Fluxo Estático: Nome engessado da ação alternativa/tratamento de erro. | Texto nominal de tratativas mapeadas no banco. |
| **Tradutor de Retorno** | `translation` | Objeto | Não | Intercepta retornos HTTP e dados e transforma-os. Se cliente manda status C o código sabe que vira D. | Formato `statusCode` listando lista de objetos com Antes (`before`) e Depois (`after`). |
| **Assinatura Alternativa** | `alternativeIdentifier`| Objeto | Não | Troca a assinatura unívoca e primária que o sistema acha que a regra possui baseada num mapeamento complexo . | Estrutura de `Tipo Padrão`. |
| **Encurtamento de URL** | `shortenUrl` | Booleano | Não | Ativa interceptação em URLs grandes inseridas no payload fazendo a troca do link bruto. | Flag Binária (`true` ou `false`). |
| **Tipo de Encurtador** | `shortnerType` | Texto | Não | Caso ativo "Encurtamento de URL", qual sistema será o hospedeiro link provider. | Textos indicando tipos fornecidos (ex: "NATIVE_SERVICE"). |
| **Monitoramento do Link** | `shortnerEntity` | Texto | Não | Parâmetro usado para agrupar métricas das ações dos clientes nos links criados encurtados. | Textos curtos de rastreio para Dashboards (ex: "promocao-abril"). |

### 🔸 6. Política de Reprocessamento (`Reprocessing`)
Opções em `reprocess` orientam onde a mensagem avisará que falhou.

| Nome do campo | Chave JSON | Tipo de Dado | Obrigatório | Descrição | Valores Possíveis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Serviço Rastreado** | `service` | Objeto | Não | Qual a camada de resiliência receberá o envio problemático. | Estrutura de `Tipo Padrão`. |
| **Tática de Tratamento** | `strategy` | Objeto | Não | As instruções para tempo de suspensão do pacote e seu reenvio gradativo num modelo de filas temporizadas. | Estrutura de `Tipo Padrão`. |

---

## 📝 Exemplo de JSON (Payload de Parâmetros)

Com base nos dados analisados acima, veja abaixo um exemplo válido de configuração de ação para o uso real do sistema, estruturado num cenário onde uma regra dispara um *Webhook Web* contendo informações primordiais sobre a alteração de status de um pedido.

> [!NOTE]
> **O Impacto do `searchConnector` no JSON:**
> Quando o array `searchConnector` é declarado, a *engine* da aplicação pausa a montagem e executa essas buscas consultando outros componentes previamente, pendurando os resultados em memória temporária sob as chaves definidas no seu `identifier`.
>
> O impacto disso é direto: isso habilita de que qualquer outro campo montável do JSON (como `fieldMappings`, `conditions` ou `headers`) agora possa usar a tática `"originStrategy": "SEARCH_CONNECTOR"` para injetar os dados dessa pré-busca nas requisições. Para recuperar o valor desejado do conector, basta referenciá-lo no atributo `value` através do formato `"<identifier>.<nome_do_campo>"`.

```json
{
  "context": "HISTORY",
  "url": "https://api.empresa.com.br/v2/webhook/pedidos",
  "action": "INSERT",
  "entityReference": "Venda_Pedidos",
  "entityReferenceId": "500XY",
  "searchConnector": [
    {
      "identifier": "cliente_ext",
      "component": {
        "originStrategy": "CONSTANT",
        "name": "componenteBusca",
        "value": "ConsultaClientesCRM"
      },
      "componentAction": {
        "originStrategy": "CONSTANT",
        "name": "acao",
        "value": "obterPorId"
      },
      "filters": [
        {
          "originStrategy": "HISTORY_FIELD",
          "name": "idCliente",
          "value": "1122"
        }
      ]
    }
  ],
  "fieldMappings": [
    {
      "originStrategy": "CONSTANT",
      "name": "empresaId",
      "value": "12345"
    },
    {
      "originStrategy": "SYSTEM_SETUP",
      "name": "tokenIntegracaoEstoque",
      "value": "ENV_TOKEN_ESTOQUE"
    },
    {
      "originStrategy": "CONTEXT_FIELD",
      "name": "vendedorResponsavel",
      "value": "CF_vendedor"
    },
    {
      "originStrategy": "SEARCH_CONNECTOR",
      "name": "scoreCredito",
      "value": "cliente_ext.score_vendas"
    },
    {
      "originStrategy": "HISTORY_FIELD",
      "name": "idDoPedido",
      "value": "3344"
    },
    {
      "originStrategy": "OBJECT_LIST_FROM_FIELDS",
      "name": "itens",
      "values": [
        {
          "originStrategy": "HISTORY_FIELD",
          "name": "codigo",
          "value": "5566"
        },
        {
          "originStrategy": "HISTORY_FIELD",
          "name": "quantidade_comprada",
          "value": "7788"
        }
      ]
    },
    {
      "originStrategy": "OBJECT_LIST_FROM_FIELDS",
      "name": "descontos_aplicados",
      "valueSource": {
        "originStrategy": "SEARCH_CONNECTOR",
        "value": "cliente_ext.historico_descontos"
      },
      "values": [
        {
          "originStrategy": "SEARCH_CONNECTOR",
          "name": "tipo",
          "value": "motivo"
        },
        {
          "originStrategy": "SEARCH_CONNECTOR",
          "name": "valor_abatido",
          "value": "valor"
        }
      ]
    }
  ],
  "headers": [
    {
      "originStrategy": "CONSTANT",
      "name": "Content-Type",
      "value": "application/json"
    },
    {
      "originStrategy": "CONSTANT",
      "name": "Authorization",
      "value": "Bearer dXN1YXJpbzpzZW5oYXMxMjM="
    }
  ],
  "conditions": [
    {
      "operandLeft": {
        "originStrategy": "HISTORY_FIELD",
        "name": "status",
        "value": "status_pedido"
      },
      "operator": "EQUALS",
      "operandRight": {
        "originStrategy": "CONSTANT",
        "name": "status_valido",
        "value": "APROVADO"
      }
    }
  ],
  "advancedSettings": {
    "shortenUrl": false,
    "nextActionWhenError": [
      "Notificar_Email_Suporte"
    ]
  },
  "reprocess": [
    {
      "service": {
        "originStrategy": "CONSTANT",
        "name": "servico_reprocessamento",
        "value": "SQS_RETRY_QUEUE"
      },
      "strategy": {
        "originStrategy": "CONSTANT",
        "name": "max_retry",
        "value": "3"
      }
    }
  ]
}
```
