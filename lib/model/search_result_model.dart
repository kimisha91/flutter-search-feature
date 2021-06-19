
class SearchResultModel {
  SearchResultModel({
    this.pages,
  });

  List<SearchResult> pages;

  factory SearchResultModel.fromJson(Map<String, dynamic> json) => SearchResultModel(
    pages: json["pages"] == null ? null : List<SearchResult>.from(json["pages"].map((x) => SearchResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pages": pages == null ? null : List<dynamic>.from(pages.map((x) => x.toJson())),
  };
}

class SearchResult {
  SearchResult({
    this.id,
    this.key,
    this.title,
    this.excerpt,
    this.description,
    this.thumbnail,
  });

  int id;
  String key;
  String title;
  String excerpt;
  String description;
  Thumbnail thumbnail;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
    id: json["id"] == null ? null : json["id"],
    key: json["key"] == null ? null : json["key"],
    title: json["title"] == null ? null : json["title"],
    excerpt: json["excerpt"] == null ? null : json["excerpt"],
    description: json["description"] == null ? null : json["description"],
    thumbnail: json["thumbnail"] == null ? null : Thumbnail.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "title": title == null ? null : title,
    "excerpt": excerpt == null ? null : excerpt,
    "description": description == null ? null : description,
    "thumbnail": thumbnail == null ? null : thumbnail.toJson(),
  };
}

class Thumbnail {
  Thumbnail({
    this.mimetype,
    this.size,
    this.width,
    this.height,
    this.duration,
    this.url,
  });

  Mimetype mimetype;
  int size;
  int width;
  int height;
  dynamic duration;
  String url;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
    mimetype: json["mimetype"] == null ? null : mimetypeValues.map[json["mimetype"]],
    size: json["size"] == null ? null : json["size"],
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
    duration: json["duration"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "mimetype": mimetype == null ? null : mimetypeValues.reverse[mimetype],
    "size": size == null ? null : size,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
    "duration": duration,
    "url": url == null ? null : url,
  };
}

enum Mimetype { IMAGE_JPEG, IMAGE_SVG_XML, IMAGE_PNG, VIDEO_WEBM }

final mimetypeValues = EnumValues({
  "image/jpeg": Mimetype.IMAGE_JPEG,
  "image/png": Mimetype.IMAGE_PNG,
  "image/svg+xml": Mimetype.IMAGE_SVG_XML,
  "video/webm": Mimetype.VIDEO_WEBM
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
