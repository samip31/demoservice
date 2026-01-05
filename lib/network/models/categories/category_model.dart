class Category {
  final int categoryId;
  final String categoryTitle;
  final String categoryImg;

  Category({required this.categoryId, required this.categoryTitle, required this.categoryImg});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryTitle: json['categoryTitle'],
      categoryImg: json['categoryImg'],
    );
  }
}