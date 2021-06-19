import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'application.dart';
import 'views/home_page.dart';

Application _application;

Application get application => _application;

set _appObj(ap) {
  _application = ap;
}

class WikipediaSearchApp extends StatefulWidget {
  @override
  _WikipediaSearchAppState createState() => _WikipediaSearchAppState();
}

class _WikipediaSearchAppState extends State<WikipediaSearchApp>
    with WidgetsBindingObserver {
  Dio dio;

  @override
  void initState() {
    init();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  init() async {
    dio = Dio();
    dio.options
      ..baseUrl = "https://en.wikipedia.org/"
      ..contentType = "application/json";

    _appObj = Application(
      dio: dio,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Search Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HomePage(dio: dio,),
    );
  }
}
