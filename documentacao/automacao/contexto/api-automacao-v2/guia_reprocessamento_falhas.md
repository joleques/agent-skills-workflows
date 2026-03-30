# Guia de Resiliência (`reprocess`)

Na vida real das integrações web, ocorrem incidentes de rede, `timeouts` de resposta ou indisponibilidade momentânea nos servidores dos seus parceiros de negócio.

Se a automação falhar em enviar a requisição e a gaveta `reprocess` estiver omissa, o evento falha definitivamente. Configurar o Reprocessamento instrui a Engine a acolher pacotes rejeitados com base num termômetro de retentativas (sleep-and-try-again).

---

## 🏗️ Estrutura de Retentativa Temporal
Quando um pacote de automação cai porque a API engasgou, a Engine da Plataforma lê a propriedade `reprocess` à procura do manual de socorros.

A gaveta é um JSON Array simplificado contendo duas chaves formatadas via *Tipo Padrão*.

* **`service`** *(Opcional/Contextual)*: O nome do integrador local em que o pacote deve persistir. Construído geralmente como `"originStrategy": "CONSTANT"`, ele dita a qual fila/pipeline de contingência esse payload será fixado na base de dados temporária.
* **`strategy`** *(Obrigatório)*: A cereja do bolo que acalma os servidores. Em vez de simplesmente reenviar sem parar usando Força Bruta, nós usamos uma "Estratégia Térmica". Através de um identificador local constante passado neste Tipo Padrão, a plataforma engatilha dormências crescentes baseados em algoritmos nativos ("Tenta de novo em 5 min. Deu erro? Dorme 30 min. Deu erro? Dorme 12h e tenta só amanhã").

---

## 🎯 Exemplo Prático de Vigia Térmico

Neste cenário a gaveta indica à automação que, se o Disparo de um Webhook explodir por um timeout na ponta do Cliente final, a transação não deve ser descartada como Concluída C/ Falha.
Ela aterroriza a requisição numa fila morta sob serviço primário e manda a Engine aplicar o limitador `SLEEP_BACKOFF_STANDARD` da empresa.

```json
  "reprocess": [
    {
      "service": {
        "originStrategy": "CONSTANT",
        "name": "service_name",
        "value": "AMAZON_SQS_DEAD_LETTER"
      },
      "strategy": {
        "originStrategy": "CONSTANT",
        "name": "cool_down",
        "value": "SLEEP_BACKOFF_STANDARD"
      }
    }
  ]
```
