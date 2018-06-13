import 'package:flutter/material.dart';
import 'posts_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Corrida Urbana APP"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              icon: Icon(Icons.directions_run),
              label: Text("Corridas"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  MyHomePage(title: 'Corrida Urbana -  s')),
                );
              },
            ),
            RaisedButton.icon(
              icon: Icon(Icons.list),
              label: Text("Notícias"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Corrida Urbana -  s')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
