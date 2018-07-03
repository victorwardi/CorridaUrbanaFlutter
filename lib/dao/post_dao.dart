import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

import '../model/post.dart';

class PostDao {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<List<Post>> getNews() async {
    return getPosts(
        'https://www.corridaurbana.com.br/wp-json/wp/v2/posts?&_embed&fields=title,link,_embedded.wp:featuredmedia',
        'assets/jsons/posts.json');
  }

  Future<List<Post>> getReviews() async {
    return getPosts(
        "https://www.corridaurbana.com.br/wp-json/wp/v2/posts?_embed&fields=title,link,_embedded.wp:featuredmedia&tags=66",
        'assets/jsons/reviews.json');
  }

  List<Post> getReviewsSync() {
    String url =
        'https://www.corridaurbana.com.br/wp-json/wp/v2/posts?_embed&fields=title,link,_embedded.wp:featuredmedia&tags=66';
    String file = 'assets/jsons/reviews.json';

    List<Post> posts;

    http.get(url).then((responseHttp) {
      posts = _buildPostList(responseHttp.body);
    });

    return posts;
  }

  Future<List<Post>> getPosts(String url, String file) async {
    try {
      final response = await http.get(url).catchError((onError) {
        final responseLocal = rootBundle.loadString(file);
        responseLocal.then((jsonString) {
          return _buildPostList(jsonString);
        });
       
      }).whenComplete(() {
        print('completou!');
      });
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        return _buildPostList(response.body);
      } else {
        print('Deu merda!');
      }
    } catch (e) {
      print(e);
    }
  }

  List<Post> _buildPostList(String postsJson) {
    List<Post> posts = new List<Post>();

    final responseJson = json.decode(postsJson);

    for (var postJson in responseJson) {
      Post post = new Post();

      if (postJson['title']['rendered'] != null) {
        post.title = postJson['title']['rendered'];
      }
      if (postJson['date'] != null) {
        post.date = postJson['date'];
      }
      if (postJson['link'] != null) {
        post.link = postJson['link'];
      }
      if (postJson['_embedded']['wp:featuredmedia'][0]['source_url'] != null) {
        post.image = postJson['_embedded']['wp:featuredmedia'][0]['source_url'];
      }
      if (postJson['link'] != null) {
        post.link = postJson['link'];
      }
      if (postJson['link'] != null) {
        post.link = postJson['link'];
      }

      posts.add(post);
    }

    return posts;
  }

  //filtrarPorMes(Corrida corrida, String mes) => corrida.mes == mes;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<Null> initConnectivity() async {
    try {
      this._connectionStatus =
          (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      this._connectionStatus = 'Falha ao conectar';
    }
  }
}
