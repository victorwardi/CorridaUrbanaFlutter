import 'package:flutter/material.dart';
import 'package:corrida_urbana/post.dart';

import 'package:flutter_html_view/flutter_html_view.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  PostDetail(this.post);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(post.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Image.network(post.image),
            new HtmlView(data:post.content.replaceAll(new RegExp(r'<[^>]*>'), '')),
          ],
        ),
      )
    );
  }
}
