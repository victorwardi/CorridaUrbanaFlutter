import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Calendario Corrida Urbana"),
      ),
      body: new Column(
        children: <Widget>[
          new Text("Corridas"),
        ],
      ),
    );
  }
}