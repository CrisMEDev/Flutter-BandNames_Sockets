import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names_sockets/src/services/socket_service.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Server status: ${ socketService.serverStatus }')
            ],
          ),
       ),
       ),
    );
  }
}