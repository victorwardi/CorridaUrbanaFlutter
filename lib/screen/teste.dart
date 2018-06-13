import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import '../model/corrida.dart';

class TestWidget extends StatefulWidget {
  @override
  State createState() => new _testWidgetState();

  main(List<String> args) {
    print("object");
  }
}

class _testWidgetState extends State<TestWidget> {


  Future<List> _posts;

  String _url;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();

      setState(() {
              _posts = this.loadData();
            });
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Teste APP"),),
      body: new Column(
        children: <Widget>[
          new Expanded(
            flex: 3,
            child: new Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: new FutureBuilder(
                  future: _posts,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List dataList = snapshot.data;
                      List<Widget> listViewData = new List<Widget>();

                      dataList.forEach(
                        (post) {
                          listViewData.add(
                            new Text(
                              post.title,
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );},
                      );

                      return new ListView(children: listViewData);
                    } else {
                      return new CircularProgressIndicator();
                    }
                  }),
            ),
          ),
          new Expanded(
            flex: 1,
            child: new Container(      

              alignment: Alignment.topCenter,
              child: new IconButton(
                icon: new Icon(Icons.navigate_next),
                onPressed: (() {
                  setState(() {
                    _url = "https://www.corridaurbana.com.br/wp-json/wp/v2/corrida?_embed";
                  });
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List> loadData() async {

    List data = new List();



    try {
      final response = await http.get("https://www.corridaurbana.com.br/wp-json/wp/v2/posts?&_embed");
      final Map responseJson = json.decode(response.body);
responseJson.forEach((k,v) {

  print("$k = $v");
});


     
    } catch (e) {
      print(e.toString());
    }

    return data;
  }
}
