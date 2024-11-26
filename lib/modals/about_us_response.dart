class AboutUsResponse {
  final String data;

  AboutUsResponse({required this.data});

  factory AboutUsResponse.fromJson(Map<String, dynamic> json) {
    return AboutUsResponse(
      data: json['data'] ?? '',
    );
  }
}