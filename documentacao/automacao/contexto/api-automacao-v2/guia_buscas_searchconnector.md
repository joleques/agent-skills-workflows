# Guia de Interrogadores Externos (`searchConnector`)

O *History Field* acessa os dados da própria Ação que gerou o disparo. O `searchConnector`, entretanto, é o "detetive" da engine.

Por meio dessa gaveta, **antes de a Ação sequer montar o payload final**, a plataforma suspende temporariamente a automação e interroga fontes e APIs globais em busca de anexos. O resultado dessa busca é salvo na memória primária da rule para você poder compor seus headers e mappings usando a OriginStrategy secundária `"SEARCH_CONNECTOR"`.

---

## 🏗️ Estrutura de Busca do Conector
Ao declarar as propriedades dentro da lista de `searchConnector`, você instrui ao motor na fase Zero a ir buscar "tal" pacote e dar a ele "tal" apelido.

* **`identifier`** *(Obrigatório)*: O "Nome do Pen-Drive". Esse é o título da variável mestre onde os resultados da busca externa serão pendurados no motor e que será referenciado depois no seu *originStrategy*.
* **`component`** *(Obrigatório)*: Um *Tipo Padrão* que informa a chave de API ou formulário de pesquisa local onde bater na porta (ex: "API_CONTRATOS").
* **`componentAction`** *(Opcional)*: Um *Tipo Padrão* descrevendo a ação do componente caso a API tenha múltiplos verbos comportamentais de pesquisa.
* **`filters`** *(Opcional)*: A mágia ocorre aqui. Uma **Lista de *Tipos Padrão*** que você exporta dessa Ação como parâmetros de pesquisa para a API, a fim de garantir que a busca não traga a biblioteca inteira, mas registros refinados.

---

## 🎯 Exemplo Prático de Investigação em 1 Passo

Neste cenário a gaveta ordena antes de tudo que o sistema conecte-se à API Legada de Clientes (componente).
Para achar um cliente, passamos nosso ID coletado no campo `142` do histórico como um Filtro formatado para as engrenagens deles. Se char um registro local, o JSON inteiro daquele cliente do banco terceiros fica guardado sobre o apelido `busca_cli`.

```json
  "searchConnector": [
    {
      "identifier": "busca_cli",
      "component": {
        "originStrategy": "CONSTANT",
        "value": "API_CLIENTES_LEGADO"
      },
      "filters": [
        {
          "originStrategy": "HISTORY_FIELD",
          "name": "id_usuario_na_outra_api",
          "value": "142"
        }
      ]
    }
  ],

  "fieldMappings": [
     {
       "originStrategy": "SEARCH_CONNECTOR",
       "name": "empresa_terceira",
       "value": "busca_cli.detalhes.nome_empresa"
     }
  ]
```
