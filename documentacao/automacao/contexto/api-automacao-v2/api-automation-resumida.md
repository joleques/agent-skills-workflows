# 🚀 API das Automações

API destinada à configuração de automações para os ambientes sem necessidade de interação direta do usuário com a base de dados.

## 👁️ Monitoramento

[Logs Kibana](https://umovme-logs-eeeec2.kb.us-east-1.aws.found.io:9243/s/automacao/app/r/s/GhSQK)

## 📚 Recursos disponíveis

- ✅ [Criação de automação](#✨-criacao-de-automacao)
- 🔄 [Atualização do JSON da automação](#🔄-atualizacao-de-json-da-automacao)
- 🔍 [Busca de automação](#🔍-busca-de-automacao)
- 🔄 [Atualização da ação ligada à automação](#🔄-atualizacao-de-acao-ligada-a-automacao)
- 🔄 [Atualização do evento ligado à automação](#🔄-atualizacao-de-evento-ligado-a-automacao)
- ✏️ [Vincular atividade à ação](#✏️-vincular-atividade-na-automacao)
- ✏️ [Desvincular atividade da ação](#✏️-desvincular-atividade-na-automacao)



## 🌐 Endpoint Base

* **Desenvolvimento:**

  ```
  https://dese-automation-api.umov.me/automation/v2
  ```

* **Produção:**

  ```
  https://automation-api.umov.me/automation/v2
  ```


## 🛡️ Header

* `Content-Type`: `application/json`
* `Authorization`: `Bearer <token JWT>`



## ⚙️ Regras de negócio básicas

* 📌 O JSON da automação segue os padrões já existentes e em uso.

* ✅ É possível criar automações para eventos existentes, mas **não** para ações existentes.

* ✅ É possível criar automações para eventos inexistentes — o processo criará o evento automaticamente, se necessário.

* ⚠️ Para os eventos com **moment 213 ou 215**, é **obrigatório** vincular a quais atividades a automação estará ligada.
  👉 Consulte os eventos disponíveis aqui: [eventos disponíveis](./eventos.md)

* 📝 É **obrigatório** informar os campos abaixo ao configurar uma nova automação:

  * `action.name` (nome da ação)
  * `event.moment` (momento do evento: eventoplataforma evp\_codigo)
  * `event.name` (nome do evento)
  * `automation` (JSON da automação)

* ⚙️ Campos opcionais com valores padrão:

  * `action.active`: `true`
  * `action.order`: `1`
  * `action.type`: `CALLBACK`

* ⚠️ **Quando única ação para evento for inativada, seu evento também será inativado.** O mesmo vale para caso seja reativada.


## 📖 Documentação

### ✨ Criação de automação

* **Recurso:** Mesma da URL base.
* **Method:** `POST`

#### 📤 Request

```json
{
  "action": {
    "name": "teste 123",
    "type": "CALLBACK",
    "active": true,
    "order": 1
  },
  "event": {
    "moment": 213,
    "name": "ao executar uma atividade",
    "activityIds": [123]
  },
  "automation": {
    "context": "ANY",
    "entityReference": "callback_new",
    "url": "https://endpoint.com.br",
    "fieldMappings": [
      {
        "originStrategy": "SYSTEM_SETUP",
        "name": "identifier",
        "value": "contextId"
      },
      {
        "originStrategy": "CONSTANT",
        "name": "taskId",
        "value": "Identificador do processo quando sucesso parcial:"
      }
    ]
  }
}
```

#### 📥 Response

✅ Sucesso:

```json
{
	"statusCode": 201,
	"messages": [
		{
			"key": "automation.success.entity_created",
			"message": "Automation created successfully"
		}
	],
	"identifier": 23570
}
```

❌ Erro:

```json
{
	"statusCode": 400,
	"messages": [
		{
			"key": "automation.business.error.event_name_cannot_be_null",
			"message": "error converting event. Reason: name cannot be null"
		}
	]
}
```



### 🔍 Busca de automação

#### Busca por id da ação

* **Recurso:**

  ```text
  {Endpoint Base}/{actionId}
  ```

* **OBS:** *{actionId}* se refere ao código da ação (aca_codigo)

* **Method:** `GET`

##### 📥 Response

✅ Sucesso:

```json
{
	"statusCode": 200,
	"messages": [
		{
			"key": "automation.success.automation_found",
			"message": "Automation has been retrieved successfully"
		}
	],
	"data": [
		{
			"action": {
				"id": 23221,
				"name": "teste 123",
				"type": "CALLBACK",
				"active": true,
				"order": 1
			},
			"event": {
				"id": 934,
				"moment": 213,
				"active": true,
				"name": "Envio de notificação ao finalizar atividade",
				"activityIds": [
					27752706
				]
			},
			"automation": {
				"context": "HISTORY",
				"entityReference": "callback_new",
				"url": "https://webhook.site/c3e24484-10a3-4869-881e-95878eef5db4",
				"fieldMappings": [
					{
						"originStrategy": "SYSTEM_SETUP",
						"name": "identifier",
						"value": "contextId"
					},
					{
						"originStrategy": "CONSTANT",
						"name": "taskId",
						"value": "Identificador"
					}
				],
				"conditions": [],
				"headers": []
			}
		}
	]
}
```

❌ Erro:

```json
{
	"statusCode": 404,
	"messages": [
		{
			"key": "automation.repository.error.automation_not_found",
			"message": "there is no action for given action id 22989000"
		}
	]
}
```

#### Busca por cliente

* **Recurso:**

  ```text
  {Endpoint Base}
  ```

* **OBS:** Usa-se o token do header para filtrar o cliente

* **Method:** `GET`

##### 📥 Response

✅ Sucesso:

```json

{
	"statusCode": 200,
	"messages": [
		{
			"key": "automation.success.automation_found",
			"message": "Automation has been retrieved successfully"
		}
	],
	"data": [
		{
			"action": {
				"id": 23221,
				"name": "teste 123",
				"type": "CALLBACK",
				"active": true,
				"order": 1
			},
			"event": {
				"id": 934,
				"moment": 213,
				"active": true,
				"name": "Envio de notificação ao finalizar atividade",
				"activityIds": [
					27752706
				]
			},
			"automation": {
				"context": "HISTORY",
				"entityReference": "callback_new",
				"url": "https://webhook.site/c3e24484-10a3-4869-881e-95878eef5db4",
				"fieldMappings": [
					{
						"originStrategy": "SYSTEM_SETUP",
						"name": "identifier",
						"value": "contextId"
					}
				]
			}
		},
    {
			"action": {
				"id": 34346,
				"name": "teste 123",
				"type": "CALLBACK",
				"active": true,
				"order": 1
			},
			"event": {
				"id": 934,
				"moment": 220,
				"active": true,
				"name": "Envio de notificação ao editar tarefa",
				"activityIds": []
			},
			"automation": {
				"key": "value"
			}
		}
	]
}
```

❌ Erro:

```json
{
	"statusCode": 404,
	"messages": [
		{
			"key": "automation.repository.error.automation_not_found",
			"message": "there is no action for given client id 272722"
		}
	]
}
```