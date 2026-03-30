# Opções Avançadas de Roteamento (`advancedSettings`)

As configurações de Automação vão além do simples "monte o pacote e dispare para a URL". A gaveta nomeada de `advancedSettings` abriga os "super-poderes" da execução.

Ela é focada não no *que* enviar, mas **em como a engine reage e manipula os resultados e os fluxos sistêmicos** em torno daquele disparo. Abaixo estão detalhadas todas as chaves desta configuração, divididas pela natureza de seu comportamento.

---

## 🛠️ Modificadores de Identidade e Formato

Estes parâmetros afetam a transformação do pacote antes que ele de fato saia da plataforma.

### `alternativeIdentifier` (Assinatura Alternativa)
Por padrão, a plataforma sabe identificar um evento/registro. Porém, às vezes o cliente externo usa outro código. Esse parâmetro permite sobrescrever a assinatura primária da execução, baseada num identificador complexo montado.
* **Tipo:** Objeto de **Tipo Padrão**.
* **Como usar:** Configure-o com uma `originStrategy` que busque o ID externo do cliente pra assinar o evento.

### `adapterType` (Adaptadores Nativos)
Em vez de enviar um JSON puro genérico, você obriga que a carga de dados montada passe primariamente por um script/serviço formatador estático e super especializado em determinado fornecedor externo antes do disparo.
* **Tipo:** Texto Fixo.
* **Como usar:** Enviar a string que representa a constante do integrador no código (ex: `"PAGSEGURO_ADAPTER"`).

---

## 🔗 Rastreadores e Encurtadores de Links

Um ecossistema criado para focar em envio de SMS e comunicações em que caracteres importam, convertendo dinamicamente links imensos em rotas curtas e comissionadas via analytics.

* **`shortenUrl` (Booleano):** A chave liga/desliga primária (`true` ou `false`). Se ativada, o motor caça URLs grandes nas propriedades finais do pacote e as reduz.
* **`shortnerType` (Texto):** Informa qual serviço integrado deverá prover a redução. (ex: `"NATIVE_SERVICE"` usa o redutor interno da plataforma).
* **`shortnerEntity` (Texto):** Cadastra metadados na URL. Muito útil para campanhas de Marketing, indicando a qual projeto/campanha esse disparo de link encurtado pertence (ex: `"promo-diadasmaes"`), gerando dashboards com agrupamento.

---

## 🚦 Roteadores Pós-Disparo (O que fazer com o retorno?)

Uma vez que a Ação "bater" no servidor externo, a plataforma precisa de instruções sobre os próximos passos.

### `translation` (Tradutor de Status)
As APIs terceiras respondem no dialeto delas. Esse atributo força o sistema a traduzir um retorno adverso num conceito amigável para a sua plataforma antes de gravá-lo no Banco. Se a API externa diz `"X200"`, você pode dizer pro motor salvar isso como `"Sucesso Financeiro"`.
* **Tipo:** Lista de Tradutores. Mapeia o `"before"` (antes) para o `"after"` (depois).

### Tratamento Fixo vs Fluído (Eventos Encadeados)

Quando este evento acabar, quem será chamado em seguida? A Ação possui duas táticas excludentes para decidir isso: a versão Legada/Fixa e a Dinâmica.

#### 1. A Abordagem Legada (Fixa)
A resposta é engessada direto na regra da Ação.
* **`nextActionWhenSuccess`** (Lista de Textos): O ID exato da regra no banco que será executada se a requisição retornar SUCESSO.
* **`nextActionWhenError`** (Lista de Textos): O ID exato da regra no banco que servirá como tratamento de ERRO da requisição.

#### 2. A Abordagem Dinâmica (`chainedEvent`)
Substitui a versão Fixa. Em vez de ler ids chumbados, você delega novamente para o **Tipo Padrão** descobrir daonde tirar os IDs dos próximos passos (talvez até lendo de dentro do objeto do pacote web que retornou).
* **`success`**: Um Objeto Tipo Padrão ensinando como achar a próxima Ação se for vitorioso.
* **`error`**: Um Objeto Tipo Padrão ensinando como achar a próxima Ação se for um fracasso.

---

## 🎯 Exemplo Prático da Gaveta `advancedSettings`

Neste cenário a gaveta ativa um Encurtador de Link vinculado a uma campanha de Black Friday, e ativa um Fluxo Encadeado que delega a decisão do sucesso para varrer a propriedade `"fluxo_de_sucesso"` registrada internamente no banco do cliente.

```json
  "advancedSettings": {

    "shortenUrl": true,
    "shortnerType": "NATIVE_SERVICE",
    "shortnerEntity": "black.friday.2026",

    "alternativeIdentifier": {
      "originStrategy": "HISTORY_FIELD",
      "value": "887012"
    },

    "chainedEvent": {
      "success": {
        "originStrategy": "SYSTEM_SETUP",
        "name": "action",
        "value": "SP_FLUXO_DE_SUCESSO"
      },
      "error": {
        "originStrategy": "CONSTANT",
        "name": "action",
        "value": "ACAO_FALHA_12"
      }
    }

  }
```
