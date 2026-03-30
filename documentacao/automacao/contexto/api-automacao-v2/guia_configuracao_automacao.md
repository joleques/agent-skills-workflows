# Guia Central de Configuração de Automações

Este guia descreve a mecânica por trás de toda configuração e envio de dados dentro do módulo de Automação. A melhor maneira de entender o sistema é aprender sobre a peça fundamental que compõe 90% das regras operacionais da plataforma.

---

## 🏗️ O Coração da Automação: O "Tipo Padrão"
Todo o poder de mapeamento dinâmico reside no formato de configuração chamado de **Tipo Padrão** (*FieldMapping*). Ele é uma estrutura universal projetada para "ensinar" o motor de execução as seguintes coisas: de onde buscar uma informação, qual nome dar a ela, e como aninhá-la.

Sempre que a plataforma monta um evento, testa uma lógica ou cria um cabeçalho, ela está lendo objetos de Tipo Padrão.

### A Estrutura de um Tipo Padrão
Um bloco básico de Tipo Padrão pede as seguintes instruções:
- **`name`** *(Obrigatório)*: A chave/título final de como o dado será chamado (ex: `"numero_pedido"` ou `"Content-Type"`).
- **`originStrategy`** *(Obrigatório)*: O motor ou tática de "Onde" buscar esse dado.
- **`value`**: Um valor fixo ou a rota de referência de busca, a depender da estratégia acima escolhida.
- **`values` e `index`**: Uma lista de outros Tipos Padrão filhos para montar objetos aninhados, sublistas ou coleções ordenadas por matriz.
- **`valueSource`**: O indicativo de qual local/lista externa a engine deve iterar para formar itens dinâmicos.

### Tipos de Origem (`originStrategy`) e Exemplos

De onde vem a informação que alimentará a chave configurada? Veja a explicação das Origens lado a lado com um **exemplo de uso de Tipo Padrão** declarando cada uma delas.

* **`CONSTANT`**: Valor puramente estático em texto (usa o que for digitado no `value`).
  ```json
  { "originStrategy": "CONSTANT", "name": "Authorization", "value": "Bearer XY1Z" }
  ```

* **`HISTORY_FIELD`**: Resgata um dado preenchido no histórico. No exemplo, busca o valor que está amarrado ao Campo de Atividade ID `14920`.
  ```json
  { "originStrategy": "HISTORY_FIELD", "name": "codigo_fiscal", "value": "14920" }
  ```

* **`CONTEXT_FIELD`**: Lê dados de campos do contexto escolhido para a automação em questão. Esses campos podem ser campos customizados da Entidade (`"CF_"`).
  ```json
  { "originStrategy": "CONTEXT_FIELD", "name": "cliente", "value": "history.task.local.name" }
  ```

* **`SYSTEM_SETUP`**: Extrai propriedades estáticas do motor. A chave "value" deve trazer um prefixo mandatório: usar "ENV_nomeDaVariavel" busca de Variáveis de Ambiente hospedadas no servidor e "SP_nomeDoParametro" busca de Parâmetros de Sistema (SystemParameter) registrados no banco de dados para aquele cliente. Pode-se também usar o valor exato "contextId" para exportar o id de contexto.
  ```json
  { "originStrategy": "SYSTEM_SETUP", "name": "app_token", "value": "ENV_TOKEN_EXTERNO" }
  ```

* **`SEARCH_CONNECTOR`**: Interroga retornos salvos temporariamente por buscas externas usando sintaxe `<referencia>.<chave>`. O uso desta origem **exige obrigatoriamente** que o componente preparatório `searchConnector` esteja configurado na Ação.
  ```json
  // 1. Configuração da pré-busca
  "searchConnector": [
    {
      "identifier": "busca_cep",
      "component": { "originStrategy": "CONSTANT", "name": "servicos", "value": "API_VIACEP" }
    }
  ],
  // 2. Consumo local do resultado na configuração final
  "fieldMappings": [
    { "originStrategy": "SEARCH_CONNECTOR", "name": "endereco", "value": "busca_cep.logradouro" }
  ]
  ```

* **`OBJECT_LIST_FROM_FIELDS`**: Modo de construção. Itera sobre listas do evento base mapeado em `valueSource` para montar repetições filhas (`values`).
  ```json
  {
    "originStrategy": "OBJECT_LIST_FROM_FIELDS",
    "name": "vendas",
    "valueSource": { "originStrategy": "HISTORY_FIELD", "value": "512" },
    "values": [
      { "originStrategy": "HISTORY_FIELD", "name": "desconto_aplicado", "value": "513" }
    ]
  }
  ```

---

## 📦 Estrutura da Ação: Montando as Peças
Ao invés de programar fluxos complexos, você "junta o lego". A configuração mestra de uma Ação se concentra em informar **para onde ir**, e em seguida preencher a base injetando blocos de **Tipos Padrão** nas chamadas "Gavetas de Tarefa".

### 1. Parâmetros Base (Roteamento)
- **`context`**: O domínio de onde as informações brotarão (HISTORY, TASK, LOCAL ou ANY).
- **`url`** e **`target`**: A URL de destino para webhooks integradores e o código hospedeiro.
- **`action`**: O verbo da operação (ex: INSERT = POST ou UPDATE = PUT).
- **`entityReference`**: Alias do conector de saída(template Bumblebee) que será utilizado para converter os dados e enviar a requisição.

### 2. Gavetas População (Construídas 100% por Tipos Padrões)
Nestas áreas, tudo o que o sistema espera receber e processar nada mais é do que listas de *Tipos Padrão*:

| Gaveta | Propósito na Ação |
| :--- | :--- |
| **`fieldMappings`** | **Corpo Central.** É o "Payload" transmitido na requisição web contendo as chaves exportadas. |
| **`headers`** | **Metadados HTTP.** Cabeçalhos emulados, como inserção de Tokens `Authorization` via `CONSTANT` ou dados mutáveis. |
| **`conditions`** | **Barreiras (Se-Entao).** Testa propriedades. Extrai um Tipo Padrão, usa um comparador como `"EQUALS"`, e bate com outro dado refém para ver se libera ou aborta o disparo da integração. |
| **`searchConnector`** | **Filtros.** Interroga APIs internas da plataforma para abastecer a ação. Utiliza Tipos Padrões para passar os parâmetros do filtro. |
| **`grouper`** | Identifica se a execução deverá ser empacotada em uma sub-janela com transações idênticas assinando um mesmo índice. |
| **`reprocess`** e **`authentication`** | Táticas e propriedades encarregadas de autenticações contínuas de segurança na ponta e reenvios para esteiras de falha e dormência. |

### 3. Gaveta de Rastreamento Automático (`advancedSettings`)
Controladores e finalizadores anexados isolados, permitindo definir "Passos engatilhados no sucesso", "Fluxos de tratativas na falha", encadeamentos complexos (`chainedEvent`), adaptadores de retornos da integração ou mecanismos vitais nativos que encurtam URL e as monitoram (`shortenUrl`).

---

## 🎯 Roteiro Prático: O Todo Trabalhando Junto
Abaixo, observe a simplicidade. Uma requisição que aponta a URL e em seguida passa para as Gavetas a missão de delegar valores aos correspondentes via múltiplos **Campos Cadastrados**.

```json
{
  "context": "HISTORY",
  "url": "https://api.gatewaycliente.com/pedidos",
  "action": "INSERT",
  "headers": [
    {
      "originStrategy": "SYSTEM_SETUP",
      "name": "Authorization",
      "value": "ENV_MASTER_TOKEN"
    }
  ],

  "conditions": [
    {
      "operator": "EQUALS",
      "operandLeft": {
        "originStrategy": "HISTORY_FIELD",
        "value": "7810"
      },
      "operandRight": {
        "originStrategy": "CONSTANT",
        "value": "APROVADO"
      }
    }
  ],

  "fieldMappings": [
    {
      "originStrategy": "CONTEXT_FIELD",
      "name": "responsavel_cadastro",
      "value": "CF_vendedor"
    },
    {
      "originStrategy": "HISTORY_FIELD",
      "name": "codigo_nfe",
      "value": "9021"
    }
  ]
}
```
*Na estrutura acima: a regra só é ativada se uma condição avaliar que o campo ID 7810 equivale ao texto APROVADO. E, no momento do disparo, ela usará os `Tipos Padrão` para forjar o cabeçalho secreto da empresa via `headers`, exportando o vendedor no Corpo Central via `fieldMappings`.*
