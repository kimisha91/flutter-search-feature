import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wikipedia_search_demo_app/database/search_db_model.dart';

class SearchDBHelper {
  static Database _db;
  static const String ID = 'query';
  static const String RESPONSE = 'response';
  static const String TABLE = 'Search';
  static const String DB_NAME = 'search.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $RESPONSE TEXT)");
  }

  Future<SearchDBModel> insertSearchResult(SearchDBModel searchDB) async{
    var dbClient = await db;
    var count = Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $TABLE WHERE response = ?", [searchDB.response]));
    if(count == 0){
      await dbClient.insert(TABLE, searchDB.toMap());
    } else {
      await dbClient.update(TABLE, searchDB.toMap(), where: "query = ?", whereArgs: [searchDB.query]);
    }
    return searchDB;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<List<SearchDBModel>> getSearchResult() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, RESPONSE]);
    List<SearchDBModel> searchResult = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        searchResult.add(SearchDBModel.fromMap(maps[i]));
      }
    }
    return searchResult;
  }
}
