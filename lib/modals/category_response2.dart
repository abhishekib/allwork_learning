import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/category_response.dart';

class CategoryResponse2 {
  Map<String, CategoryResponse> subMenuDetails;

//Map<String, Map<String, List<Category>>>

  CategoryResponse2({required this.subMenuDetails});

// Factory method for parsing JSON data
  factory CategoryResponse2.fromJson(Map<String, dynamic> json) {
    // Create a temporary Map to store the SubMenuDetails parsed from JSON
    Map<String, CategoryResponse> tempSubMenuDetails = {};

    // Loop through each entry in the JSON object
    json.forEach((key, value) {
      if (value is Map) {
        tempSubMenuDetails[key] = CategoryResponse.fromJsonDynamic(value);
      }
    });

    return CategoryResponse2(subMenuDetails: tempSubMenuDetails);
  }

  @override
  String toString() {
    return subMenuDetails.toString();
  }
}
