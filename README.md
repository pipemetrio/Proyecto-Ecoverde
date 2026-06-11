# Proyecto EcoVerde Antioquia S.A.S.

Proyecto desarrollado para la evidencia de producto del componente DevOps y Contenedores.

## Descripción

Página web institucional desplegada mediante Docker.

## Tecnologías

- HTML
- Git
- Docker
- Docker Compose

## Guía de Despliegue Técnico y Ejecución

Para levantar este entorno de forma automatizada y reproducible, ejecute los siguientes comandos en la terminal dentro de la raíz del proyecto:

1. **Construir las imágenes y levantar el entorno en segundo plano:**
   ```bash
   docker compose up -d
   ```
2. **Verificar el estado de los servicios:**
    ```bash
    docker ps
    ```
3. **Verificar la persistencia (Volúmenes) y el aislamiento (Redes):**
    ```bash
    docker volume ls
    ```
    ```bash
    docker network ls
    ```

Nota: Una vez activo, la solución web institucional estará disponible localmente en el navegador a través de la dirección http://localhost:8080