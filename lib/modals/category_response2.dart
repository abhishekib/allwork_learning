import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/category_response.dart';

class CategoryResponse2 {
  Map<String, CategoryResponse> ziyarat14Masoomeen;
  CategoryResponse otherZiyarats;

  CategoryResponse2(
      {required this.ziyarat14Masoomeen, required this.otherZiyarats});

// Factory method for parsing JSON data
  factory CategoryResponse2.fromJson(Map<String, dynamic> json) {
    // Create a temporary Map to store the SubMenuDetails parsed from JSON
    Map<String, CategoryResponse> tempZiyarat14Masoomeen = {};
    late CategoryResponse tempOtherZiyarats;
    // Loop through each entry in the JSON object
    json.forEach((key, value) {
      if (value is Map) {
        tempZiyarat14Masoomeen[key] = CategoryResponse.fromJsonDynamic(value);
      }
      if (value is List) {
        Map<String, dynamic> entry = {};
        entry['Other Ziyarats'] = value;
        tempOtherZiyarats = CategoryResponse.fromJson(entry);
      }
    });

    return CategoryResponse2(
        ziyarat14Masoomeen: tempZiyarat14Masoomeen,
        otherZiyarats: tempOtherZiyarats);
  }

  @override
  String toString() {
    return ziyarat14Masoomeen.toString();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['Ziyarat 14 Masoomeen'] = ziyarat14Masoomeen;
    map['Other Ziyarats'] = otherZiyarats;
    return map;
  }

  Map<String, Map<String, List<Category>>> getZiyarat14Masoomeen() {
    Map<String, Map<String, List<Category>>> map = {};
    ziyarat14Masoomeen.forEach((key, value) {
      map[key] = value.toMap();
    });
    return map;
  }
}
