# Documentação do Objeto: Tipo Padrão

O `Tipo Padrão` é o objeto mais versátil e importante dentro da estrutura de configuração de parâmetros de ações do motor de execução.

Ele atua como o "tijolo de construção" principal, sendo a forma padronizada que a plataforma usa para mapear conexões e decidir de onde a informação vem (`originStrategy`).

## 📋 Propriedades do Tipo Padrão

Abaixo estão todos os campos que compõem este objeto:

| Nome do campo | Chave JSON | Tipo de Dado | Obrigatório | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **Modo de Origem** | `originStrategy` | Texto | **Sim** | Instrui a plataforma qual motor de captura deve usar para extrair este valor específico (Ver Tabela de Origens). |
| **Chave Final** | `name` | Texto | **Sim** | É o título com que a propriedade será exportada (ex: `"id_pedido"` ou `"Content-Type"`). |
| **Conteúdo** | `value` | Texto | Não | Reforça a origem: pode ser um texto fixo ou o caminho com ponto a ser extraído do json do contexto (ex: `"123"` ou `"history.task.id"`). |
| **Sub-Valores** | `values` | Lista (`Tipo Padrão`) | Não | Responsável por criar aninhamentos estruturais. Serve para os itens de uma lista (se atrelado a `OBJECT_LIST_FROM_FIELDS`), construir propriedades filhas de um Objeto aninhado, montar agrupadores lógicos (como os gatilhos `success` e `error` em Fluxos Encadeados) ou segregar parâmetros do tipo OAuth na autenticação (`header`, `body` e `cache`). |
| **Posicionamento** | `index` | Numérico | Não | Se construindo valores lado a lado (Matriz), informa em qual ordem a propriedade é posicionada na linha. |
| **Origem Externa de Lista**| `valueSource` | Objeto | Não | Exclusivo pro formato `"OBJECT_LIST_FROM_FIELDS"`. Indica à plataforma qual lista Array do json base ele tem que iterar iterar para construir esta sublista. |

---
## Onde ele é utilizado?

Devido à sua flexibilidade, o `Tipo Padrão` não é exclusivo do payload final e aparece construindo várias áreas da configuração:

- **Payload (`fieldMappings`):** Define como o corpo/payload que a ação enviará para o cliente deve ser preenchido.
- **Cabeçalhos (`headers`):** Mapeia cabeçalhos HTTP necessários (ex: injetar um token fixo).
- **Condições (`conditions`):** Serve como as variáveis "Esquerda" e "Direita" num teste lógico (se o campo X for igual a Y).
- **Agrupadores (`grouper.identifier`):** Monta a chave única que vai agrupar os eventos parecidos em uma janela.
- **Conectores de Busca (`searchConnector`):** Preenche as variáveis que serão enviadas como filtro num serviço externo (`filters`).
- **Autenticação (`authentication` e `advancedSettings`):** Constrói credenciais, identidades alternativas e engatilha sucessores em casos de fluxos encadeados.

---
## 🚀 Os Tipos de Origem (`originStrategy`)

O comportamento central do `Tipo Padrão` muda drasticamente de acordo com tipo definido no `originStrategy`. Os tipos mapeados na plataforma e aceitos são:

| Tipo (`originStrategy`) | Como Funciona e Quando Usar? |
| :--- | :--- |
| `"CONSTANT"` | **Valor Fixo.** A plataforma não tentará ler dados dinâmicos do evento para esta propriedade. Ela simplesmente exportará exatamente o texto/número que o operador escrever no campo `"value"`. Muito usado em `"headers"` e chaves fixas analíticas. |
| `"HISTORY_FIELD"` | **Do Histórico do uMov.me.** Busca a informação de forma dinâmica consultando os dados coletados no histórico da tarefa. Diferente de uma navegação por JSON, a chave `"value"` deve conter obrigatoriamente o **ID numérico do campo da atividade** (`sectionFieldId`) cadastrado na plataforma. A *engine* utilizará esse ID para disparar uma consulta local GraphQL e resgatar o valor preenchido (ex: se colocar `"value": "13552"`, ele acha o campo de texto/número amarrado àquele ID). |
| `"CONTEXT_FIELD"` | **Do Ambiente Base.** Captura informações diretamente do contexto (objeto Java) que engloba a Ação no momento. Navega pelas propriedades do contexto via "pontos" usando *Reflection* na chave `"value"`. Permite também o resgate de campos customizados do contexto caso o `value` seja prefixado com `"CF_"` (ex: `"CF_idGeral"` resgata da lista interna de CustomFields o que possuir este identifier). |
| `"SEARCH_CONNECTOR"` | **Resultado de Integração.** Utilizado nos casos onde você possui listado no topo um pré-conector ("SearchConnector"). Este originStrategy fala pra esse campo não olhar no histórico do evento, mas sim olhar internamente no pacote retornado da API externa usando a chave indicada no Identifier. |
| `"OBJECT_LIST_FROM_FIELDS"` | **Construção de Sublistas.** É um originador "Pai" usado quando seu Mapping não é só um dado final, mas um Array de outros dados (Lista de `values` com sub Mappings dentro). Costuma caminhar de mãos dadas com a chave `"valueSource"`. |
| `"SYSTEM_SETUP"` | **Variável de Infraestrutura.** Extrai propriedades estáticas do motor. A chave `"value"` deve trazer um prefixo mandatório: usar `"ENV_nomeDaVariavel"` busca de Variáveis de Ambiente hospedadas no servidor e `"SP_nomeDoParametro"` busca de Parâmetros de Sistema (SystemParameter) registrados no banco de dados para aquele cliente. Pode-se também usar o valor exato `"contextId"` para exportar o id de contexto. |

---

## 📝 Exemplos Práticos de `Tipo Padrão`

**Exemplo 1: Usando `originStrategy` de Valor Constante (Fixo)**
Muito útil em mapeamentos de Integração para injetar um CNPJ ou token constante.

```json
{
  "originStrategy": "CONSTANT",
  "name": "Authorization",
  "value": "Bearer ASJD&123NS"
}
```

**Exemplo 2: Usando `originStrategy` baseado no Histórico**
Ele consulta dinamicamente na base local via GraphQL o valor preenchido para o campo de ID `45910` durante a coleta do evento, e o insere no payload final exportado sob a chave `"status_fiscal"`.

```json
{
  "originStrategy": "HISTORY_FIELD",
  "name": "status_fiscal",
  "value": "45910"
}
```

**Exemplo 3: Estrutura Complexa de Sublista (`valueSource` + `values`)**
Demostra a versatilidade. Ele usa a Origin de "Listas", apontando para interagir sobre o array `"pagamentos"` de evento. E a cada elemento que a engine iterar, ela cria dinamicamente o `"tipo_da_moeda"`.

```json
{
  "originStrategy": "OBJECT_LIST_FROM_FIELDS",
  "name": "carteiras",
  "valueSource": {
    "originStrategy": "HISTORY_FIELD",
    "value": "2031"
  },
  "values": [
    {
      "originStrategy": "HISTORY_FIELD",
      "name": "tipo_da_moeda",
      "value": "9012"
    }
  ]
}
```

**Exemplo 4: Usando `originStrategy` de Contexto (Reflection e Custom Fields)**
Extrai diretamente de propriedades do contexto da execução. No caso abaixo busca um campo customizado interno chamado `"vendedor"`.

```json
{
  "originStrategy": "CONTEXT_FIELD",
  "name": "responsavel_venda",
  "value": "CF_vendedor"
}
```

**Exemplo 5: Usando `originStrategy` de Parâmetros de Motor**
Injeta na chave `"api_key_estatica"` da exportação final exatamente o valor configurado na Variável de Ambiente hospedada no servidor da aplicação correspondente sob o nome `CHAVE_INTEGRACAO`.

```json
{
  "originStrategy": "SYSTEM_SETUP",
  "name": "api_key_estatica",
  "value": "ENV_CHAVE_INTEGRACAO"
}
```
