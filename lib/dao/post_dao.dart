import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../model/post.dart';

class PostDao {
  Future<List<Post>> getNews(int page) async {
    return _getPosts(
        'https://www.corridaurbana.com.br/wp-json/wp/v2/posts?&_embed&fields=title,link,date,_embedded.wp:featuredmedia&page=${page}',
        'assets/jsons/posts.json');
  }

  Future<List<Post>> getReviews(int page) async {
    return _getPosts(
        "https://www.corridaurbana.com.br/wp-json/wp/v2/posts?_embed&fields=title,link,date,_embedded.wp:featuredmedia&tags=66&page=${page}",
        'assets/jsons/reviews-empty.json');
       // 'assets/jsons/reviews.json');
  }

  Future<List<Post>> _getPosts(
      String urlJsonInternet, String fileJsonLocal) async {
    try {
      //read json from internet
      final responseInternet = await http.get(urlJsonInternet);
      //If server returns an OK response, parse the JSON
      return _buildPostList(responseInternet.body);
    } catch (e) {
      // print("Impossible to read Internet Json - Error: " + e.toString());
      //read json from local file
      final responseLocal = await loadLocalJson(fileJsonLocal);
      return _buildPostList(responseLocal);
    }
  }

  List<Post> _buildPostList(String postsJson) {

    List<Post> posts = new List<Post>();

    final responseJson = json.decode(postsJson);

    try {
      for (var postJson in responseJson) {
        Post post = new Post();

        if (postJson['title']['rendered'] != null) {
          post.title = postJson['title']['rendered'];
        }
        if (postJson['date'] != null) {
          initializeDateFormatting();
          DateTime date = DateTime.parse(postJson['date']);
          post.date = DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(date);
        } else {
          post.date = '';
        }
        if (postJson['link'] != null) {
          post.link = postJson['link'];
        }
        if (postJson['_embedded'] != null) {
          if (postJson['_embedded']['wp:featuredmedia'] !=
              null) if (postJson['_embedded']['wp:featuredmedia']
                  [0] !=
              null) if (postJson['_embedded']['wp:featuredmedia'][0]
                  ['source_url'] !=
              null)
            post.image =
                postJson['_embedded']['wp:featuredmedia'][0]['source_url'];
        }
        if (postJson['link'] != null) {
          post.link = postJson['link'];
        }

        posts.add(post);

      
      }
    } catch (e) {
      return posts; //return empty list
    }
    return posts;
  }

  //filtrarPorMes(Corrida corrida, String mes) => corrida.mes == mes;

  Future<String> loadLocalJson(String file) async {
    return await rootBundle.loadString(file);
  }
}
