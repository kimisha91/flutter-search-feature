import 'package:dio/dio.dart';

import 'package:wikipedia_search_demo_app/services/api_service.dart';

class SearchRepository {
  final Dio dio;

  SearchRepository({this.dio});

  int pageLimit = 10;

  Future<Response> searchWiki({String query}) async {
    final req = {"q": query, "limit": pageLimit};
    Response response;

    try {
      response = await dio.get(dio.options.baseUrl + ApiService.SEARCH_WIKI_LIST,
          queryParameters: req);
      print(response);
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
    return response;
  }
}
