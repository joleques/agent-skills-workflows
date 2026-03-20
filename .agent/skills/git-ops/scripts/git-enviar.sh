#!/bin/bash
# git-enviar.sh — Atalho para commit + push (add já feito pelo agente)
# Gerado pela skill Git Ops
#
# O git add . é feito ANTES deste script pelo agente,
# pois ele precisa do diff --staged para gerar o resumo.

set -e

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Validação de parâmetros
if [ -z "$1" ]; then
  echo -e "${RED}❌ Erro: mensagem do commit é obrigatória.${NC}"
  echo "Uso: bash git-enviar.sh \"mensagem\" [diretório]"
  exit 1
fi

MENSAGEM="$1"
DIR="${2:-.}"

# Validar que é um repositório Git
if ! git -C "$DIR" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo -e "${RED}❌ Erro: '${DIR}' não é um repositório Git.${NC}"
  exit 1
fi

# Verificar se há algo para commitar
if git -C "$DIR" diff --staged --quiet 2>/dev/null; then
  echo -e "${YELLOW}⚠️ Nenhuma alteração staged para commit.${NC}"
  echo -e "${YELLOW}   Executando git add . ...${NC}"
  git -C "$DIR" add .

  # Verificar novamente
  if git -C "$DIR" diff --staged --quiet 2>/dev/null; then
    echo -e "${RED}❌ Nenhuma alteração encontrada para enviar.${NC}"
    exit 1
  fi
fi

echo -e "${YELLOW}📝 Commitando: ${MENSAGEM}${NC}"
git -C "$DIR" commit -m "$MENSAGEM"

echo -e "${YELLOW}🚀 Enviando para o remoto...${NC}"
git -C "$DIR" push

echo -e "${GREEN}✅ Concluído! commit → push executados com sucesso.${NC}"
