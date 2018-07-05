import 'dart:async';
import 'package:corrida_urbana/model/post.dart';
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
  List<Post> posts;

  String shareDescription;
  String readMoreText;

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.postType == 'news') {
        this.postsInternet = new PostDao().getNews(1);
        new PostDao().getNews(1).then((posts) {
          this.posts = posts;
        });
        this.shareDescription = 'Confira mais no site Corrida Urbana: ';
        this.readMoreText = ' LER NOTÍCIA COMPLETA';
      } else if (widget.postType == 'reviews') {
        this.postsInternet = new PostDao().getReviews(1);
        new PostDao().getReviews(1).then((posts) {
          this.posts = posts;
        });
        this.shareDescription = 'Confira o review no site Corrida Urbana: ';
        this.readMoreText = ' LER REVIEW COMPLETO';
      }

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      this.page++;

      List<Post> morePosts = new List<Post>();
      if (widget.postType == 'news1') {
        morePosts = await new PostDao().getNews(this.page);
      } else if (widget.postType == 'reviews') {
        morePosts = await new PostDao().getReviews(this.page);
      }

  if (morePosts.isEmpty) {
      double edge = 50.0;
      double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
      if (offsetFromBottom < edge) {
        _scrollController.animateTo(
            _scrollController.offset - (edge -offsetFromBottom),
            duration: new Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
    }

      setState(() {
        posts.addAll(morePosts);
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return  new Center(
          child: new Opacity(
            opacity: isPerformingRequest ? 1.0 : 0.0,
            child: new CircularProgressIndicator(),
          ),      
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Center(child: _buildScreen(context)));
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
                child: Column(
                  children: <Widget>[
                    Expanded(child: _createListView(context, snapshot.data)),                    
                  ],
                ),
              );
        }
      },
    );
  }

  Widget _createListView(BuildContext context, List posts) {
    posts = this.posts;
    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      controller: _scrollController,
      //itemExtent: 380.0,
      itemCount: posts == null ? 0 : posts.length + 1,
      itemBuilder: (BuildContext context, int index) {
print(index);
        if (index == (posts.length)) {
          //return Center(child: new CircularProgressIndicator());
         return _buildProgressIndicator();
        } else {
        var titulo = '${index + 1} - ${posts[index].title} ';
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
                                height: 200.0,
                                child: posts[index].image != null
                                    ? Image.network(posts[index].image,
                                        fit: BoxFit.fitWidth)
                                    : Image.asset('assets/images/temp.png',
                                        fit: BoxFit.fitWidth),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  titulo,
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: posts[index].date != '' &&
                                        widget.postType == 'news'
                                    ? Text(
                                        posts[index].date,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      )
                                    : Container(
                                        width: 0.0,
                                        height: 0.0,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.add_circle),
                                          Text(this.readMoreText),
                                        ],
                                      ),
                                      onPressed: () {
                                        _launchURL(posts[index].link);
                                      },
                                    ),
                                    Center(
                                      child: FlatButton(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(Icons.share),
                                        onPressed: () {
                                          var link = posts[index].link;
                                          Share.share(
                                              this.shareDescription + link);
                                        },
                                      ),
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
        }
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
