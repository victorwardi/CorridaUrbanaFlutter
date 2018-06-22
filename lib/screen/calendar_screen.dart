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

  String _estado = "RJ";

  String _title = "Calendário - RJ";

  List<String> _estados = ['RJ', 'SP', 'DF', 'MG'];
 
  TextStyle _menuItemStyle =
      TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    setState(() {
      this.corridas = new CorridaDao().getCorridasPorEstado(_estado);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
        actions: <Widget>[
          // overflow menu
          new PopupMenuButton<String>(onSelected: (String estadoSelected) {
            setState(() {
              print(estadoSelected);
              this.corridas =
                  new CorridaDao().getCorridasPorEstado(estadoSelected);
              _title = 'Calendário  - $estadoSelected';
            });
          }, itemBuilder: (BuildContext context) {
            return _estados.map((String uf) {
              return new PopupMenuItem<String>(
                value: uf,
                child: new Text(
                  uf,
                  style: _menuItemStyle,
                ),
              );
            }).toList();
          })
        ],
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

  Widget _corrida(Corrida corrida) {
    return Container(
      child: Center(
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5.0),
              height: 50.0,
              width: 50.0,
              child: Column(
                children: <Widget>[
                  Text(
                    corrida.dia,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    corrida.mesExtenso.substring(0, 3).toUpperCase(),
                    style: TextStyle(
                        color: Colors.teal[900],
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  corrida.titulo,
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createListView(BuildContext context, List<Corrida> corridas) {
    return new Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: new ListView.builder(
        itemExtent: 80.0,
        itemCount: corridas == null ? 0 : corridas.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                title: _corrida(corridas[index]),
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
