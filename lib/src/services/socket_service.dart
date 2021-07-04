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

  get serverStatus => this._serverStatus;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){

    // Dart client
    IO.Socket socket = IO.io( ipAddress ,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build()
    );

    socket.onConnect((_) {
      // print('Conectado');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    socket.onDisconnect((_) {
      // print('Desconectado');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    socket.on( 'nuevo-mensaje', ( payload ) {

      if ( payload.containsKey('nombre') ){

        print('nuevo-mensaje: Heeey!!! ' + payload['nombre']);

      }


    });

  }
  
}

