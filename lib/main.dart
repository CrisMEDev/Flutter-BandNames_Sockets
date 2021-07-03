import 'package:flutter/material.dart';

import 'package:band_names_sockets/src/pages/home.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Band names',
      
  initialRoute: 'home',

  routes: {
    'home':       ( _ ) => HomePage()
  },

    );
  }
}