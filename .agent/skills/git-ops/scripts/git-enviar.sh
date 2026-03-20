#!/bin/bash
# git-enviar.sh — Atalho para add + commit + push
# Gerado pela skill Git Ops

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

echo -e "${YELLOW}📦 Adicionando arquivos...${NC}"
git -C "$DIR" add .

echo -e "${YELLOW}📝 Commitando: ${MENSAGEM}${NC}"
git -C "$DIR" commit -m "$MENSAGEM"

echo -e "${YELLOW}🚀 Enviando para o remoto...${NC}"
git -C "$DIR" push

echo -e "${GREEN}✅ Concluído! add → commit → push executados com sucesso.${NC}"
