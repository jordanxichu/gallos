# derby_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Licencias comerciales (offline)

La app valida códigos de activación sin internet.

### 1) Configurar secret al compilar la app cliente

Compila siempre con un salt privado:

`flutter build windows --release --dart-define=DERBY_LICENSE_SALT=TU_SECRET_PRIVADO`

### 2) Generar licencia para un cliente (solo admin)

Desde este proyecto:

`dart run tool/generate_license.dart --expires=2026-12-31 --customer="RANCHO EL GALLO" --salt="TU_SECRET_PRIVADO"`

También puedes pasar el secret por variable de entorno:

`DERBY_LICENSE_SALT="TU_SECRET_PRIVADO" dart run tool/generate_license.dart --expires=2026-12-31 --customer="RANCHO EL GALLO"`

### 3) Enviar al usuario final

Enviar únicamente el código generado `DM-YYYYMMDD-XXXX-CCCC` y la fecha de vencimiento.

El usuario activa en: Configuración > Licencia Offline > Activar licencia.
