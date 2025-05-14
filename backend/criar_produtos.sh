#!/bin/bash

# Caminho completo do arquivo USDZ (ajuste conforme necessário)
ARQUIVO1="/Users/lukasnascimentos/Faculdade/VidaNintendo.usdz"
ARQUIVO2="/Users/lukasnascimentos/Faculdade/VidaNintendo.usdz"

# Verifica se o arquivo existe
if [[ ! -f "$ARQUIVO1" ]]; then
  echo "❌ Arquivo não encontrado: $ARQUIVO1"
  exit 1
fi

# Envia o primeiro produto
echo "⏳ Enviando Hambúrguer..."
curl -X POST http://localhost:8080/products/criarComArquivo \
  -F "file=@$ARQUIVO1" \
  -F "name=Hambúrguer 3D" \
  -F "description=Modelo realista de hambúrguer artesanal" \
  -F "category=Comida" \
  -F "price=29.90" \
  -F "imagePath=/uploads/images/burger.png" \
  -F "size=1"

echo -e "\n✅ Produto 1 enviado!\n"

 if [[ ! -f "$ARQUIVO2" ]]; then
   echo "❌ Arquivo não encontrado: $ARQUIVO2"
   exit 1
 fi

 echo "⏳ Enviando Pizza..."
 curl -X POST http://localhost:8080/products/criarComArquivo \
   -F "file=@$ARQUIVO2" \
   -F "name=Pizza 3D" \
   -F "description=Pizza calabresa com queijo em alta definição" \
   -F "category=Comida" \
   -F "price=35.90" \
   -F "imagePath=/uploads/images/pizza.png" \
   -F "size=1"

 echo -e "\n✅ Produto 2 enviado!\n"
