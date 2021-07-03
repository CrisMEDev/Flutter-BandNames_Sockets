import 'dart:io';

import 'package:flutter/cupertino.dart';
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
          onPressed: addNewBand
        ),
      ),
    );
  }

  Widget _bandTile( Band band, Size screenSize ) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container( color: Colors.teal ),
      onDismissed: ( direction ){
        // TODO: Borrar en el server
        print(direction);
      },

      child: Column(
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
      ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if ( Platform.isAndroid ){

      showDialog(
        context: context,
        builder: ( context ){
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text('Add'),
                textColor: Colors.teal,
                onPressed: () => addBandToList( textController.text )
              )
            ],
          );
        }
      );

    }

    // Alert dialog con el estilo propio para ios
    if ( Platform.isIOS ){
      showCupertinoDialog(
        context: context,
        builder: ( context ) {
          return CupertinoAlertDialog(
            title: Text('New band name:'),
            content: CupertinoTextField(
              controller: textController,
            ),

            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addBandToList( textController.text )
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: () => Navigator.pop(context)
              )
            ],
          );
        }
      );
    }


  }

  void addBandToList( String name ){
    if ( name.length > 1 ){
      // Se agrega a la lista
      this.bands.add(new Band(id: DateTime.now().toString(), name: name));
    }

    setState(() {});

    Navigator.pop(context);
  }

}