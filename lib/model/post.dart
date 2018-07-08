class Post {
  String link;
  String date;
  String title;
  String content;
  String image;
  double review;

  double getReview(Map review) {
    double total = 0.0;
    int count = 0;
    double avg = 0.0;

    if (review['p_review_stars'] != null) {
      for (var section in review['p_review_stars']) {
        double rate = double.parse(section['rate']);
        total = total + rate;
        count++;
      }
    }

    if (total == 0.0) {
      avg = 0.0;
    } else {
      avg = total / count;
    }

    print('a nota média é $avg');

    return avg;
  }
}
