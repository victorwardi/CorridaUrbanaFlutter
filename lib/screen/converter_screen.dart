import 'package:corrida_urbana/util/custom_swiper.dart';
import 'package:flutter/material.dart';

class ConverterPaceScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterPaceScreen> {
  int hours = 0;
  int mins = 0;
  int secs = 0;
  ItemSwiper distance = ItemSwiper('1k', 1.0);

  bool showResult = false;

  final List<ItemSwiper> distances = [
    ItemSwiper('1k', 1.0),
    ItemSwiper('5k', 5.0),
    ItemSwiper('10k', 10.0),
    ItemSwiper('Meia-maratona', 21.097),
    ItemSwiper('Maratona', 42.195),
  ];

  List<ItemSwiper> _getTimes() {
    List<ItemSwiper> times = [];
    for (var i = 0; i < 60; i++) {
      String n = '$i'.padLeft(2, '0');
      times.add(ItemSwiper('$n', i));
    }
    return times;
  }
  List<DropdownMenuItem> _getTimesDropDown() {
    List<DropdownMenuItem> times = [];
    for (var i = 0; i < 60; i++) {
      String n = '$i'.padLeft(2, '0');
      times.add(DropdownMenuItem(value: i, child: Text(n),));
    }
    return times;
  }

  @override
  Widget build(BuildContext context) {
    List<ItemSwiper> times = _getTimes();

    return Scaffold(
      appBar: AppBar(
        title: Text('Infinity Loop Items'),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton(items:_getTimesDropDown() ,),
          CustomSwiper(
            list: distances,
            width: 560.0,
            label: 'Distâncias:',
            scrollDirection: Axis.horizontal,
            onIndexChanged: (index) => this.distance = distances[index],
          ),
          Container(
           padding: EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomSwiper(
                  list: times,
                  unit: 'Hours',
                  width: 100.0,
                  fontSize: 30.0,
                  onIndexChanged: (index) => this.hours = times[index].value,
                ),
                CustomSwiper(
                  list: times,
                  unit: 'Mins',
                  width: 100.0,
                  fontSize: 30.0,
                  onIndexChanged: (index) => this.mins = times[index].value,
                ),
                CustomSwiper(
                  list: times,
                  unit: 'Secs',
                  width: 100.0,
                  fontSize: 30.0,
                  onIndexChanged: (index) => this.secs = times[index].value,
                ),
              ],
            ),
          ),
          FlatButton(
              padding: EdgeInsets.all(20.0),
              child: Container(
                  color: Colors.teal,
                  width: double.infinity,
                  child: Icon(
                    Icons.compare_arrows,
                    size: 60.0,
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

  void getTime() {
    print('$hours:$mins:$secs');
  }

  ///Convert distance and time to pace per km
  Widget result() {
    if (this.hours == 0.0 && this.mins == 0.0 && this.secs == 0.0) {
      return Text(
        'Informe o tempo!',
        style: TextStyle(color: Colors.red, fontSize: 25.0),
      );
    }

    //convert hours to minutes
    int hoursToMinutes = this.hours * 60 * 60;

    //convert seconds to minutes
    double secondsToMinutes = this.secs / 60;

    //Get total of seconds
    double totalMinutes = hoursToMinutes + this.mins + secondsToMinutes;

    //Calculate total of minutes per kilometer
    double minutesPerKm = totalMinutes / this.distance.value;
    //Get only integer part of minutes
    int minutesPerKmIntegers = minutesPerKm.toInt();

    if(minutesPerKmIntegers > 59){
       return Text(
        'Informe uma distância maior!',
        style: TextStyle(color: Colors.red, fontSize: 25.0),
      );
    }

    //Get the rest part of kilometers   
    double minutesPerKmRest = minutesPerKmIntegers > 0 ? minutesPerKm % minutesPerKmIntegers : minutesPerKm;

    

    //Convert the rest into seconds and round it
    int secondsMinutesPerKm = (minutesPerKmRest * 60).round();

    //Format string o have a zero before an unique number
    String secondsFormatted = '$secondsMinutesPerKm'.padLeft(2, '0');

TextStyle styleDescription = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
TextStyle styleResult = TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold);

    return Card(
      margin: EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: double.infinity,
        height: 200.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/temp.png'),
                fit: BoxFit.fitWidth),color: Colors.lightGreenAccent.withOpacity(0.1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Seu Pace para ${this.distance.label} é: ', style: styleDescription,),
            Text('$minutesPerKmIntegers:$secondsFormatted min/km' , style: styleResult,),
          ],
        ),
      ),
    );
  }
}
