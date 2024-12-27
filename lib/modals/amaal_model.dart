class AmaalData {
  final Map<String, dynamic> data;

  AmaalData({required this.data});

  factory AmaalData.fromJson(Map<String, dynamic> json) {
    return AmaalData(
      data: json['data'] as Map<String, dynamic>,
    );
  }
}

class Category {
  final String name;
  final Map<String, List<AmaalItem>>? subcategories;
  final List<AmaalItem>? items;

  Category({required this.name, this.subcategories, this.items});

  factory Category.fromJson(String name, dynamic json) {
    if (json is Map<String, dynamic>) {

      final subcategories = (json as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((item) => AmaalItem.fromJson(item)).toList(),
        ),
      );
      return Category(name: name, subcategories: subcategories);
    } else if (json is List<dynamic>) {

      final items = json.map((item) => AmaalItem.fromJson(item)).toList();
      return Category(name: name, items: items);
    } else {
      throw Exception('Invalid category structure');
    }
  }
}

class AmaalItem {
  final String category;
  final int id;
  final String title;
  final String data;

  AmaalItem({
    required this.category,
    required this.id,
    required this.title,
    required this.data,
  });

  factory AmaalItem.fromJson(Map<String, dynamic> json) {
    return AmaalItem(
      category: json['cat'] ?? '',
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      data: json['data'] ?? '',
    );
  }
}
