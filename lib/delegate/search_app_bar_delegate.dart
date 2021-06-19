import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wikipedia_search_demo_app/model/search_result_model.dart';
import 'package:wikipedia_search_demo_app/viewmodel/home_page_view_model.dart';
import 'package:wikipedia_search_demo_app/views/search_list_item_view.dart';

class SearchAppBarDelegate extends SearchDelegate<SearchResult>
    with RouteAware {
  final HomePageViewModel viewModel;

  @override
  String get searchFieldLabel => "Search Wikipedia";

  SearchAppBarDelegate({this.viewModel});

  final _debouncer = Debouncer(milliseconds: 200);

  // @override
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        query = '';
        viewModel?.searchResultModel?.pages?.clear();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      viewModel?.searchResultModel?.pages?.clear();
    }
    _performSearchOperation();
    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        StreamBuilder<List<SearchResult>>(
          stream: viewModel.wikiSearchList.stream,
          builder: (context, AsyncSnapshot<List<SearchResult>> snapshot) {
            if (viewModel.isBusy) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                        margin: const EdgeInsets.only(top: 10),
                      )),
                ],
              );
            } else if (viewModel.wikiSearchList==null || viewModel?.searchResultModel != null &&
                viewModel?.searchResultModel?.pages != null &&
                viewModel?.searchResultModel?.pages?.length == 0) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    "No Results Found.",
                  ),
                ),
              );
            } else {
              if (viewModel?.searchResultModel != null &&
                  viewModel?.searchResultModel?.pages != null &&
                  viewModel.searchResultModel.pages.length > 0) {
                var results = viewModel?.searchResultModel?.pages;
                return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: results.length,
                        itemBuilder: (context, i) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.1,
                                child: SearchListItemView(
                                  item: results[i],
                                  viewModel: viewModel,
                                ),
                              ),
                            ),
                          );
                        }));
              } else
                return Container();
            }
          },
        ),
      ],
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.only(right: 14.0),
              child: FlatButton(
                shape: CircleBorder(),
                padding: const EdgeInsets.only(top: 4),
                onPressed: () {
                  query = '';
                  viewModel?.searchResultModel?.pages?.clear();
                  showSuggestions(context);
                },
                child: IconButton(
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ],
        ),
      )
          : Container(),
    ];
  }

  _performSearchOperation() {
    _debouncer.run(() {
      if (this.query.length > 2) {
        viewModel.fetchSuggestions(query);
      }
    });
  }
}
class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

