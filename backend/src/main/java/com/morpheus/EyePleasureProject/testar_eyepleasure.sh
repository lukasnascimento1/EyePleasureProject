#!/bin/bash

echo "📌 Iniciando testes da aplicação EyePleasure..."

# 1. Registro de novo usuário
echo "🧾 Registrando novo usuário..."
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Lukas",
    "cpf": "12345678900",
    "email": "lukas@email.com",
    "psswd": "senha123",
    "nickname": "lukasuser"
  }'
echo -e "\n✅ Registro concluído\n"

# 2. Login do usuário
echo "🔐 Fazendo login..."
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "nickname": "lukasuser",
    "psswd": "senha123"
  }'
echo -e "\n✅ Login efetuado\n"

# 3. Envio de produto (ajuste os caminhos dos arquivos abaixo)
ARQUIVO_MODEL="/Users/lukasnascimentos/Faculdade/VidaNintendo.usdz"
ARQUIVO_IMAGEM="/Users/lukasnascimentos/Faculdade/img.jpg"

if [[ ! -f "$ARQUIVO_MODEL" || ! -f "$ARQUIVO_IMAGEM" ]]; then
  echo "❌ Arquivo de modelo ou imagem não encontrado!"
  exit 1
fi

echo "📤 Enviando produto com modelo e imagem..."
curl -X POST http://localhost:8080/products/criarComArquivo \
  -F "file=@$ARQUIVO_MODEL" \
  -F "image=@$ARQUIVO_IMAGEM" \
  -F "name=Produto Teste" \
  -F "description=Descrição do modelo" \
  -F "category=Comida" \
  -F "price=19.99" \
  -F "size=1" \
  -F "username=lukasuser"
echo -e "\n✅ Produto enviado\n"

# 4. Visualizar produtos do usuário
echo "📄 Listando produtos do usuário..."
curl http://localhost:8080/products/usuario/lukasuser
echo -e "\n✅ Listagem concluída\n"
