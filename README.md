# 🛒 Ecommerce-UPSA - Frontend

![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Información del Proyecto

**Proyecto:** Segundo Parcial - Programación Aplicada  
**Estudiante:** Mateo Andrés Soto Gareaca  
**Institución:** Universidad Privada de Santa Cruz de la Sierra (UPSA)  
**Aplicación:** E-Commerce Multi-Rol  

### 🌐 Deploy
La aplicación está desplegada en Netlify y disponible en:  
**[https://heartfelt-banoffee-dd2279.netlify.app/](https://heartfelt-banoffee-dd2279.netlify.app/)**

---

## 📱 Descripción del Proyecto

Ecommerce-UPSA es una aplicación móvil y web desarrollada en Flutter que implementa un sistema completo de comercio electrónico con múltiples roles de usuario. La aplicación permite a los usuarios navegar productos, gestionar carritos de compra, marcar favoritos, y ofrece funcionalidades administrativas para empresas y administradores del sistema.

### 🎯 Características Principales

- **🔐 Sistema de Autenticación**
  - Registro e inicio de sesión seguro
  - Gestión de tokens JWT
  - Almacenamiento seguro de credenciales

- **👥 Sistema Multi-Rol**
  - **Cliente:** Navegación de productos, carrito de compras, favoritos
  - **Empresa:** Gestión de productos propios, estadísticas de ventas
  - **Administrador:** Panel completo de administración y estadísticas globales

- **🛍️ Gestión de Productos**
  - Visualización de catálogo de productos
  - Búsqueda y filtrado
  - Detalles completos de productos
  - CRUD completo para empresas

- **🛒 Carrito de Compras**
  - Agregar/eliminar productos
  - Gestión de cantidades
  - Proceso de checkout
  - Historial de compras

- **⭐ Sistema de Favoritos**
  - Marcar productos como favoritos
  - Ver lista de favoritos
  - Estadísticas de productos más populares

- **📊 Estadísticas y Reportes**
  - Top productos más favoritos
  - Estadísticas por empresa
  - Métricas de rendimiento

---

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas

```
lib/
├── config/
│   ├── api_config.dart          # Configuración de endpoints API
│   └── app_theme.dart            # Tema y estilos de la aplicación
├── models/
│   └── models.dart               # Modelos de datos
├── providers/
│   ├── auth_provider.dart        # Gestión de autenticación
│   ├── cart_provider.dart        # Gestión del carrito
│   ├── favorites_provider.dart   # Gestión de favoritos
│   └── product_provider.dart     # Gestión de productos
├── screens/
│   ├── admin_home_screen.dart    # Pantalla principal admin
│   ├── cart_screen.dart          # Pantalla del carrito
│   ├── client_home_screen.dart   # Pantalla principal cliente
│   ├── company_home_screen.dart  # Pantalla principal empresa
│   ├── company_stats_screen.dart # Estadísticas de empresa
│   ├── favorites_screen.dart     # Pantalla de favoritos
│   ├── home_screen.dart          # Pantalla de inicio
│   ├── login_screen.dart         # Pantalla de login
│   ├── product_form_screen.dart  # Formulario de productos
│   ├── profile_screen.dart       # Perfil de usuario
│   └── top_products_screen.dart  # Productos más populares
├── services/
│   ├── api_service.dart          # Servicio de comunicación con API
│   └── storage_service.dart      # Servicio de almacenamiento local
├── widgets/
│   └── product_card.dart         # Widget de tarjeta de producto
└── main.dart                     # Punto de entrada de la aplicación
```

### 🔧 Patrones de Diseño Utilizados

- **Provider Pattern:** Gestión de estado reactivo
- **Repository Pattern:** Abstracción de acceso a datos
- **Service Layer:** Separación de lógica de negocio
- **Model-View-Provider (MVP):** Arquitectura general de la aplicación

---

## 🚀 Tecnologías Utilizadas

### Framework y Lenguaje
- **Flutter 3.8.1:** Framework de desarrollo multiplataforma
- **Dart 3.0+:** Lenguaje de programación

### Dependencias Principales

```yaml
dependencies:
  flutter: sdk
  http: ^1.2.0                      # Cliente HTTP para API REST
  provider: ^6.1.1                  # Gestión de estado
  shared_preferences: ^2.2.2        # Almacenamiento local
  flutter_secure_storage: ^9.0.0   # Almacenamiento seguro
  intl: ^0.19.0                     # Internacionalización y formateo
```

### Backend
- **API REST:** Azure Web App Service
- **URL Backend:** `https://webappecommerce2.azurewebsites.net`

---

## 📦 Instalación y Configuración

### Prerrequisitos

- Flutter SDK 3.8.1 o superior
- Dart SDK 3.0 o superior
- Editor de código (VS Code, Android Studio, etc.)
- Emulador Android/iOS o dispositivo físico (para desarrollo móvil)

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/Mats2208/SIMULACRO-SEGUNDO_PARCIAL-MEJORADO-FRONTEND.git
   cd ECOMMERCE-FRONTEND
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Verificar la instalación de Flutter**
   ```bash
   flutter doctor
   ```

4. **Ejecutar en modo desarrollo**
   
   Para Web:
   ```bash
   flutter run -d chrome
   ```
   
   Para Android:
   ```bash
   flutter run -d android
   ```
   
   Para iOS:
   ```bash
   flutter run -d ios
   ```

5. **Compilar para producción**
   
   Para Web:
   ```bash
   flutter build web
   ```
   
   Para Android:
   ```bash
   flutter build apk --release
   ```
   
   Para iOS:
   ```bash
   flutter build ios --release
   ```

---

## ⚙️ Configuración del Backend

La configuración del backend se encuentra en `lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'https://webappecommerce2.azurewebsites.net';
  // ...
}
```

Para cambiar el backend, modifica la variable `baseUrl` con la URL de tu servidor.

---

## 🎨 Tema y Diseño

La aplicación utiliza un tema oscuro personalizado definido en `lib/config/app_theme.dart`:

- **Esquema de colores:** Paleta oscura con acentos azules
- **Tipografía:** Fuentes Material Design
- **Componentes:** Material Design 3
- **Responsivo:** Adaptable a diferentes tamaños de pantalla

---

## 👤 Roles de Usuario

### 1. Cliente (Client)
- Navegar catálogo de productos
- Agregar productos al carrito
- Gestionar favoritos
- Realizar compras
- Ver perfil personal

### 2. Empresa (Company)
- Todas las funciones de cliente
- Crear y editar productos propios
- Ver estadísticas de sus productos
- Gestionar inventario

### 3. Administrador (Admin)
- Acceso completo al sistema
- Ver estadísticas globales
- Gestionar todos los productos
- Ver métricas de todas las empresas
- Acceso a reportes avanzados

---

## 🔒 Seguridad

- **Autenticación JWT:** Tokens seguros para autenticación
- **Flutter Secure Storage:** Almacenamiento encriptado de credenciales
- **HTTPS:** Comunicación segura con el backend
- **Validación de datos:** Validación en cliente y servidor

---

## 📱 Funcionalidades Detalladas

### Pantalla de Login
- Autenticación de usuarios
- Registro de nuevos usuarios
- Recuperación de sesión automática

### Pantalla Principal (Home)
- Lista de productos disponibles
- Búsqueda y filtros
- Acceso rápido al carrito
- Navegación por categorías

### Carrito de Compras
- Visualización de productos agregados
- Modificación de cantidades
- Cálculo de totales
- Proceso de checkout

### Favoritos
- Lista de productos favoritos
- Toggle de favoritos
- Sincronización con el servidor

### Panel de Empresa
- Gestión de productos propios
- Formulario de creación/edición
- Estadísticas de productos

### Panel de Administrador
- Vista global del sistema
- Estadísticas completas
- Top productos más populares

---

## 🌐 Deploy en Netlify

El proyecto está configurado para desplegarse automáticamente en Netlify:

1. Build Command: `flutter build web`
2. Publish Directory: `build/web`
3. URL: [https://heartfelt-banoffee-dd2279.netlify.app/](https://heartfelt-banoffee-dd2279.netlify.app/)

---

## 📝 Notas de Desarrollo

### Gestión de Estado
La aplicación utiliza Provider para la gestión de estado, lo que permite:
- Reactividad automática en la UI
- Separación de lógica de negocio
- Fácil testing y mantenimiento

### Comunicación con API
- Todas las llamadas HTTP se centralizan en `api_service.dart`
- Manejo de errores centralizado
- Interceptores para autenticación automática

### Almacenamiento Local
- Tokens en `flutter_secure_storage`
- Preferencias en `shared_preferences`
- Caché de datos para offline

---

## 🐛 Troubleshooting

### Problemas Comunes

**Error de conexión con el backend:**
- Verificar que la URL en `api_config.dart` sea correcta
- Comprobar conexión a internet
- Verificar que el backend esté en línea

**Error al compilar para web:**
- Ejecutar `flutter clean` y `flutter pub get`
- Verificar versión de Flutter

**Problemas con dependencias:**
```bash
flutter pub cache repair
flutter pub get
```

---

## 📄 Licencia

Este proyecto es parte de un trabajo académico para la Universidad Privada de Santa Cruz de la Sierra (UPSA).

---

## 👨‍💻 Autor

**Mateo Andrés Soto Gareaca**  
Programación Aplicada - Segundo Parcial  
Universidad Privada de Santa Cruz de la Sierra (UPSA)  
2025

---

## 📞 Contacto

Para más información sobre el proyecto, consultas o sugerencias:
- **Repositorio:** [GitHub](https://github.com/Mats2208/SIMULACRO-SEGUNDO_PARCIAL-MEJORADO-FRONTEND)
- **Demo en vivo:** [Netlify](https://heartfelt-banoffee-dd2279.netlify.app/)