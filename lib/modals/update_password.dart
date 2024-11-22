class UpdatePassword {
  String message;
  String type;

  UpdatePassword({required this.message, required this.type});

  factory UpdatePassword.fromJson(Map<String, dynamic> json) {
    return UpdatePassword(
      message: json['msg'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
