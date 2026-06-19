# Explicación técnica del endurecimiento aplicado.

Se usa un usuario no root, base slim, .dockerignore, chown en build, healthcheck, restart policy y uso de Docker secrets, estas prácticas de endurecimiento básicas reducen la superficie y aumentan resiliencia. Como se menciona en el mismo archivo es mas segura porque: 

•	No ejecuta la aplicación como root.  
•	Usa una base slim en lugar de una imagen más pesada.  
•	Incluye .dockerignore para no subir archivos innecesarios al build context.  
•	Declara un healthcheck para validar el estado del servicio.  
•	Usa restart policy para recuperar el servicio después de una caída del proceso.  

# Explicación del uso de read_only, tmpfs y healthcheck.

Read_only como su nombre lo dice hace que el archivo solo sea de lectura, es decir, impide que procesos dentro del contenedor modifiquen archivos del sistema.  
Tmpfs crea archivos temporales que puedes ser escribibles incluso cuando se usa el read_only por lo que usualmente suelen ser complementarios.  
Healthcheck nos permite saber que un contenedor esta funcionando, esto se identifica con 'UP' en docker aunque pueda tener fallos, Healthcheck hace que este ejecute evaluaciones constantes que docker identificará como 'Unhealthy' si falla varias veces.

# ¿Qué riesgos encuentras en usar latest sin control?

El no especificar una version puede implicar un error en la app por incompatibilidades, crear vulnerabilidades, bugs, etc.

# ¿Por qué privileged: true aumenta el riesgo?

Porque a acceso a dispositivos del sistema y aumenta la posibilidad de modificar configuraciones del kernel. Si un atacante compromete la aplicación, puede comprometer también el servidor anfitrión.

# ¿Por qué no conviene dejar DB_PASSWORD dentro del archivo?

Porque puede filtrarse, ya que esta queda expuesta en texto plano, dando acceso a la base de datos sin problemas.

# ¿Qué implicaciones tiene montar /var/run/docker.sock en un contenedor?

El hacerlo permite crear nuevos contenedores con privilegios elevados, leer archivos del host, modificar o eliminar otros contenedores, etc.

## Riesgos identificados y correcciones propuestas

| Riesgo encontrado | Corrección propuesta |
|------------------|---------------------|
| Uso de `python:latest`, lo que puede introducir cambios inesperados o incompatibilidades. | Fijar una versión específica, por ejemplo: `python:3.12.4-slim`. |
| `privileged: true` otorga privilegios elevados equivalentes a los del host. | Eliminar `privileged: true` y aplicar el principio de mínimo privilegio. |
| Contraseña de base de datos almacenada en texto plano (`DB_PASSWORD: 123456`). | Utilizar variables de entorno (`${DB_PASSWORD}`) o Docker Secrets. |
| Montaje de `/var/run/docker.sock`, que permite controlar Docker desde el contenedor. | Eliminar el montaje si no es estrictamente necesario. |
| Ejecución implícita como usuario root dentro del contenedor. | Definir un usuario no privilegiado con `user: "1000:1000"`. |
| Volumen montado con permisos de escritura (`./:/app`). | Montar en modo solo lectura: `./:/app:ro` cuando sea posible. |
| Sistema de archivos del contenedor modificable. | Habilitar `read_only: true`. |
| Posibilidad de escribir archivos temporales en cualquier ubicación. | Utilizar `tmpfs` para directorios temporales como `/tmp`. |
| Capacidades Linux innecesarias disponibles para el contenedor. | Eliminar capacidades con `cap_drop: - ALL` y agregar solo las estrictamente necesarias. |
| Posibilidad de escalación de privilegios desde procesos internos. | Configurar `security_opt: - no-new-privileges:true`. |
| Ausencia de verificación del estado de la aplicación. | Agregar un `healthcheck` para supervisar la disponibilidad del servicio. |
| Falta de política de reinicio ante fallos. | Configurar `restart: unless-stopped` o una política adecuada al entorno. |

## Checklist Operativo de Seguridad para Docker en Producción

Evaluación realizada sobre el archivo `compose.prod.yml` desarrollado en la práctica.

| # | Control | ¿Cumple? | Evidencia / Observación |
|---|----------|----------|-------------------------|
| 1 | Base image pequeña y confiable | ✅ Sí | El Dockerfile utiliza `python:3.12-slim`. |
| 2 | No ejecutar la aplicación como root | ✅ Sí | Se crea el usuario `appuser` y se define `USER appuser`. |
| 3 | Uso de `.dockerignore` y manejo adecuado de secretos | ✅ Sí | Existe archivo `.dockerignore` y se utilizan Docker Secrets mediante `/run/secrets/banner_msg`. |
| 4 | Configurar `healthcheck` y `restart policy` | ✅ Sí | Se implementa `healthcheck` y `restart: unless-stopped`. |
| 5 | Utilizar volúmenes únicamente para datos persistentes | ✅ Sí | Se utiliza el volumen `app-data` para almacenar el contador de visitas. |
| 6 | Aplicar `read_only` o montajes de solo lectura cuando sea posible | ✅ Sí | El servicio se ejecuta con `read_only: true`. |
| 7 | No montar `docker.sock` sin una necesidad justificada | ✅ Sí | No existe montaje de `/var/run/docker.sock`. |
| 8 | Evitar `privileged: true` y privilegios innecesarios | ✅ Sí | El servicio no utiliza `privileged: true`. |
| 9 | Mantener imágenes actualizadas y controlar versiones | ✅ Sí | Se utiliza una versión específica (`python:3.12-slim`), pero no se evidencia un proceso de revisión de vulnerabilidades. |
| 10 | Contar con logs, métricas y procedimientos de recuperación | ✅ Sí | Se verifican logs y estadísticas con Docker, pero no se documenta un procedimiento formal de rollback. |

### Controles técnicos definidos por el equipo

1. Ejecutar los contenedores con usuarios no privilegiados (`USER appuser`) para reducir riesgos de seguridad.
2. Utilizar Docker Secrets y filesystem de solo lectura (`read_only`) para proteger información sensible y limitar modificaciones no autorizadas.

### Controles de operación definidos por el equipo

1. Revisar periódicamente las imágenes utilizadas y aplicar actualizaciones de seguridad cuando sea necesario.
2. Mantener procedimientos documentados de monitoreo, respaldo y recuperación del servicio ante fallos.

### ¿Qué diferencia principal existe entre “correr un contenedor” y “operarlo en producción”?

Correr un contenedor es ejecutar una aplicación dentro de Docker y verificar que funciona. Operarlo en producción implica garantizar su disponibilidad, seguridad, persistencia de datos, monitoreo y capacidad de recuperación ante fallos. 

### ¿Qué medida de seguridad te parece más valiosa para este nivel de formación y por qué?

La ejecución de la aplicación como usuario no root me parece la medida más valiosa, porque reduce vulnerabilidades. Además, es una práctica sencilla de implementar.

### ¿Qué error te parecería más grave publicar en un Dockerfile productivo?

Uno de los errores más graves sería incluir secretos o contraseñas directamente en la imagen o en el código fuente. Esto puede exponer información sensible y comprometer la seguridad de la aplicación.

### ¿Qué harías primero si tuvieras que mejorar un contenedor ya existente?

Primero revisaría la seguridad básica del contenedor: verificar si utiliza una imagen confiable, si ejecuta procesos como usuario no root, si maneja adecuadamente secretos y volúmenes. A partir de eso aplicaría las mejoras necesarias para reducir riesgos y aumentar la estabilidad del servicio.