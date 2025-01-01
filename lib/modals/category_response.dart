import 'package:allwork/modals/category.dart';

class CategoryResponse {
  final String country;
  final Map<String, List<Category>>? cityCategories;
  final List<Category>? standaloneCategories;

  CategoryResponse({
    required this.country,
    this.cityCategories,
    this.standaloneCategories,
  });

  factory CategoryResponse.fromJson(String country, dynamic json) {
    if (json is Map<String, dynamic>) {
      final cityCategories = json.map((key, value) {
        return MapEntry(
          key,
          (value as List<dynamic>? ?? [])
              .map((item) => Category.fromJson(item))
              .toList(),
        );
      });
      return CategoryResponse(country: country, cityCategories: cityCategories);
    } else if (json is List<dynamic>) {
      final categories = json.map((item) => Category.fromJson(item)).toList();
      return CategoryResponse(
          country: country, standaloneCategories: categories);
    } else {
      throw Exception('Unexpected data format');
    }
  }

  // @override
  // String toString() {
  //   return "Country : $country,/n City Categories $cityCategories,/n Stand Alone Categories $standaloneCategories";
  // }
}
