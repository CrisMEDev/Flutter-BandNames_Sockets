# Aplicación de bandas utilizando sockets para comunicación en tiempo real

### Notas

En el el directorio lib/src/helpers no olvidar crear el archivo keys.dart y agregar:
    *La dirección a la que se realiza la conexión por sockets

Ej:
```
String ipAddress = 'http://<MyIpAddress>:MyServerPort/';    // En el caso de localhost
String ipAddress = 'MyAwesomeServerAddress';                // En el caso de server en la nube
```

### Documentación

[socket_io client](https://pub.dev/packages/socket_io_client)
[provider](https://pub.dev/packages/provider)
