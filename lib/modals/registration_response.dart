class RegistrationResponse {
  final String message;
  final String type;

  RegistrationResponse({required this.message, required this.type});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      message: json['message'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
