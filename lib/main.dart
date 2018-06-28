import 'package:flutter/material.dart';
import 'package:corrida_urbana/screen/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Corrida Urbana',
      theme: myTheme(),
      home: HomeScreen(),
      //home: new TestWidget(),
    );
  }

  ThemeData myTheme() {
    return ThemeData(

    
     primarySwatch: Colors.teal,

    );
  }
}
