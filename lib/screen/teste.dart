import 'package:http/http.dart' as http;

printReviews() {
  String url =     'https://www.corridaurbana.com.br/wp-json/wp/v2/posts?_embed&fields=title,link,_embedded.wp:featuredmedia&tags=66';
  String file = 'assets/jsons/reviews.json';

  
String posts = '';
  http.get(url).then((responseHttp) {
     posts = responseHttp.body;
  });

print(posts);

}

main(List<String> args) {
  //printReviews();
  print('oi');
}
