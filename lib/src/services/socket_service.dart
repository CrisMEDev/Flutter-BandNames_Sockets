import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:band_names_sockets/src/helpers/keys.dart';

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

// TODO: Eliminar de los archivos manifest el permiso de conexión http al llevar la app a producción

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;   // Ahora se pueden crear llamadas al on emit y off desde cualquier instancia de la clase

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){

    // Dart client
    this._socket = IO.io( ipAddress ,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build()
    );

    this._socket.onConnect((_) {
      // print('Conectado');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      // print('Desconectado');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // Escuchar mensaje del server
    // this._socket.on( 'nuevo-mensaje', ( payload ) {

    //   if ( payload.containsKey('nombre') ){

    //     print('nuevo-mensaje: Heeey!!! ' + payload['nombre']);

    //   }
    // });

    //

  }
  
}

