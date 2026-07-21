import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String _rssUrl = 'https://feeds.feedburner.com/TheHackersNews';
  static const String _apiUrl = 'https://api.rss2json.com/v1/api.json?rss_url=';

  Future<List<NewsModel>> fetchCyberNews() async {
    try {
      final response = await http.get(Uri.parse('$_apiUrl$_rssUrl'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok' && data['items'] != null) {
          final List<dynamic> items = data['items'];
          return items.map((json) => NewsModel.fromJson(json)).toList();
        } else {
          throw Exception('Failed to parse news feed.');
        }
      } else {
        throw Exception('Failed to load news.');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
