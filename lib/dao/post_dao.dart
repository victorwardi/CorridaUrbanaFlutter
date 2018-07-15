import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../model/post.dart';

class PostDao {
  Future<List<Post>> getNews(int page) async {
    return _getPosts(
        'https://www.corridaurbana.com.br/wp-json/wp/v2/posts?&fields=title,link,date,author,featured_media&page=${page}',
        'assets/jsons/posts.json');
  }

  Future<List<Post>> getReviews(int page) async {
    return _getPosts(
        "https://www.corridaurbana.com.br/wp-json/wp/v2/posts?_embed&fields=title,link,date,author,featured_media,review&tags=66&page=${page}",
        'assets/jsons/reviews-empty.json');
       // 'assets/jsons/reviews.json');
  }

  Future<List<Post>> _getPosts( String urlJsonInternet, String fileJsonLocal) async {
    try {

  CacheManager.showDebugLogs = true;

var cacheManager = await CacheManager.getInstance();
    var file = await cacheManager.getFile(urlJsonInternet);

 

      //read json from internet
     // final responseInternet = await http.get(urlJsonInternet);
      //If server returns an OK response, parse the JSON
      //file.readAsString().then((s) => print(s));

      final postsJson = await file.readAsString();

//print(json.decode(file.readAsString().toString()));
      
      return _buildPostList(postsJson);
    } catch (e) {
     
      // print("Impossible to read Internet Json - Error: " + e.toString());
      //read json from local file
      print(e);
      final responseLocal = await loadLocalJson(fileJsonLocal);
      return _buildPostList(responseLocal);
    }
  }

  List<Post> _buildPostList(String postsJson) {

    List<Post> posts = new List<Post>();


    try {

    final responseJson = json.decode(postsJson);
      for (var postJson in responseJson) {
        Post post = new Post();

        if (postJson['title']['rendered'] != null) {
          post.title = postJson['title']['rendered'];
        }
        if (postJson['author'] != null) {
          post.authorId = postJson['author'];
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
        if (postJson['featured_media'] != null) {    
            post.imageId =postJson['featured_media'];
        }
        if (postJson['link'] != null) {
          post.link = postJson['link'];
        }

         if (postJson['review'] != null) {
          post.review = post.getReview(postJson['review']);
        }

        posts.add(post);

      
      }
    } catch (e) {
      print(e);
      return posts; //return empty list
    }
    return posts;
  }

  //filtrarPorMes(Corrida corrida, String mes) => corrida.mes == mes;

  Future<String> loadLocalJson(String file) async {
    return await rootBundle.loadString(file);
  }
}
