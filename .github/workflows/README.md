# GitHub Actions Deployment Setup

## Configuración de Secrets

Para que el workflow funcione, necesitás configurar estos secrets en GitHub:

### Ir a: `Settings > Secrets and variables > Actions > New repository secret`

Agregá estos secrets:

1. **AWS_ACCESS_KEY_ID**
   - Access key del usuario de AWS con permisos para:
     - ECR (push images)
     - ECS (update service, describe services)

2. **AWS_SECRET_ACCESS_KEY**
   - Secret key del usuario de AWS

## Cómo usar el workflow

1. Andá a la pestaña **Actions** en GitHub
2. Seleccioná **Deploy to ECS** en la sidebar izquierda
3. Click en **Run workflow** (botón arriba a la derecha)
4. Seleccioná el branch (ej: `p4d-platabus-soporte-2026`)
5. Elegí el environment: `production`
6. Click **Run workflow**

El workflow va a:
- ✅ Build de la imagen Docker para linux/amd64
- ✅ Push a ECR con tag `latest`
- ✅ Force new deployment en ECS (rolling update)
- ✅ Esperar a que el deployment se estabilice
- ✅ Mostrar el estado final del deployment

## Monitoreo

### Durante el deployment:
- **GitHub Actions**: Ver logs en tiempo real del workflow
- **AWS ECS Console**: ECS > Clusters > chatwoot-production-cluster > chatwoot-production-web
  - Ver tasks arrancando/terminando
  - Ver eventos del servicio

### Después del deployment:
- **CloudWatch Logs**: `/ecs/chatwoot-production/web`
  - Ver logs de la aplicación
  - Buscar errores de startup
- **Verificar la app**: Abrir la URL y chequear que:
  - El título tenga " - P4D Fork"
  - Los elementos ocultos no se muestren
  - Todo funcione correctamente

## Troubleshooting

Si el deployment falla:

1. **Check GitHub Actions logs** - Ver exactamente en qué step falló
2. **Check ECS Events** - AWS Console > Service > Events tab
3. **Check CloudWatch Logs** - Buscar stack traces o errores de inicio
4. **Rollback automático** - ECS rollback si las nuevas tasks no pasan health checks

## Tiempo estimado

- Build + Push: ~5-7 minutos
- ECS Rolling Deployment: ~2-3 minutos
- **Total: ~10 minutos**
