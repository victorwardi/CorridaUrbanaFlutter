import 'package:flutter/material.dart';

import 'package:corrida_urbana/model/mes.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalendarFilter extends StatelessWidget {

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




  @override
  Widget build(BuildContext context) {
      return  new FloatingActionButton(
          tooltip: 'Filtrar', // used by assistive technologies
          child: new Icon(FontAwesomeIcons.filter),
          onPressed: () {
              showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return _createMaterialAlertDialog(context);
              });
           
          }
      );
  


  }

Widget _showMeses(BuildContext context) {
  
  }


    Widget _createMaterialAlertDialog(BuildContext context) {
    return new AlertDialog(
    title: new Text('Reset counter'),
    content: new Text('Do you want to reset counter?'),
    actions: <Widget>[
      new MaterialButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: new Text('Cancel'),
      ),
      new MaterialButton(
          onPressed: () {
          },
          child: new Text('OK')),
    ],
  );

}

}