class ApiResponseHandler {
  final Map<String, dynamic> data;

  ApiResponseHandler({required this.data});

  factory ApiResponseHandler.fromJson(Map<String, dynamic> json) {
    return ApiResponseHandler(data: parseData(json));
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

