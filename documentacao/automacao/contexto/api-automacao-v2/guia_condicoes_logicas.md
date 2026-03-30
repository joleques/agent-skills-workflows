# Guia de Barreiras Lógicas (`conditions`)

As automações por sua natureza disparam com facilidade na ocorrência de eventos. A gaveta de `"conditions"` serve como o freio ou **Barreira Lógica** da sua regra.

Se o pacote de testes não for satisfeito com base nas informações que chegaram, a ação em si não corre. Diferentemente de travas de integração, as Conditions matam a regra de nascença, prevenindo custo processual e de tráfego desnecessário.

---

## 🏗️ Estrutura de uma Condição (IF-THEN)
Toda Condição é modelada usando uma balança, onde um lado sempre pesa contra o outro por meio de um operador.

* **`operandLeft`** *(Obrigatório)*: O Ativo que estamos avaliando ("O Peso"). É um Objeto gerado por um *Tipo Padrão*, extraindo de onde quiser a variável da análise.
* **`operator`** *(Obrigatório)*: A regra matemática ou de conteúdo que rege a aprovação ("A Balança").
* **`operandRight`** *(Opcional)*: O Controle ("O Contra-peso"). Com o que queremos comparar. Também é montado via *Tipo Padrão*, permitindo bater campo dinâmico vs campo dinâmico. *Nota: alguns operadores não precisam do lado direito, como verificadores de Null.*

---

## 🧮 Tipos de Operadores de Teste (`operator`)
Abaixo, os códigos originais extraídos do motor que a plataforma reconhece como testes válidos:

- `"EQUALS"`: Verdadeiro apenas se ambos os lados forem matematicamente ou textualmente idênticos.
- `"NOT_EQUALS"`: A regra passa se o da esquerda for diferente do da direita.
- `"CONTAINS"`: Trabalha com Strings. A palavra gerada pela esquerda precisa abrigar como "sub-texto" dentro de si a palavra da direita.
- `"GREATER_THAN"`: Compara números. A esquerda precisa ser financeiramente ou matematicamente maior.
- `"IS_NULL"`: Verifica a ausência do dado. A regra obriga que o lado Esquerdo não exista no evento (*não exige operandRight*).
- `"NOT_NULL"`: A regra exige mandatoriamente que a Esquerda possua valor preenchido e existente. (*não exige operandRight*).

---

## 🎯 Exemplo Prático de Barreiras

Neste cenário a regra possui um ARRAY de 2 condições. Ela só irá rodar se a "Origem de Venda" for exatamente "CANAL_VIP" e, ao mesmo tempo, aquele evento não vier com a propriedade "codigo_suspensao" setada.

As Conditions formam um grupo de testes `AND`. Todas devem dar sinal verde.

```json
"conditions": [
  {
    "operator": "EQUALS",
    "operandLeft": {
      "originStrategy": "HISTORY_FIELD",
      "value": "9005_origem"
    },
    "operandRight": {
      "originStrategy": "CONSTANT",
      "value": "CANAL_VIP"
    }
  },
  {
    "operator": "IS_NULL",
    "operandLeft": {
      "originStrategy": "HISTORY_FIELD",
      "value": "205_suspenso_em"
    }
  }
]
```
