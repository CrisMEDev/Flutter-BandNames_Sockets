import 'package:flutter/material.dart';

import 'package:band_names_sockets/src/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 4),
    Band(id: '2', name: 'Héroes del silencio', votes: 3),
    Band(id: '3', name: 'Los rumberos'),
    Band(id: '4', name: 'The score', votes: 7),
  ];

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Band names', style: TextStyle( color: Colors.black87 ),),
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),

          itemCount: bands.length,
          itemBuilder: ( context, index ) => _bandTile( bands[index], screenSize )
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon( Icons.add ),
          elevation: 0,
          backgroundColor: Colors.teal,
          onPressed: (){}
        ),
      ),
    );
  }

  Column _bandTile( Band band, Size screenSize ) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            child: Text( band.name[0], style: TextStyle( color: Colors.white ), ),
            backgroundColor: Colors.teal,
          ),

          title: Text( band.name, style: TextStyle( fontSize: screenSize.width * 0.05 ) ),

          trailing: Text( '${ band.votes }', style: TextStyle( fontSize: screenSize.width * 0.05 ) ),

          onTap: (){},
        ),
        Divider()
      ],
    );
  }
}