# Cat Academy: Reply & Discover
**Por Arturo Gaddiel Jerez Hernandez y Ximena Hernandez Santiago 6-A Programacion Matutino**

**Cat Academy** es una aplicación móvil interactiva desarrollada en Flutter que transforma el aprendizaje en una experiencia divertida y dinámica. Diseñada especialmente para estudiantes, la app ofrece un entorno amigable con temática felina donde los usuarios pueden poner a prueba sus conocimientos mediante trivias y crear sus propios cuestionarios.

## Características Principales

*  **Biblioteca Integrada:** Incluye cuestionarios precargados con temas educativos (Cultura General, Historia, Ciencia, Mundo de los Gatos, etc.).
*  **Creación de Cuestionarios:** Formulario intuitivo para que los usuarios agreguen sus propias preguntas y respuestas personalizadas.
*  **Accesibilidad (Text-to-Speech):** Integración de motor de voz para leer las preguntas en voz alta, facilitando el aprendizaje auditivo.
*  **Sistema de Pistas:** Botón de ayuda interactivo (50/50) que oculta respuestas incorrectas durante el juego.
*  **Sistema de Resultados:** Tarjeta final estilo "medalla" que muestra el puntaje obtenido, respuestas correctas y erradas.
*  **Interfaz Animada:** Navegación suave con transiciones de desvanecimiento y botones interactivos con efecto de rebote.

##  Tecnologías Utilizadas

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Gestión de Estado:** `provider`
* **Navegación:** `go_router`
* **Base de Datos Local:** `hive` y `hive_flutter`
* **Texto a Voz:** `flutter_tts`

## Requisitos Previos

Para ejecutar este proyecto de forma local, necesitas tener instalado:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versión 3.0 o superior)
* Android Studio o Visual Studio Code
* Un emulador de Android/iOS o un dispositivo físico conectado.

##  Instrucciones de Instalación

Sigue estos pasos para correr el proyecto en tu máquina local:

1. **Clona este repositorio:**
   ```bash
   git clone [https://github.com/Jerez-Hernandez-Arturo-Gaddiel/Cat-Academy-Reply-Discover.git]
Navega al directorio del proyecto:

Bash
cd cat_academy
Instala las dependencias de Flutter:

Bash
flutter pub get
Ejecuta la aplicación:

Bash
flutter run Remove-Item -Path .git -Recurse -Force -ErrorAction SilentlyContinueInstrucciones de Uso
Inicio de Sesión: Al abrir la aplicación, ingresa a la sección de registro/login para acceder al menú principal.

Jugar Trivia: Toca en "Comenzar Quiz" o elige un tema desde la "Biblioteca". Lee o escucha la pregunta, usa la pista si la necesitas, y selecciona la respuesta correcta.

Revisar Resultados: Al finalizar, obtendrás tu "Puntaje Michi". Desde ahí puedes volver al inicio o a la biblioteca.

Agregar Preguntas: En la biblioteca, busca la opción para crear un cuestionario, llena los campos con tu pregunta, las 4 opciones de respuesta, marca la correcta y presiona "Guardar".

Desarrollado como Proyecto Final para el Módulo V: Implementa aplicaciones móviles multiplataforma.

***
