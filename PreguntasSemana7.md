# ¿Para qué sirve workflow_dispatch?

Sirve para ejecutar un workflow de forma manual sin esperar un push o otros eventos.

# Explicación del motivo de éxito o falla del Workflow de validación

El workflow se ejecuta con éxito ya que este realiza primero una validacion de existencia de un archivo README, entre otros archivos que existen en nuestro proyecto. Esto gracias a "step test -f". 