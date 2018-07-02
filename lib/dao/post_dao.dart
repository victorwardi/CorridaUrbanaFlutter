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

  Future<List<Post>> getPosts(String url, String file) async {
    List<Post> posts;

    try {
      initConnectivity();
      _connectivitySubscription = _connectivity.onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (_connectionStatus != 'ConnectivityResult.none') {
          final responseHttp = await http.get(url);
          posts = _buildPostList(responseHttp.body);
        } else {
          final responseFile = await rootBundle.loadString(file);
          posts = _buildPostList(responseFile);
        }

        _connectionStatus = result.toString();

        print(_connectionStatus);
      });
    } catch (e) {
      print(e.toString());
    }
    return posts;
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
