import 'package:flutter/material.dart';

import 'dart:async';

import '../model/corrida.dart';

import 'package:corrida_urbana/dao/corrida_dao.dart';

import 'corrida_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Future<List<Corrida>> corridas;

  String _estado;

  @override
  void initState() {
    super.initState();
    setState(() {
      this._estado = "RJ";
      this.corridas = new CorridaDao().getCorridasPorEstado(_estado);
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
    return new Container(
      padding: const EdgeInsets.all(8.0),
      child: new ListView.builder(
        padding: new EdgeInsets.all(16.0),
        itemExtent: 80.0,
        itemCount: corridas == null ? 0 : corridas.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(corridas[index].titulo),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new CorridaDetail(corridas[index])));
                },
              ),
              new Divider(
                height: 2.0,
              ),
            ],
          );
        },
      ),
      decoration: new BoxDecoration(
        gradient: new RadialGradient(
          center: Alignment.center, 
          radius: 1.0,
          colors: [
             Colors.blueGrey.withOpacity(0.5),
              Colors.blueGrey.withOpacity(0.0),
          ],
         
        ),
      ),
    );
  }
}
