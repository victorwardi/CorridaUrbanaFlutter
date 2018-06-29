import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'package:corrida_urbana/model/post.dart';
import 'package:corrida_urbana/screen/post_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url =
      "https://www.corridaurbana.com.br/wp-json/wp/v2/posts?&_embed&fields=title,link,_embedded.wp:featuredmedia";

  Future<List> postsInternet;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.postsInternet = this._getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(child: _buildScreen(context)),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return new FutureBuilder(
      future: postsInternet,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new CircularProgressIndicator();
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _createListView(context, snapshot.data),
              );
        }
      },
    );
  }

  Future<List> _getPosts() async {
    List posts = new List();

    try {
      //  final response = await http.get(url);

      final response = await rootBundle.loadString('assets/jsons/posts.json');

      final responseJson = json.decode(response);
      posts = responseJson.map((post) => new Post.fromJson(post)).toList();
    } catch (e) {
      print(e.toString());
    }

    return posts;
  }

  Widget _createListView(BuildContext context, List posts) {
    return new ListView.builder(
      padding: new EdgeInsets.all(16.0),
      itemExtent: 80.0,
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new Card(

              child: new Column(

               // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ListTile(

                     leading: DecoratedBox(
                      child: Image.network(posts[index].image),
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: <Color>[
                            Colors.black.withOpacity(1.0),
                            Colors.black.withOpacity(0.25),
                            Colors.white.withOpacity(0.0),
                          ],
                          
                        ),
                      ),
                    ),
                    title: Text(posts[index].title),
                  //  subtitle: Text(posts[index].date),
                  ),
                  Text('Victor '),
                  Text('Victor '),
                  Text('Victor '),
                  Text('Victor '),
                  Text('Victor '),
            /*       new ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: new ButtonBar(
                      children: <Widget>[
                        new FlatButton(
                          child: Text('BUY TICKETS'),
                          onPressed: () {/* ... */},
                        ),
                        new FlatButton(
                          child: Text('LISTEN'),
                          onPressed: () {/* ... */},
                        ),
                      ],
                    ),
                  ), */
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
