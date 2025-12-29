# GitHub Actions Deployment Setup

## Configuración de Secrets

Para que el workflow funcione, necesitás configurar estos secrets en GitHub:

### Ir a: `Settings > Secrets and variables > Actions > New repository secret`

Agregá estos secrets:

1. **AWS_ACCESS_KEY_ID**
   - Access key del usuario terraform-user de AWS

2. **AWS_SECRET_ACCESS_KEY**
   - Secret key del usuario terraform-user de AWS

3. **INFRA_REPO_TOKEN**
   - Personal Access Token (PAT) de GitHub con acceso al repo `prod4dev/infra`
   - Para crear: GitHub > Settings > Developer settings > Personal access tokens > Tokens (classic)
   - Permisos necesarios: `repo` (Full control of private repositories)

4. **POSTGRES_PASSWORD** (opcional)
   - Password de la base de datos PostgreSQL
   - Solo si terraform lo requiere

5. **REDIS_PASSWORD** (opcional)
   - Password de Redis
   - Solo si terraform lo requiere

## Estructura de repositorios

El workflow hace checkout de **dos repositorios**:

1. **marianomachao/chatwoot** - Código de la aplicación (checkout automático)
2. **prod4dev/infra** - Configuración de Terraform (checkout con token)

## Cómo usar el workflow

1. Andá a la pestaña **Actions** en GitHub
2. Seleccioná **Deploy to ECS** en la sidebar
3. Click en **Run workflow**
4. Seleccioná el branch (ej: `p4d-platabus-soporte-2026`)
5. Click **Run workflow**

El workflow va a:
- ✅ Buildear la imagen Docker para linux/amd64
- ✅ Pushear a ECR
- ✅ Correr terraform apply
- ✅ Mostrar el estado del deployment

## Monitoreo

Después del deploy, podés ver el estado en:
- GitHub Actions: Ver logs del workflow
- AWS Console: ECS > Clusters > chatwoot-production-cluster
- CloudWatch Logs: `/ecs/chatwoot-production/web`
