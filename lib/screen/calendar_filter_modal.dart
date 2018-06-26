import 'package:flutter/material.dart';

import 'package:corrida_urbana/model/mes.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Locale brasil = const Locale('pt', 'BR');

class CalendarFilter extends StatelessWidget {

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




  @override
  Widget build(BuildContext context) {
      return  new FloatingActionButton(
          tooltip: 'Filtrar', // used by assistive technologies
          child: new Icon(FontAwesomeIcons.calendar),
          onPressed: () {
              showDatePicker(
                
                initialDatePickerMode: DatePickerMode.day,
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime.now().subtract(new Duration(days: 30)),
              lastDate: new DateTime.now().add(new Duration(days: 365)),
             // locale: brasil,

            );
           
          }
      );
  }
 

}