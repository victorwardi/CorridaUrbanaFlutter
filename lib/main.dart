import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'package:corrida_urbana/post.dart';
import 'package:corrida_urbana/screen/post_screen.dart';

import 'screen/calendar_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Colors.black26,
      ),
      // home: new MyHomePage(title: 'Corrida Urbana - News'),
       home: new CalendarScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = "https://www.corridaurbana.com.br/wp-json/wp/v2/posts?&_embed";

  Future<List> posts;

  @override
  void initState() {
    super.initState();

    if(posts != null){
      this._getData();
    }


  }

  @override
  Widget build(BuildContext context) {

    final Widget _getPosts = new FutureBuilder(
      future: posts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new CircularProgressIndicator();
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return _createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(child: _getPosts),

    );
  }

  Future<List> _getData() async {

    try{

      final response = await http.get(url);
      final responseJson = json.decode(response.body);
      posts  =  responseJson.map((post) => new Post.fromJson(post)).toList();

    }catch(e){
      print(e.toString());
    }

  posts.asStream().forEach( (post) => print(post.elementAt(0).image));


    return posts;
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    List posts = snapshot.data;

    return new ListView.builder(
      padding: new EdgeInsets.all(16.0),
      itemExtent: 80.0,
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(posts[index].title),
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder:
                    (BuildContext context) => new PostDetail(posts[index])));
              },
            ),
            new Divider(
              height: 2.0,
            ),
          ],
        );
      },

    );
  }
}
