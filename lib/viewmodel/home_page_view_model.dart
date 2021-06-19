import 'dart:async';
import 'dart:convert';
import 'package:stacked/stacked.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wikipedia_search_demo_app/database/search_db_helper.dart';
import 'package:wikipedia_search_demo_app/database/search_db_model.dart';
import 'package:wikipedia_search_demo_app/model/search_result_model.dart';
import 'package:wikipedia_search_demo_app/repository/search_repository.dart';

class HomePageViewModel extends BaseViewModel {
  SearchRepository searchRepository;
  StreamController<List<SearchResult>> wikiSearchList = StreamController<List<SearchResult>>.broadcast();

  Dio dio;
  SearchResultModel searchResultModel;
  bool _isSearchListItemSelected = false;
  String _selectedItemKey ='';
  SearchDBHelper dbHelper;

  bool get isSearchListItemSelected => _isSearchListItemSelected;

  set isSearchListItemSelected(bool isSearchListItemSelected) {
    _isSearchListItemSelected = isSearchListItemSelected;
    notifyListeners();
  }

  String get selectedItemKey => _selectedItemKey;

  set selectedItemKey(String selectedItemKey) {
    _selectedItemKey = selectedItemKey;
    notifyListeners();
  }

  int({Dio dio}) {
    this.dio = dio;
    searchRepository = new SearchRepository(dio: this.dio);
    dbHelper = SearchDBHelper();
  }

  fetchSuggestions(String searchQuery) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      await fetchSuggestionOnline(searchQuery);
    } else {
      setBusy(true);
      List<SearchDBModel> dbResponse = await dbHelper.getSearchResult();
      if (dbResponse != null && dbResponse.length > 0) {
        for (var i = 0; i < dbResponse.length; i++) {
          if (dbResponse[i].query == searchQuery) {
            searchResultModel = SearchResultModel.fromJson(jsonDecode(dbResponse[i].response));
            if (searchResultModel != null && searchResultModel.pages != null && searchResultModel.pages.length > 0)
              wikiSearchList.add(searchResultModel.pages);
            break;
          }else
            wikiSearchList.add(null);
        }
      }
      setBusy(false);
    }
  }

  fetchSuggestionOnline(String searchQuery) async{
    setBusy(true);
    try {
      final response = await searchRepository.searchWiki(query: searchQuery);
      if (response.statusCode == 200) {
        try {
          if(response.data!=null)
            performDBOperation(jsonResponse : response , searchQuery: searchQuery);
            searchResultModel = SearchResultModel.fromJson(response.data);
            wikiSearchList.add(searchResultModel.pages);
        } catch (e) {
          throw e;
        }
      }
    } on DioError catch (e) {
      print(e.error);
    }
    setBusy(false);
  }

  void performDBOperation({Response<dynamic> jsonResponse, String searchQuery}) async{
    SearchDBModel searchDB = new SearchDBModel(query: searchQuery,response: jsonResponse.toString());
    await dbHelper.insertSearchResult(searchDB);
  }
}
