# 📱 Flutter App - Vehicle Manager

Esta aplicación móvil fue desarrollada con **Flutter** y permite gestionar vehículos agrupados por marca. Se conecta a un backend desarrollado en Node.js y desplegado en Railway.

---

## 🧰 Requisitos

- Flutter 3.10 o superior
- Dispositivo o emulador Android/iOS
- Conexión a internet (para acceder al backend en producción)
- Firebase (para autenticación por correo electrónico)

---

## 🚀 Instalación

1. Clona el repositorio:

```bash
git clone https://github.com/tu-usuario/vehicle_manager.git
cd vehicle_manager
```

2. Instala las dependencias:

```bash
flutter pub get
```

3. Asegúrate de tener Firebase configurado. Revisa el archivo `firebase_options.dart` y vincúlalo con tu proyecto en [Firebase Console](https://console.firebase.google.com).

4. Ejecuta la app:

```bash
flutter run
```

---

## 🔧 Configuración del entorno

### 📡 Backend URL
En `lib/services/api_service.dart` actualiza la base URL:

```dart
static const String baseUrl = 'https://autoapp-backend-production.up.railway.app/api';
```

### 🔐 Firebase

- Autenticación por correo habilitada.
- Usuarios registrados se sincronizan con la app.
- Recuerda que la autenticación mediante enlaces dinámicos dejará de funcionar el **25 de agosto de 2025**, según notificación de Firebase.

---

## 🛠️ Estructura de carpetas

```
lib/
├── models/             # Modelo Vehicle
├── services/           # Conexiones HTTP con el backend
├── providers/          # Provider para la gestión de estado (VehicleProvider)
├── screens/            # Pantallas de la app
├── widgets/            # Componentes reutilizables
```

---

## 🧪 Pruebas

Actualmente, se realizan pruebas manuales. Para producción, se recomienda usar `flutter_test` o `integration_test`.

---

## 📦 Producción

Esta app consume un backend desplegado en Railway y una base de datos MySQL, también en Railway.

---

## 👤 Autor

Moises Santos  
Contacto: moi@gmail.com
