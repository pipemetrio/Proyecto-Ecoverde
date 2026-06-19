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