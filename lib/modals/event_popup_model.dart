class EventPopupModel {
  final String status;
  final String message;
  final String imageUrl;

  EventPopupModel({
    required this.status,
    required this.message,
    required this.imageUrl,
  });

  factory EventPopupModel.fromJson(Map<String, dynamic> json) {
    return EventPopupModel(
      status: json['status'] as String,
      message: json['message'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'imageUrl': imageUrl,
    };
  }
}
