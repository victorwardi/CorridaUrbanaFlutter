import 'dart:async';
import 'dart:convert';
import 'package:corrida_urbana/model/image_post.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImagePostDao {
  Future<ImagePost> getImage(int id) async {
    String url = 'https://www.corridaurbana.com.br/wp-json/wp/v2/media/$id?&fields=id,media_details.sizes.full';
//await new Future.delayed(Duration(seconds: 5));

    ImagePost image = new ImagePost();

    image.id = id;

    try {
      CacheManager.showDebugLogs = true;
      var cacheManager = await CacheManager.getInstance();
      cacheManager.lastCacheClean;
      var file = await cacheManager.getFile(url);
      final jsonResponse = await file.readAsString();
      image.url = _getImageUrl(jsonResponse);
    } catch (e) {
      print(e);
           return null;
    }

    return image;
  }

  /*JSON RETURNED FROM: https://www.corridaurbana.com.br/wp-json/wp/v2/media/21266?&fields=id,media_details.sizes.full.source_url
      "media_details": {
      "sizes": {
          "full": {
                    "source_url": "https://i2.wp.com/www.corridaurbana.com.br/wp-content/uploads/2018/07/capa.jpg?fit=800%2C600&quality=100&strip=all&ssl=1"
                }
        }
          
      */
  String _getImageUrl(String responseJson) {
    final imageJson = json.decode(responseJson);   
    String imageUrl = '';
    
      if (imageJson['media_details'] != null) {
        imageUrl = imageJson['media_details']['sizes']['full']['source_url'];
      }
   

    return imageUrl;
  }
}
