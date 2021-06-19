
class SearchDBModel{
  SearchDBModel({this.query,this.response});

  String query;
  String response;

  static final columns = ["query", "response", ];

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "query": query,
      "response": response,
    };
    return map;
  }

  static fromMap(Map map){
    SearchDBModel searchDB = new SearchDBModel();

    searchDB.query = map["query"];
    searchDB.response = map["response"];

    return searchDB;
  }

}