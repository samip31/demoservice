class Categories {
  int? categoryId;
  String? categoryTitle;
  dynamic categoryImg;

  Categories({this.categoryId, this.categoryTitle, this.categoryImg});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryTitle = json['categoryTitle'];
    categoryImg = json['categoryImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['categoryTitle'] = categoryTitle;
    data['categoryImg'] = categoryImg;
    return data;
  }
}
