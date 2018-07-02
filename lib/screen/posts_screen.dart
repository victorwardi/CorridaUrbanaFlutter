import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'package:corrida_urbana/model/post.dart';
import 'package:corrida_urbana/screen/post_screen.dart';
import '../dao/post_dao.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  Future<List> postsInternet;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.postsInternet = new PostDao().getNews();
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


  Widget _createListView(BuildContext context, List posts) {
    return new ListView.builder(
      padding: new EdgeInsets.all(0.0),
      itemExtent: 160.0,
      itemCount: posts == null ? 0 : posts.length ,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new Card(
              child: new Column(
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 150.0,
                        height: 140.0,
                        child: Image.network(
                          posts[index].image,
                          fit: BoxFit.fitHeight,
                          // alignment: Alignment.centerLeft,
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                posts[index].title,
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ButtonTheme.bar(
                              // make buttons use the appropriate styles for cards
                              child: ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.playlist_play),
                                        Text('LER NOTÍCIA'),
                                      ],
                                    ),
                                    onPressed: () {
                                      _launchURL(posts[index].link);
                                    },
                                  ),
                                  FlatButton(
                                    child: Icon(Icons.share),
                                    onPressed: () { Share.share('Leia esta noticia do site Corrida Urbana: $posts[index].link');},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
