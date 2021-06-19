import 'package:dio/dio.dart';

class Application {
  static Application _instance;
  Dio dio;

  Application({
    this.dio,
  });

  static Future<Application> get instance async {
    return await Application()._getInstance();
  }

  Future<Application> _getInstance() async {
    if (_instance == null) {
      dio = Dio();

      dio.options
        ..baseUrl = "https://en.wikipedia.org/"
        ..contentType = "application/json";
    }

    return _instance;
  }
}
