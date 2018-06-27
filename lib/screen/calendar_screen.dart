import 'package:flutter/material.dart';

import 'dart:async';

import '../model/corrida.dart';
import '../model/mes.dart';

import 'package:corrida_urbana/dao/corrida_dao.dart';

import 'corrida_screen.dart';
import 'calendar_filter_modal.dart';

import 'package:flutter/cupertino.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Future<List<Corrida>> corridas;

  String _estado = "RJ";

  String _title = "Calendário - RJ";

  List<String> _estados = ['RJ', 'SP', 'DF', 'MG'];

  List<Mes> meses = <Mes>[
    Mes('01', 'JAN', 'Janeiro'),
    Mes('02', 'FEV', 'Fevereiro'),
    Mes('03', 'MAR', 'Março'),
    Mes('04', 'ABR', 'Abril'),
    Mes('05', 'MAI', 'Maio'),
    Mes('06', 'JUN', 'Junho'),
    Mes('07', 'JUL', 'Julho'),
    Mes('08', 'AGO', 'Agosto'),
    Mes('09', 'SET', 'Setembro'),
    Mes('10', 'OUT', 'Outubro'),
    Mes('11', 'NOV', 'Novembro'),
    Mes('12', 'DEZ', 'Dezembro')
  ];

  TextStyle _menuItemStyle =
      TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold);

  Mes mesSelecionado;

  CorridaDao corridaDao = new CorridaDao();

  @override
  void initState() {
    super.initState();
    setState(() {
      //this.mesSelecionado = new Mes('01', 'JAN');
      this.corridas = corridaDao.getCorridasPorEstado(_estado);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: CalendarFilter(),
      appBar: new AppBar(
        title: new Text(_title),
        actions: <Widget>[
          new PopupMenuButton<String>(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('Trocar UF'),
              ),
              onSelected: (String estadoSelected) {
                setState(() {
                  print(estadoSelected);
                  this.corridas =
                      new CorridaDao().getCorridasPorEstado(estadoSelected);
                  _title = 'Calendário  - $estadoSelected';
                });
              },
              itemBuilder: (BuildContext context) {
                return _estados.map((String uf) {
                  return new PopupMenuItem<String>(
                    value: uf,
                    child: new Text(
                      uf,
                      style: _menuItemStyle,
                    ),
                  );
                }).toList();
              }),
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createListView(BuildContext context, List<Corrida> todasCorridas) {
    return new Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          new Meses(meses: meses,),
        ],
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

  Widget _getCorridasMes(List<Corrida> todasCorridas, String mes) {

    //List<Corrida> corridas = todasCorridas.where((c) => corridaDao.filtrarPorMes(c, '08')).toList();
    List<Corrida> corridas = todasCorridas;

    return new Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          ListView.builder(
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
          )
        ],
      ),
    );
  }


  Widget _testList(){

return
     ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Header $index',
                  style: Theme.of(context).textTheme.body2,
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Nested list item $index'),
                    );
                  },
                  itemCount: 6, // this is a hardcoded value
                ),
              ],
            ),
          );
        },
        itemCount: 4, // this is a hardcoded value
      );
  }

  Widget _showMesesSelection(BuildContext context) {
    return Container(
      height: 150.0,
      foregroundDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Colors.white.withOpacity(1.0),
            Colors.white.withOpacity(1.0),
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(1.0),
            Colors.white.withOpacity(1.0),
          ],
          //tileMode: TileMode.repeated
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: new EdgeInsets.all(16.0),
        itemExtent: 80.0,
        itemCount: meses.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                  title: new Text(
                    meses[index].nome,
                    style: _menuItemStyle,
                  ),
                  onTap: () {}),
            ],
          );
        },
      ),
    );
  }

  Widget _showUFSelection(BuildContext context) {
    return Container(
      height: 150.0,
      foregroundDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Colors.white.withOpacity(1.0),
            Colors.white.withOpacity(1.0),
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(1.0),
            Colors.white.withOpacity(1.0),
          ],
          //tileMode: TileMode.repeated
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: new EdgeInsets.all(16.0),
        itemExtent: 80.0,
        itemCount: _estados.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                  title: new Text(
                    _estados[index],
                    style: _menuItemStyle,
                  ),
                  onTap: () {}),
            ],
          );
        },
      ),
    );
  }
}

class Meses extends StatelessWidget {
  const Meses({
    Key key,
    @required this.meses,
  }) : super(key: key);

  final List<Mes> meses;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new ListView.builder(
          itemExtent: 80.0,
          itemCount: meses == null ? 0 : meses.length,
          itemBuilder: (BuildContext context, int index) {
            return new Text('dois');
          },
        ),
      ],
    );
  }
}
