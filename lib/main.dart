
import 'package:flutter/material.dart';
import 'package:corrida_urbana/screen/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.teal,       
        backgroundColor: Colors.black26,
      ),
       home: new HomeScreen(),
      //home: new TestWidget(),
    );
  }
}

