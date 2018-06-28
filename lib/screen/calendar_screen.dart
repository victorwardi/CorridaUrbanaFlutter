import 'package:corrida_urbana/util/custom_decoration.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import '../model/corrida.dart';
import '../model/mes.dart';
import '../widget/meses_widget.dart';

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

  CorridaDao corridaDao = new CorridaDao();

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
                    ),
                  );
                }).toList();
              }),
        ],
      ),
      body: _buildScreen(context),
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

 

  Widget _createListView(BuildContext context, List<Corrida> todasCorridas) {
 
    return new Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          new CorridasMeses(corridas: todasCorridas, meses : meses),
        ],
      ),
      decoration: UtilDecoration.gradientBackgroundLight ,
    );
  }



  
  

}



