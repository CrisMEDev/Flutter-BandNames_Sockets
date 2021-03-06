import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names_sockets/src/pages/home.dart';
import 'package:band_names_sockets/src/pages/status.dart';

import 'package:band_names_sockets/src/services/socket_service.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: ( BuildContext context ) => new SocketService() )
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Band names',
        
      initialRoute: 'home',
    
      routes: {
      'home':       ( _ ) => HomePage(),
      'status':     ( _ ) => StatusPage()
      },
    
      ),
    );
  }
}