# Prueba de Endpoints de Favoritos

## Endpoints a verificar:

### 1. Top Productos Favoritos (Ranking Global)
- **Endpoint**: `GET /api/favorites/stats/top?take=10&onlyActive=true`
- **Descripción**: Devuelve los productos más favoritos de TODOS los clientes (ranking global)
- **Respuesta esperada**: Array de objetos con productId, productName, favoriteCount

### 2. Estadísticas de mi empresa
- **Endpoint**: `GET /api/favorites/stats/mine`
- **Descripción**: Devuelve estadísticas de favoritos para los productos de la empresa autenticada
- **Respuesta esperada**: Objeto con companyUserId, companyName, totalFavorites, products[]

### 3. Estadísticas de empresa específica
- **Endpoint**: `GET /api/favorites/stats/company/{companyUserId}`
- **Descripción**: Devuelve estadísticas de favoritos para una empresa específica
- **Respuesta esperada**: Objeto con companyUserId, companyName, totalFavorites, products[]

## Problemas comunes:

1. **Autenticación**: Asegúrate de que el token JWT se está enviando correctamente
2. **Formato de respuesta**: El backend puede estar devolviendo un formato diferente al esperado
3. **Permisos**: Algunos endpoints pueden requerir roles específicos
4. **Datos vacíos**: Si no hay favoritos, el backend puede devolver arrays vacíos

## Acciones tomadas:

1. ✅ Actualizado `api_config.dart` con constantes para endpoints de stats
2. ✅ Actualizado `api_service.dart` para usar las constantes correctas
3. ✅ Mejorado manejo de errores en `api_service.dart`
4. ✅ Agregado logging en `favorites_provider.dart`
