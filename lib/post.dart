
class Post {
  final int id;
  final String date;
  final String title;
  final String content;
  final String image;

  Post({this.id, this.date, this.title, this.content, this.image});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      id: json['id'],
      date: json['date'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      image: json['_embedded']['wp:featuredmedia'][0]['source_url'],
    );
  }
}

