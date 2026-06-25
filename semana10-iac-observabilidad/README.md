# Interpretación Actividad 4

Despues de descargar la imagen con normalidad realizamos el seguimiento de los logueos dentro de la pagina, esto usando logs -f, en el podemos notar que se realiza una solicitud GET, que revise una respuesta en codigo siguiendo un http clasico. 

Docker stats, nos permitio saber el rendimiento y consumo de la misma al momento de ser utilizada, dado a ser probada en un solo computador el consumo fue bastante bajo. 

# Interpretación del requisito de Metrics Server.

Debido a que realizamos Docker para usarlo de entorno en las actividades anteriores pudimos visualizar correctamente el historial de logs, además como se menciono en el mismo texto, hubo un error al consultar las metricas ya que falta el componente Metrics Server ya que este no se incluye en el Docker Desktop (el que usamos en nuestro computador), este recolecta las métricas de consumo de CPU y Memoria RAM. 