import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names_sockets/src/services/socket_service.dart';
import 'package:band_names_sockets/src/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {
    
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands );

    super.initState();
  }

  _handleActiveBands( dynamic payload ){
    // Se castea payload a List para que el editor reconozca el método map
      this.bands = ( payload as List )
        .map( ( mapBand ) => Band.fromMap(mapBand) )
        .toList();

        setState((){});
  }

  @override
  void dispose() {

    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.off('active-bands');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final socketService = Provider.of<SocketService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Band names', style: TextStyle( color: Colors.black87 ),),
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,

          actions: [
            Container(
              margin: EdgeInsets.only( right: 10.0 ),
              child: ( socketService.serverStatus == ServerStatus.Online )
                ? Icon( Icons.check_circle, color: Colors.teal[200] )
                : Icon( Icons.offline_bolt, color: Colors.red[200] )
                
            )
          ],
        ),
        body: Column(

          children: [

            (bands.isNotEmpty)
              ? _PieGraph( bands: this.bands, )
              : Text(
                  'No hay bandas',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),


            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),

                itemCount: bands.length,
                itemBuilder: ( context, index ) => _bandTile( bands[index], screenSize )
              ),
            ),
          ],
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
      onDismissed: ( _ ){
        // Borrar banda en el server
        final socketService = Provider.of<SocketService>(context, listen: false);

        socketService.socket.emit('delete-band', { 'id': band.id });
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
    
            onTap: (){

              final socketService = Provider.of<SocketService>(context, listen: false);

              // Votar por una banda
              socketService.socket.emit('vote-band', { 'id': band.id });

            },
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
      final socketService = Provider.of<SocketService>(context, listen: false);

      // Se manda la banda para ser agregada por el server
      socketService.socket.emit('add-band', { 'name': name });
    }

    setState(() {});

    Navigator.pop(context);
  }

}

class _PieGraph extends StatelessWidget {

  final List<Band> bands;

  const _PieGraph({
    Key? key,
    required this.bands
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Map<String, double> dataMap = {};

    bands.forEach((element) {
      dataMap.putIfAbsent( element.name , () => element.votes!.toDouble() );
    });

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20.0),

          child: PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 30,
            chartRadius: MediaQuery.of(context).size.width * 0.35,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: 'Bands',
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              chartValueBackgroundColor: Colors.teal[50],
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 0,
            ),
          ),
        ),
        Divider( color: Colors.teal, thickness: 1.0 )
      ],
    );
  }
}