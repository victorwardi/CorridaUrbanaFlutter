import 'package:flutter/material.dart';
import 'package:corrida_urbana/screen/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Corrida Urbana',
      theme: new ThemeData(
        primaryTextTheme: TextTheme(
            body1: TextStyle(
            //  color: Colors.white,
              fontSize: 22.0,
            ),
            title: TextStyle(
             // color: Colors.white,
              fontSize: 22.0,
            ),
        ),
        primaryColor: Colors.teal[800],

        accentColor: Colors.cyan[600],
        iconTheme: IconThemeData(color: Colors.teal[50], size: 18.0),
        scaffoldBackgroundColor: Colors.teal[900],
        textTheme: TextTheme(
          body1: TextStyle(
           // color: Colors.white,
            fontSize: 14.0,
          ),
          subhead:  TextStyle(
           // color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
      home: new Container(child: HomeScreen(),
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
      ),
      //home: new TestWidget(),
    );
  }
}
