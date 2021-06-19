
import 'package:flutter/material.dart';
import 'package:wikipedia_search_demo_app/delegate/search_app_bar_delegate.dart';
import 'package:wikipedia_search_demo_app/services/api_service.dart';
import 'package:wikipedia_search_demo_app/viewmodel/home_page_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  final Dio dio;
  HomePage({Key key,this.dio}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final globalKey = new GlobalKey<ScaffoldState>();

  Icon appBarIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  Widget appBarTitle = Text("WIKIPEDIA",style: TextStyle(color: Colors.white),);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePageViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.int(dio: widget.dio);
        },
        builder: (context, viewModel, child) => Scaffold(
            appBar: buildAppBarWidget(context , viewModel),
            body: viewModel.isSearchListItemSelected
                ? _loadSelectedSearchData(viewModel)
                : Container()),
        viewModelBuilder: () => HomePageViewModel(),
        disposeViewModel: true,
        initialiseSpecialViewModelsOnce: true);
  }

  Widget buildAppBarWidget(BuildContext context, HomePageViewModel homePageViewModel) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: appBarIcon,
          onPressed: () {
            homePageViewModel.selectedItemKey = '';
            homePageViewModel.isSearchListItemSelected = false;
            showSearch(
                context: context,
                delegate: SearchAppBarDelegate(viewModel: homePageViewModel ));
          },
        )
      ],
    );
  }

  Widget _loadSelectedSearchData(HomePageViewModel viewModel) {
    return WebView(
      initialUrl: getSearchWebViewUrl(viewModel),
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  String getSearchWebViewUrl(HomePageViewModel viewModel) {
    if (viewModel.selectedItemKey.isNotEmpty)
      return widget.dio.options.baseUrl +
          ApiService.SEARCH_WIKI_DETAIL(viewModel.selectedItemKey);
    else
      return '';
  }
}