import 'dart:async';
import 'dart:convert';

import 'package:corrida_urbana/model/author.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AuthorDao {
  Future<Author> getAuthor(int id) async {
    String url =
        'https://www.corridaurbana.com.br/wp-json/wp/v2/users/$id?fields=name,avatar_urls.96';

    Author author;
await new Future.delayed(Duration(seconds: 5));
    try {
      CacheManager.showDebugLogs = true;
      var cacheManager = await CacheManager.getInstance();
      var file = await cacheManager.getFile(url);
      final jsonResponse = await file.readAsString();
      author = _getAuthorInfos(jsonResponse);
      author.id = id;
    } catch (e) {
      return null;
    }

    return author;
  }

  /*JSON RETURNED FROM: https://www.corridaurbana.com.br/wp-json/wp/v2/users/1?fields=name,avatar_urls.96
      {
        "name": "Victor Caetano",
        "avatar_urls": {
          "96": "https://secure.gravatar.com/avatar/786424d5752a9dc781d5eab4f43bb032?s=96&d=mm&r=g"
          }
        }
          
      */
  Author _getAuthorInfos(String responseJson) {
    final authorJson = json.decode(responseJson);

    Author author = new Author();
    if (authorJson['name'] != null) {
      author.name = authorJson['name'];
    }

    if (authorJson['avatar_urls'] != null) {
      author.avatar = authorJson['avatar_urls']['96'];
    }

    return author;
  }
}
