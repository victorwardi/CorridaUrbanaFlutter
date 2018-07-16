import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../model/post.dart';

class PostDao {
  Future<List<Post>> getNews(int page) async {
    return _getPostListFromInternet(
        'https://www.corridaurbana.com.br/wp-json/wp/v2/posts?&fields=title,link,date,author,featured_media&page=$page',
        'assets/jsons/posts.json');
  }

  Future<List<Post>> getReviews(int page) async {
    return _getPostListFromInternet(
        "https://www.corridaurbana.com.br/wp-json/wp/v2/posts?_embed&fields=title,link,date,author,featured_media,review&tags=66&page=$page",
        'assets/jsons/reviews-empty.json');
    // 'assets/jsons/reviews.json');
  }

//get post ids
  Future<List<Post>> getPostsList([int page = 1, int postPerPage = 5]) async {
    List<Post> postIdsList = await _getPostListFromInternet(
        'https://www.corridaurbana.com.br/wp-json/wp/v2/posts?page=$page&per_page=$postPerPage&fields=id',
        'assets/jsons/posts_list.json');

    List<Post> posts = [];

    //for each post id, get post properties
    postIdsList.forEach((p) async {
      Post post = await getPost(p.id);
      posts.add(post);
    });

    return posts;
  }

  Future<Post> getPost(int postId) async {
    return _getPostFromJson(
        'https://www.corridaurbana.com.br/wp-json/wp/v2/posts/$postId?&fields=title,link,date,author,featured_media',
        'assets/jsons/posts.json');
  }

  ///Get posts from json file
  ///
  ///[urlJsonInternet] - Url from internt
  ///
  ///[fileJsonLocal] (Optional) Asset maped on pubscpec.yaml
  ///
  ///[cacheHours] - (Optional) paremeter to informe how long cache will be estored -> 168 hours (7 days)
  Future<List<Post>> _getPostListFromInternet(String urlJsonInternet,
      [String fileJsonLocal, int cacheHours = 168]) async {
    try {
      var responseJson = await _getJsonInternet(urlJsonInternet, cacheHours);
      return _buildPostListFromJson(json.decode(responseJson));

    } catch (e) {   
      final responseLocal = await loadLocalJson(fileJsonLocal);
      return _buildPostListFromJson(responseLocal);
    }
  }

  ///Get post from json file
  ///
  ///[urlJsonInternet] - Url from internt
  ///
  ///[fileJsonLocal] (Optional) Asset maped on pubscpec.yaml
  ///
  ///[cacheHours] - (Optional) paremeter to informe how long cache will be estored -> 168 hours (7 days)
  Future<Post> _getPostFromJson(String urlJsonInternet,
      [String fileJsonLocal, int cacheHours = 168]) async {
    try {
      var responseJson = await _getJsonInternet(urlJsonInternet, cacheHours);
      return _buildPostFromJsonMap(json.decode(responseJson));
    } catch (e) {
      final responseLocal = await loadLocalJson(fileJsonLocal);
      return _buildPostFromJsonMap(json.decode(responseLocal));
    }
  }

  Future<String> _getJsonInternet(String urlJsonInternet, int cacheHours) async {

    CacheManager.showDebugLogs = true;

    CacheManager.maxAgeCacheObject = new Duration(hours: 6);

    var cacheManager = await CacheManager.getInstance();

    var file = await cacheManager.getFile(urlJsonInternet);

    final postsJson = await file.readAsString();

    return postsJson;

  }

  List<Post> _buildPostListFromJson(String postsJson) {
    List<Post> posts = [];
    try {
      json.decode(postsJson).forEach((p) => posts.add(_buildPostFromJsonMap(p)));
    } catch (e) {
      return posts; //return empty list
    }
    return posts;
  }

  Post _buildPostFromJsonMap(Map postJson) {

   // Map postJson = json.decode(postJsonString);

    Post post = new Post();

    if (postJson['id'] != null) {
      post.id = postJson['id'];
    }
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
      post.imageId = postJson['featured_media'];
    }
    if (postJson['link'] != null) {
      post.link = postJson['link'];
    }
    if (postJson['review'] != null) {
      post.review = post.getReview(postJson['review']);
    }
    return post;
  }

  Future<String> loadLocalJson(String file) async {
    return await rootBundle.loadString(file);
  }
}
