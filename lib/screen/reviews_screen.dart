import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter/services.dart' show rootBundle;

import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'package:corrida_urbana/model/post.dart';


class ReviewsScreen extends StatefulWidget {
  ReviewsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReviewsScreenState createState() => new _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final String url =
      "https://www.corridaurbana.com.br/wp-json/wp/v2/posts?_embed&fields=title,link,_embedded.wp:featuredmedia&tags=66";

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
        final response = await http.get(url);

      //final response = await rootBundle.loadString('assets/jsons/posts.json');

      final responseJson = json.decode(response.body);
      posts = responseJson.map((post) => new Post.fromJson(post)).toList();
    } catch (e) {
      print(e.toString());
    }

    return posts;
  }

  Widget _createListView(BuildContext context, List posts) {
    return new ListView.builder(
      padding: new EdgeInsets.all(0.0),
      itemExtent: 160.0,
      itemCount: posts.length,
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
                                        Text('LER REVIEW'),
                                      ],
                                    ),
                                    onPressed: () {
                                      _launchURL(posts[index].link);
                                    },
                                  ),
                                  FlatButton(
                                    child: Icon(Icons.share),
                                    onPressed: () { Share.share('Confira o review no site Corrida Urbana: $posts[index].link');},
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
