import 'package:flutter/material.dart';
import 'package:wikipedia_search_demo_app/model/search_result_model.dart';
import 'package:wikipedia_search_demo_app/viewmodel/home_page_view_model.dart';

class SearchListItemView extends StatefulWidget {
  final SearchResult item;
  final HomePageViewModel viewModel;

  SearchListItemView({
    this.item,
    this.viewModel
  });

  @override
  _SearchListItemViewState createState() => _SearchListItemViewState();
}

class _SearchListItemViewState extends State<SearchListItemView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          widget.viewModel.selectedItemKey = widget.item.key;
          widget.viewModel.isSearchListItemSelected = true;
          Navigator.pop(context);
        },
        child: Column(
          children: <Widget>[
            Row(
              children: [
                _imageWidget(context),
                _searchTitleWidget(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 50,
        child: CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(getImageUrl()),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchTitleWidget(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.item.title}",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.item.description}",
              textAlign: TextAlign.start,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  String getImageUrl() {
    if (widget.item.thumbnail != null && widget.item.thumbnail.url.isNotEmpty)
      return 'https:' + widget.item.thumbnail.url;
    else
      return '';
  }

}

