import 'category.dart';

class Prayer {
  final List<Category> categories;

  Prayer({required this.categories});

  factory Prayer.fromJson(Map<String, dynamic> json) {
    return Prayer(
      categories: (json['data'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
    );
  }
}
