
class Post {
  final int id;
  final String date;
  final String title;
  final String content;

  Post({this.id, this.date, this.title, this.content});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      id: json['id'],
      date: json['date'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
    );
  }
}

