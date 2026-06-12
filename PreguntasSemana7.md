# ¿Para qué sirve workflow_dispatch?

Sirve para ejecutar un workflow de forma manual sin esperar un push o otros eventos.

# Explicación del motivo de éxito o falla del Workflow de validación

El workflow se ejecuta con éxito ya que este realiza primero una validacion de existencia de un archivo README, entre otros archivos que existen en nuestro proyecto. Esto gracias a "step test -f". 

# ¿Qué es un Workflow?

Es un conjunto de tareas que se automatizan para ejecutar una secuencia de pasos, nos permite que procesos, validaciones y pruebas entre otras se ejecuten facilmente. 

# Diferencia entre Job y Step

Job es un grupo de tareas con una relación del mismo entorno, el step es una accion o instrucción que va dentro del job, como un comando o acción.

# ¿Para que sirve un runner?

Sirve para realizar tareas definidas en los jobs, como descargar codigos o ejecutar comandos. Tambien sirve para construir imagenes de Docker o generar artefactos.

# Ventaja del artifact 

Una ventaja de los artifacts es que permiten guardar y compartir archivos generados durante la ejecución de un workflow. Esto facilita almacenar evidencias, reportes, resultados de pruebas o archivos compilados para descargarlos posteriormente sin necesidad de volver a ejecutar el proceso.

# ¿Cómo GitHub Actions ayuda a disminuir errores manuales?

GitHub Actions reduce los errores manuales porque automatiza tareas repetitivas y las ejecuta siempre de la misma manera. Nos ayuda a evitar fallar en cosas.