import 'dart:async';
import 'package:corrida_urbana/dao/author_.dao.dart';
import 'package:corrida_urbana/dao/image_post_dao.dart';
import 'package:corrida_urbana/model/author.dart';
import 'package:corrida_urbana/model/image_post.dart';
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
  List<Post> posts2 = [];

  BuildContext scaffoldContext;

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

        this.shareDescription = 'Confira mais no site Corrida Urbana: ';
        this.readMoreText = ' LER NOTÍCIA COMPLETA';
      } else if (widget.postType == 'reviews') {
        this.postsInternet = new PostDao().getReviews(1);

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
    this.page = 1;
    super.dispose();
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      this.page++;

      List<Post> morePosts = new List<Post>();
      if (widget.postType == 'news') {
        morePosts = await new PostDao().getNews(this.page);
      } else if (widget.postType == 'reviews') {
        morePosts = await new PostDao().getReviews(this.page);
      }

      if (morePosts.isEmpty) {
        double edge = 300.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);

          final snackBar = SnackBar(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Não há mais posts.'),
            ),
            backgroundColor: Colors.teal,
            duration: Duration(seconds: 5),
          );

// Find the Scaffold in the Widget tree and use it to show a SnackBar
          Scaffold.of(this.scaffoldContext).showSnackBar(snackBar);
        }
      }

      setState(() {
        postsInternet.then((posts) => posts.addAll(morePosts));
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: Column(
            children: <Widget>[
              new CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text('Carregando mais posts...'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Builder(builder: (BuildContext contextScafold) {
        this.scaffoldContext = contextScafold;
        return Center(child: _buildScreen(context));
      }),
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

  Widget _createListView(BuildContext context, List<Post> posts) {
    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      controller: _scrollController,
      itemExtent: 410.0,
      itemCount: posts == null ? 0 : posts.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == (posts.length)) {
          //return Center(child: new CircularProgressIndicator());
          return _buildProgressIndicator();
        } else {
          var titulo = posts[index].title;
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
                                color: Colors.grey,
                                height: 200.0,
                                child: Stack(
                                  children: <Widget>[
                                    _getPostImage(posts[index].imageId),
                                    _getReviewStars(posts[index]),
                                  ],
                                ),
                              ),
                              _getTitle(titulo),
                              _getAuthorDate(posts[index]),
                              _getMenu(posts[index]),
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

  Widget _getMenu(Post post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              _launchURL(post.link);
            },
          ),
          Center(
            child: FlatButton(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.share),
              onPressed: () {
                var link = post.link;
                Share.share(this.shareDescription + link);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAuthorDate(Post post) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _getAuthor(post.authorId),
          post.date != '' && widget.postType == 'news'
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      color: Colors.grey[700],
                    ),
                    Text(
                      post.date,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 0.0,
                  height: 0.0,
                ),
        ],
      ),
    );
  }

  Widget _getTitle(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 10.0,
        right: 10.0,
      ),
      child: Container(
        alignment: Alignment.center,
        height: 40.0,
       
        child: Text(
          titulo,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _imageBox(Widget imageWidget) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(width: double.infinity, child: imageWidget),
        ),
      ],
    );
  }

  Widget _getPostImage(int imageId) {
    var postImgWidget;
    try {
      postImgWidget = FutureBuilder(
          future: ImagePostDao().getImage(imageId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            ImagePost image = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return _imageBox(Stack(
                  fit: StackFit.expand,
                  // fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset('assets/images/temp.png',
                        fit: BoxFit.fitHeight),
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                  ],
                ));

              default:
                if (snapshot.hasError) {
                  return new Text('Error: ${snapshot.error}');
                } else {
                  return _imageBox(image.url != null
                      ? Image.network(image.url, fit: BoxFit.fitWidth)
                      : Image.asset('assets/images/temp.png',
                          fit: BoxFit.fitWidth));
                }
            }
          });
    } catch (e) {
      print(e);
    }
    return postImgWidget;
  }

  Widget _getReviewStars(Post post) {
    if (post.review == null) {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }

    double totalStars = post.review;

    List<Widget> starList = new List();

    int starInt = totalStars.toInt();

    Color starColor = Colors.amberAccent;

    //get all full stars
    for (var i = 0; i < starInt; i++) {
      starList.add(new Icon(Icons.star, color: starColor));
    }

    //get the rest of stars
    double starRest = totalStars - starInt;

    //get full star or half or empty star
    if (starRest >= 0.25 && starRest < 0.75) {
      starList.add(new Icon(Icons.star_half, color: starColor));
    } else if (starRest >= 0.75) {
      starList.add(new Icon(Icons.star, color: starColor));
    } else if (totalStars != 5) {
      starList.add(new Icon(Icons.star_border, color: starColor));
    }

    // this echo empty star
    for (var i = 0; i < 4 - starInt; i++) {
      starList.add(new Icon(Icons.star_border, color: starColor));
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(child: Row(children: starList)),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[
              Colors.black.withOpacity(1.0),
              Colors.black.withOpacity(0.0),
              Colors.black.withOpacity(0.0),
            ]),
      ),
    );
  }

  Widget _getAuthor(int authorId) {
    var postAuthorWidget;

    try {
      postAuthorWidget = Container(
        //width: 100.0,
        height: 55.0,
        child: FutureBuilder(
            future: AuthorDao().getAuthor(authorId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){

             
              Author author = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                 return Row(
                   children: <Widget>[
                     new Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey ,                            
                              ),
                              child: Icon(Icons.person),
                            ),
                            Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('carregando autor...'),
                        ),
                   ],
                 );
                    

                default:
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    return Row(
                      children: <Widget>[
                        new Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                author.avatar,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(author.name),
                        ),
                      ],
                    );
                  }
              }
             }else{
               return Row(
                   children: <Widget>[
                     new Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey ,                            
                              ),
                              child: Icon(Icons.person),
                            ),
                            Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('carregando autor...'),
                        ),
                   ],
                 );
             }}),
      );
    } catch (e) {
      print(e);
    }
    return postAuthorWidget;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
