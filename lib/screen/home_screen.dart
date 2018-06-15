import 'package:flutter/material.dart';
import 'posts_screen.dart';
import 'package:corrida_urbana/screen/calendar_screen.dart';

const TextStyle _styleButton = TextStyle(fontSize: 20.0, color: Colors.white);
const double _iconSize = 50.0;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Corrida Urbana APP"),
      ),

      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RaisedButton.icon(
                icon: new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.directions_run,
                    size: _iconSize,
                    color: Colors.white,
                  ),
                ),
                label: Text(
                  "Corridas",
                  style: _styleButton,
                ),
                color: Colors.teal,               
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarScreen()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RaisedButton.icon(
                icon: new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.list,
                    size: _iconSize,
                    color: Colors.white,
                  ),
                ),
                label: Text(
                  "Notícias",
                  style: _styleButton,
                ),
                color: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(title: 'Corrida Urbana -  Corridas')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
