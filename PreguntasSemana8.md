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
