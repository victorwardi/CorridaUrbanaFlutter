import 'package:corrida_urbana/screen/looping_screen.dart';
import 'package:corrida_urbana/util/custom_decoration.dart';
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

      
      body: Container(        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[              
              buildButton(context, 'Teste', Icons.loop, Looping()),
              buildButton(context, 'Corridas', Icons.directions_run, CalendarScreen()),
              buildButton(context, 'Notícias', Icons.list, PostsScreen(title: 'Corrida Urbana -  Notícias', postType: 'news',)),
              buildButton(context, 'Reviews', Icons.star, PostsScreen(title: 'Corrida Urbana -  Reviews', postType: 'reviews',)),
            ],
          ),
        ),
        decoration: UtilDecoration.radialGradiente,
      ),
    );
  }

  Padding buildButton(BuildContext context, String title, IconData icon, Widget page) {
    return Padding(
              padding: const EdgeInsets.all(12.0),
              child: RaisedButton.icon(
                icon: new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    icon,
                    size: _iconSize,
                    color: Colors.white,
                  ),
                ),
                label: Text(
                  title,
                  style: _styleButton,
                ),
                color: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => page ),
                  );
                },
              ),
            );
  }
}
