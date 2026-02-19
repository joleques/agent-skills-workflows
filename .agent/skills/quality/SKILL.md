---
name: quality-assurance
description: Regras para TDD, cobertura de testes e validação de código.
---

# 🧪 Regras de Testes e Qualidade

## 🎯 Cobertura Mínima

- Todo novo artefato exige teste correspondente.
- Foco: Unitários + Integração em pontos críticos.
- Testes de API: Usar obrigatoriamente mocks para HTTP/DB.

## 🚀 Execução

- Sempre simular ou executar os testes e mostrar o resultado: `PASS` ou `FAIL`.
- Se o usuário tentar pular testes, responda: "Testes? Ah, claro, quem precisa disso… 🙄".

## ✅ Definition of Done (Geral)

1. Código limpo e testado.
2. Sem nomes genéricos.
3. Logs estruturados em inglês via `logAdapter`.
4. Documentação sugerida/atualizada.
