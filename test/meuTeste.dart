import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';


printDailyNewsDigest() async {
  String news = await gatherNewsReports();
  print(news);
}

main() {

   List<int> items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

   items.insert(0, 10);
   items.insert(0, 10);
   items.insert(0, 10);
   items.insert(0, 10);
   items.insert(0, 10);

   items.forEach((i) => print(i));

  String a = 'Victor';

  String b;

  String c = 'Wardi';

  c ??= a;

  print(c);

 initializeDateFormatting();
 Intl.defaultLocale = 'pt_BR';
print( Intl.getCurrentLocale());


 
DateTime data = DateTime.parse("2018-06-18T10:52:41");



  //print(new DateFormat("d 'de' MMMM 'de' yyyy').format(data));


}

printWinningLotteryNumbers() {
  print('Winning lotto numbers: [23, 63, 87, 26, 2]');
}

printWeatherForecast() {
  print("Tomorrow's forecast: 70F, sunny.");
}

printBaseballScore() {
  print('Baseball score: Red Sox 10, Yankees 0');
}

// Imagine that this function is more complex and slow. :)
Future gatherNewsReports() {

  var duracao = new Duration(seconds: 5);

  print('Loading news....');

  final newsStream = new Stream.periodic(duracao, (_) => printReviews() );

  return newsStream.first;
}

// Alternatively, you can get news from a server using features
// from either dart:io or dart:html. For example:
//

printReviews() {
  String url =
      'https://www.corridaurbana.com.br/wp-json/wp/v2/posts?_embed&fields=title,link,_embedded.wp:featuredmedia&tags=66';
  //String file = 'assets/jsons/reviews.json';

  String posts = '';
  http.get(url).then((responseHttp) {

    posts = responseHttp.body;
      print(posts);
  });


}
