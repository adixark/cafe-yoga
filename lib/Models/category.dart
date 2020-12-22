class Category {
  int parent;
  int categoryId;
  String categoryName;
  String categoryDesc;
  Image image;

  Category(
      {this.categoryDesc,
      this.categoryId,
      this.categoryName,
      this.image,
      this.parent});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['id'];
    categoryName = json['name'];
    categoryDesc = json['description'];
    parent = json['parent'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }
}

class Image {
  String url;

  Image({this.url});
  Image.fromJson(Map<String, dynamic> json) {
    url = json["src"];
  }
}
