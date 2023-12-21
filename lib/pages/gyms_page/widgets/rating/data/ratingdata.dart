class RatingData {
  final String title;
  final String review;
  final double stars;
  final String gymId;
  final String? userId;
  final int timestamp;
  RatingData.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        review = json['review'],
        stars = json['stars'],
        gymId = json['gymId'],
        timestamp = json['timestamp'],
        userId = null;
  RatingData({
    required this.title,
    required this.review,
    required this.stars,
    required this.gymId,
    required this.timestamp,
    required this.userId,
  });
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'review': review,
      'stars': stars,
      'timestamp': timestamp,
      'gymId': gymId,
      'userId': userId,
    };
  }
}
