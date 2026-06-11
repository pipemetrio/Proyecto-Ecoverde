# Usamos una imagen base ligera de Nginx
FROM nginx:alpine

# Copiamos el contenido de nuestra carpeta app al directorio que Nginx usa para servir archivos
COPY ./app /usr/share/nginx/html

# Exponemos el puerto 80 del contenedor (puerto por defecto de Nginx)
EXPOSE 80

