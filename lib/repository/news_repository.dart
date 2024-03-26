import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:news_app/models/NewsHeadlinesModel.dart';
class NewsRepository {
  Future<NewsHeadlinesModel> fetchNewsChannelHeadLinesApi() async{
    String url = 'https://newsapi.org/v2/top-headlines?country=in&apiKey=92a9e35f6b6f42fba5fdf9f8de8fbd84';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }
}