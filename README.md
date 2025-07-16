# Rick & Morty API - Flutter

Aplicación Flutter para mostrar información de personajes de Rick and Morty con funcionalidades de búsqueda, filtros, favoritos y estadísticas visualizadas con gráficos.

---

## Getting Started

Este proyecto es un punto de partida para una aplicación Flutter que consume una API y muestra datos de personajes con varias pantallas y funcionalidades.

### Requisitos

- Flutter SDK instalado (se recomienda la versión estable más reciente).
- Un editor de código como VS Code 
- Android Studio como emulador
- (opcional) Emulador o dispositivo físico configurado para pruebas.

### Cómo ejecutar la aplicación

1. Clona o descarga este repositorio en tu máquina local.
2. Abre una terminal en la carpeta raíz del proyecto.
3. Ejecuta `flutter pub get` para instalar las dependencias.
4. Conecta un dispositivo o inicia un emulador.
5. Ejecuta `flutter run` para compilar y lanzar la app.

---

## Proceso de Desarrollo y Decisiones Técnicas

- **Gestión de Estado:** Se utilizó `provider` para manejar el estado centralizado de la aplicación, facilitando el acceso y actualización de la lista de personajes, filtros y favoritos desde distintas pantallas.

- **Diseño UI:** Se optó por un diseño oscuro con acentos verdes para mejorar la experiencia visual y enfocar la atención en el contenido principal. Se emplearon `ListView` para listar personajes y `fl_chart` para las visualizaciones estadísticas.

- **Navegación:** Se implementó navegación entre pantallas usando `Navigator.push` con rutas explícitas para mantener simplicidad y claridad en el flujo.

- **Filtrado y Búsqueda:** Se integraron filtros dinámicos y búsqueda en tiempo real para mejorar la usabilidad y rapidez al encontrar personajes.

- **Gráficos:** Para la pantalla de estadísticas, se usó la librería `fl_chart` para mostrar un gráfico de pastel y barras, brindando una vista rápida del estado y participación de los personajes en episodios.

- **Optimización:** Se agregaron widgets `Consumer` para optimizar la reconstrucción solo de partes necesarias cuando el estado cambia.

---

### Recursos útiles

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [fl_chart Package](https://pub.dev/packages/fl_chart)
