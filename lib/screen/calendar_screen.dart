import 'package:flutter/material.dart';

import 'dart:async';

import '../model/corrida.dart';

import 'package:corrida_urbana/dao/corrida_dao.dart';

import 'corrida_screen.dart';

import 'package:carousel/carousel.dart';

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
    Mes('01', 'JAN'),
    Mes('02', 'FEV'),
    Mes('03', 'MAR'),
    Mes('04', 'ABR'),
    Mes('05', 'MAI'),
    Mes('06', 'JUN'),
    Mes('07', 'JUL'),
    Mes('08', 'AGO'),
    Mes('09', 'SET'),
    Mes('10', 'OUT'),
    Mes('11', 'NOV'),
    Mes('12', 'DEZ')
  ];

  TextStyle _menuItemStyle =
      TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold);

  Mes mesSelecionado;

  @override
  void initState() {
    super.initState();
    setState(() {
      //this.mesSelecionado = new Mes('01', 'JAN');
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
          }),
          // overflow menu
          new PopupMenuButton<String>(onSelected: (String estadoSelected) {
            setState(() {
              print(estadoSelected);
              this.corridas =
                  new CorridaDao().getCorridasPorEstado(estadoSelected);
              _title = 'Calendário  - $estadoSelected';
            });
          }, itemBuilder: (BuildContext context) {
            return meses.map((Mes mes) {
              return new PopupMenuItem<String>(
                value: mes.numero,
                child: new Text(
                  mes.nome,
                  style: _menuItemStyle,
                ),
              );
            }).toList();
          }),

          new IconButton(
            icon: Icon(Icons.filter),
            onPressed: () {



              showDialog(
      context: context,
      builder: (BuildContext context) => _filtros(context));
              
              
            },
          )
        ],
      ),
      body: new Center(child: test(context)),
    );
  }

  Widget _filtros(BuildContext context) {




    
    final SimpleDialog dialog = new SimpleDialog(
      title: const Text('Select assignment'),
      children: <Widget>[  

           

        







        new SimpleDialogOption(
          onPressed: () { Navigator.pop(context); },
          child: test(context),
        ),
        new SimpleDialogOption(
          onPressed: () {},
          child: const Text('Text two'),
        ),
      ],
    );
    return dialog;
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

  Widget test(BuildContext context){
print(meses.length);

return

new DropdownButton<Mes>(
            hint: new Text("Selecione um mes"),
            value: mesSelecionado,
            onChanged: (Mes novoMes) {
              setState(() {
                mesSelecionado = novoMes;
              });
            },
            items: meses.map((Mes mes) {
              return new DropdownMenuItem<Mes>(
                value: mes,
                child: new Text(
                  mes.nome,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),


       
);

  }

  Widget getRow(int position) {
    return new FlatButton(
      child: new ListTile(
        title: new Text(meses[position].nome),
        trailing: new Text(meses[position].numero.toString()),
      ),
      onPressed: () {
        setState(() {
          meses.removeAt(position);
        });
      },
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

class Mes {
  String numero;
  String nome;

  Mes(this.numero, this.nome);
}
