import 'dart:async';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import '../dao/post_dao.dart';

class PostsScreen extends StatefulWidget {
  PostsScreen({Key key, this.title, this.postType}) : super(key: key);

  final String title;
  final String postType;

  @override
  _PostsScreenState createState() => new _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  

  Future<List> postsInternet;

  @override
  void initState() {
    super.initState();
    setState(() {     
      this.postsInternet = widget.postType == 'news' ? new PostDao().getNews() : new PostDao().getReviews();
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
    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      itemExtent: 380.0,
      itemCount: posts == null ? 0 : posts.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Card(
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 250.0,
                              child: posts[index].image != null
                                  ? Image.network(posts[index].image,
                                      fit: BoxFit.fitWidth)
                                  : Image.asset('assets/images/temp.png',
                                      fit: BoxFit.fitWidth),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                posts[index].title,
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                posts[index].date,
                                
                                style: TextStyle(
                                    fontSize: 12.0,               ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.playlist_play),
                                      Text('Ver mais'),
                                    ],
                                  ),
                                  onPressed: () {
                                    _launchURL(posts[index].link);
                                  },
                                ),
                                FlatButton(
                                  child: Icon(Icons.share),
                                  onPressed: () {
                                    var link = posts[index].link;
                                    Share.share(
                                        'Confira o review no site Corrida Urbana: $link');
                                  },
                                ),
                              ],
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
