import 'package:allwork/modals/category.dart';

class ApiResponseHandler {
  final Map<String, dynamic> data;
  final int? totalPages;
  final List<Category>? posts;

  ApiResponseHandler({required this.data, this.totalPages, this.posts});

  factory ApiResponseHandler.fromJson(Map<String, dynamic> json) {
    final isSearchResponse = json['data'] is List<dynamic>;
    // return ApiResponseHandler(data: parseData(json));
    return ApiResponseHandler(
      data: parseData(json),
      posts: isSearchResponse
          ? (json['data'] as List<dynamic>? ?? [])
              .map((item) => Category.fromJson(item))
              .toList()
          : null,
    );
  }

  static dynamic parseData(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value.map((key, subValue) => MapEntry(key, parseData(subValue)));
    } else if (value is List) {
      return value.map((item) => parseData(item)).toList();
    } else {
      return value; // Return primitive values as is
    }
  }

  @override
  String toString() {
    return data.toString();
  }
}
