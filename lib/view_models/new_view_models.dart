import 'package:news_app/models/NewsHeadlinesModel.dart';
import 'package:news_app/repository/news_repository.dart';

import '../models/catgory_news_model.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsHeadlinesModel> fetchNewsChannelHeadLinesApi(String name) async {
    final response = await _rep.fetchNewsChannelHeadLinesApi(name);
    return response;
  }

  Future<category_news_model> fetchcategorynewsApi(String category) async {
    final response = await _rep.fetchcategorynewsApi(category);
    return response;
  }
}
