import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../model/post.dart';

class PostDao {

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

  Future<List<Post>> getPosts(String urlJsonInternet, String fileJsonLocal) async {
    try {
      //read json from internet
      final responseInternet = await http.get(urlJsonInternet);
      //If server returns an OK response, parse the JSON
      return _buildPostList(responseInternet.body);
    } catch (e) {
      print("Impossible to read Internet Json - Error: " + e.toString());
      //read json from local file
      final responseLocal = await loadLocalJson(fileJsonLocal);
      return _buildPostList(responseLocal);
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
      }else{
        post.date = '';
      }
      if (postJson['link'] != null) {
        post.link = postJson['link'];
      }
      if (postJson['_embedded'] != null) {
        if (postJson['_embedded']['wp:featuredmedia'] != null)
          if (postJson['_embedded']['wp:featuredmedia'][0] != null)
            if (postJson['_embedded']['wp:featuredmedia'][0]['source_url'] != null)      
              post.image = postJson['_embedded']['wp:featuredmedia'][0]['source_url'];
      }
      if (postJson['link'] != null) {
        post.link = postJson['link'];
      }
     

      posts.add(post);
    }

    return posts;
  }

  //filtrarPorMes(Corrida corrida, String mes) => corrida.mes == mes;

  Future<String> loadLocalJson(String file) async {
    return await rootBundle.loadString(file);
  }
}
