import 'package:news_app/models/NewsHeadlinesModel.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();


  Future<NewsHeadlinesModel> fetchNewsChannelHeadLinesApi()async{
    final response = await _rep.fetchNewsChannelHeadLinesApi();
    return response;
  }
}