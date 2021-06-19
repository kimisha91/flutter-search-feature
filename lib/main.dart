import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((s) async {
    runApp(WikipediaSearchApp());
  });
}
