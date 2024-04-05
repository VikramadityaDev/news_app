import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/NewsHeadlinesModel.dart';

import '../models/catgory_news_model.dart';

class NewsRepository {
  Future<NewsHeadlinesModel> fetchNewsChannelHeadLinesApi(String name) async {
    String url = 'Your Api';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return NewsHeadlinesModel.fromJson(body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<category_news_model> fetchcategorynewsApi(String category) async {
    String url = 'https://newsapi.org/v2/everything?q=${category}&your Api key';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return category_news_model.fromJson(body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
