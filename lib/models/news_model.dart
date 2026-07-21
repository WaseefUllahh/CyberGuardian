class NewsModel {
  final String title;
  final String pubDate;
  final String link;
  final String author;
  final String description;
  final String content;
  final String imageUrl;

  NewsModel({
    required this.title,
    required this.pubDate,
    required this.link,
    required this.author,
    required this.description,
    required this.content,
    required this.imageUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    String parsedImageUrl = '';
    
    // Check if enclosure exists and has an image
    final enclosure = json['enclosure'];
    if (enclosure != null && enclosure is Map && enclosure['link'] != null) {
      parsedImageUrl = enclosure['link'].toString();
    } 
    // Fallback to thumbnail if enclosure is missing
    else if (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty) {
      parsedImageUrl = json['thumbnail'].toString();
    }

    // Sometimes rss2json returns images in content as <img src="...">
    if (parsedImageUrl.isEmpty && json['content'] != null) {
      final imgRegex = RegExp(r'<img[^>]+src="([^">]+)"');
      final match = imgRegex.firstMatch(json['content']);
      if (match != null && match.groupCount >= 1) {
        parsedImageUrl = match.group(1) ?? '';
      }
    }

    return NewsModel(
      title: json['title'] ?? 'No Title',
      pubDate: json['pubDate'] ?? '',
      link: json['link'] ?? '',
      author: json['author'] ?? 'Unknown',
      description: json['description'] ?? '',
      content: json['content'] ?? json['description'] ?? '',
      imageUrl: parsedImageUrl,
    );
  }
}
