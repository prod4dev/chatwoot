#!/bin/bash
set -e

# Configuración
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="340752842719"  # Tu account ID actual
ECR_REPOSITORY_NAME="chatwoot-p4d-fork"
IMAGE_TAG="${IMAGE_TAG:-latest}"

echo "🚀 Deploy de Chatwoot Fork a ECS"
echo "=================================="

# 1. Crear repositorio ECR si no existe
echo ""
echo "📦 Paso 1/5: Verificando/Creando repositorio ECR..."
if ! aws ecr describe-repositories --region $AWS_REGION --repository-names $ECR_REPOSITORY_NAME &>/dev/null; then
    echo "Creando repositorio ECR: $ECR_REPOSITORY_NAME"
    aws ecr create-repository \
        --repository-name $ECR_REPOSITORY_NAME \
        --region $AWS_REGION \
        --image-scanning-configuration scanOnPush=true \
        --encryption-configuration encryptionType=AES256
    echo "✅ Repositorio creado"
else
    echo "✅ Repositorio ya existe"
fi

# 2. Login a ECR
echo ""
echo "🔐 Paso 2/5: Autenticando con ECR..."
aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
echo "✅ Autenticado con ECR"

# 3. Build de la imagen
echo ""
echo "🏗️  Paso 3/5: Buildeando imagen Docker..."
echo "Este proceso puede tomar 10-15 minutos..."
cd "$(git rev-parse --show-toplevel)"

docker build \
    -f docker/Dockerfile \
    -t $ECR_REPOSITORY_NAME:$IMAGE_TAG \
    -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:$IMAGE_TAG \
    -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:$(git rev-parse --short HEAD) \
    --platform linux/amd64 \
    .

echo "✅ Imagen buildeada exitosamente"

# 4. Push a ECR
echo ""
echo "📤 Paso 4/5: Pusheando imagen a ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:$IMAGE_TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:$(git rev-parse --short HEAD)
echo "✅ Imagen pusheada a ECR"

# 5. Mostrar información para actualizar Terraform
echo ""
echo "✅ Paso 5/5: Información para Terraform"
echo "=================================="
echo ""
echo "Ahora actualiza tu archivo terraform.tfvars con:"
echo ""
echo "chatwoot_image = \"$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:$IMAGE_TAG\""
echo ""
echo "Luego ejecuta:"
echo "  cd /Users/marianomachao/p4d/infra/chatwoot"
echo "  terraform plan   # Verifica los cambios"
echo "  terraform apply  # Aplica el deploy"
echo ""
echo "🎉 Script completado. La imagen está lista para deployar."
