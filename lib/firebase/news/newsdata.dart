class NewsData {
  final String? author;
  final String? image;
  final String description;
  final String source;
  final String url;
  final String title;
  NewsData.fromJson(Map<String, dynamic> json)
      : author = json['author'],
        image = json['image'],
        description = json['description'],
        source = json['source'],
        url = json['url'],
        title = json['title'];
  NewsData({
    required this.author,
    required this.description,
    required this.image,
    required this.source,
    required this.title,
    required this.url,
  });
}
