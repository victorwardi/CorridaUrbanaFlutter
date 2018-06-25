import 'package:flutter/material.dart';
import 'package:corrida_urbana/model/post.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  PostDetail(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment(0.6, 0.9),
              children: <Widget>[
                DecoratedBox(
                  child: Image.network(post.image),
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
                      //tileMode: TileMode.repeated
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    post.title,
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(

                 children: <Widget>[

                   Text(
                     post.content,
                   ),
                 ],


              ),
            ),
          ],
        ),
      ),
    );
  }
}
