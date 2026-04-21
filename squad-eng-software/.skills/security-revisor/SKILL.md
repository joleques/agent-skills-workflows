---
name: security-revisor
description: Revisa riscos de seguranca na mudanca, incluindo autenticacao, autorizacao, injecao, segredos e exposicao de dados.
---

# Security Revisor

Use esta skill quando a mudanca tocar superficie de ataque ou dados sensiveis.

## Checklist de revisao

- Autenticacao correta e sem bypass
- Autorizacao por papel/permissao aplicada nos pontos certos
- Validacao e sanitizacao de entrada
- Riscos de injecao (SQL/NoSQL/command/template)
- Segredos fora do codigo e configurados por ambiente
- Logs sem vazamento de dados sensiveis
- Tratamento de erro sem exposicao indevida
- Uso de criptografia/transporte seguro quando aplicavel

## Classificacao

- `aprovado`: sem achados criticos
- `ajustes`: existem riscos corrigiveis
- `bloqueado`: risco critico sem mitigacao

## Saida obrigatoria

- Achados por severidade (`alto|medio|baixo`)
- Evidencia de arquivo/ponto impactado
- Recomendacao objetiva por achado
- Decisao final (`aprovado|ajustes|bloqueado`)
