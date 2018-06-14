import 'package:flutter/material.dart';

import 'dart:async';

import 'package:corrida_urbana/model/corrida.dart';


class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

Future<List<Corrida>> corridas;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.corridas  = new Corrida().loadData();
    });

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Calendário"),
      ),
      body: new Center(child: _buildScreen(context)),
    );
  }


 Widget _buildScreen(BuildContext context) {
    return new Center(
      child: new FutureBuilder(
        future: this.corridas,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return _createListView(context, snapshot.data);
          }
        },
      ),
    );
 }

Widget _createListView(BuildContext context, List<Corrida> corridas) {

    return new ListView.builder(
      padding: new EdgeInsets.all(16.0),
      itemExtent: 80.0,
      itemCount: corridas.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(corridas[index].title),              
            ),
            new Divider(
              height: 2.0,
            ),
          ],
        );
      },
    );
  }

}