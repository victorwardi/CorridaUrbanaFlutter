import 'dart:math';

import 'package:corrida_urbana/util/custom_swiper.dart';
import 'package:flutter/material.dart';

class ConverterPaceScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterPaceScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext scaffoldContext;

  int hours = 0;
  int mins = 0;
  int secs = 0;
  ItemSwiper distance;
  MediaQueryData queryData;

  bool showResult = false;

  bool showCustomDistance = false;

  double customDistance = 0.0;

  static final List<ItemSwiper> distances = [
    ItemSwiper('1k', 1.0),
    ItemSwiper('5k', 5.0),
    ItemSwiper('10k', 10.0),
    ItemSwiper('Meia-maratona', 21.097),
    ItemSwiper('Maratona', 42.195),
    ItemSwiper('Personalizado', 0.0),
  ];

  final List<DropdownMenuItem> distancesDropdown =
      distances.map((ItemSwiper item) {
    return new DropdownMenuItem(
      value: item,
      child: Text(item.label),
    );
  }).toList();

  List<ItemSwiper> _getTimes() {
    List<ItemSwiper> times = [];
    for (var i = 0; i < 60; i++) {
      String n = '$i'.padLeft(2, '0');
      times.add(ItemSwiper('$n', i));
    }
    return times;
  }

  @override
  Widget build(BuildContext context) {
    this.queryData = MediaQuery.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Pace Converter'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Distância:'),
                DropdownButton(
                    value: this.distance,
                    hint: Text('Selecione'),
                    items: this.distancesDropdown,
                    onChanged: (distanceSelect) {
                      setState(() {
                        this.distance = distanceSelect;
                        if (distanceSelect.label == 'Personalizado') {
                          this.showCustomDistance = true;
                        }
                      });
                    }),
              ],
            ),
          ),
          showCustomDistance ? _buildCustomDistance() : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: _buildTimeSwiper(),
          ),
          FlatButton(
              padding: EdgeInsets.all(20.0),
              child: Container(
                  color: Colors.teal,
                  width: double.infinity,
                  child: Transform.rotate(
                    angle: pi / 2,
                    child: Icon(
                      Icons.compare_arrows,
                      size: 50.0,
                    ),
                  )),
              onPressed: () {
                setState(() {
                  showResult = true;
                });
              }),
          showResult ? result() : Container()
        ],
      ),
    );
  }

  ///Convert distance and time to pace per km
  Widget result() {
    if (this.distance == null || this.distance.value == 0.0) {
      _showMessage('Informe uma distância válida!');
      return Container();
      return Text(
        '',
        style: TextStyle(color: Colors.red, fontSize: 20.0),
      );
    }
    if (this.hours == 0.0 && this.mins == 0.0 && this.secs == 0.0) {
      return Text(
        'Informe o tempo!',
        style: TextStyle(color: Colors.red, fontSize: 25.0),
      );
    }

    //convert hours to minutes
    int hoursToMinutes = this.hours * 60;

    //convert seconds to minutes
    double secondsToMinutes = this.secs / 60;

    //Get total of seconds
    double totalMinutes = hoursToMinutes + this.mins + secondsToMinutes;

    //Calculate total of minutes per kilometer
    double minutesPerKm = totalMinutes / this.distance.value;
    //Get only integer part of minutes
    int minutesPerKmIntegers = minutesPerKm.toInt();

    if (minutesPerKmIntegers > 59) {
      return Text(
        'Informe uma distância maior!',
        style: TextStyle(color: Colors.red, fontSize: 25.0),
      );
    }

    //Get the rest part of kilometers
    double minutesPerKmRest = minutesPerKmIntegers > 0
        ? minutesPerKm % minutesPerKmIntegers
        : minutesPerKm;

    //Convert the rest into seconds and round it
    int secondsMinutesPerKm = (minutesPerKmRest * 60).round();

    //Format string o have a zero before an unique number
    String secondsFormatted = '$secondsMinutesPerKm'.padLeft(2, '0');

    TextStyle styleDescription = TextStyle(fontWeight: FontWeight.bold);
    TextStyle styleResult = TextStyle(fontWeight: FontWeight.bold);

    return Card(
      margin: EdgeInsets.all(0.0),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Seu Pace para ${distance.label}: ',
              style: styleDescription,
              textScaleFactor: queryData.textScaleFactor,
            ),
            Text(
              '$minutesPerKmIntegers:$secondsFormatted min/km',
              style: styleResult,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSwiper() {
    double widthSwiper = this.queryData.size.width / 3;
    double fontSize = 20.0;
    List<ItemSwiper> times = _getTimes();
    return Container(
      //padding: EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomSwiper(
            list: times,
            unit: 'h',
            width: widthSwiper,
            fontSize: fontSize,
            onIndexChanged: (index) => this.hours = times[index].value,
          ),
          CustomSwiper(
            list: times,
            unit: 'min',
            width: widthSwiper,
            fontSize: fontSize,
            onIndexChanged: (index) => this.mins = times[index].value,
          ),
          CustomSwiper(
            list: times,
            unit: 's',
            width: widthSwiper,
            fontSize: fontSize,
            onIndexChanged: (index) => this.secs = times[index].value,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDistance() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration:
            InputDecoration(labelText: 'Informe a distância em km (Ex 10.00:)'),
        onChanged: (distanceTyped) {
          this.distance.value = double.tryParse(distanceTyped) ?? 0.0;
        },
      ),
    );
  }

  _showMessage(String msg) {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(msg),
      ),
      backgroundColor: Colors.teal,
      duration: Duration(seconds: 5),
    );

// Find the Scaffold in the Widget tree and use it to show a SnackBar
   scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
