class EventPopupModel {
  final String? type;
  final String? title;
  final String? imageUrl;
  final String? message;

  EventPopupModel({
    this.type,
    this.title,
    this.imageUrl,
    this.message,
  });

  factory EventPopupModel.fromJson(Map<String, dynamic> json) {
    return EventPopupModel(
      type: json['type'] as String?,
      title: json['title'] as String?,
      imageUrl: json['imgurl'] as String?,
      message: json['msg'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type ?? '',
      'title': title ?? '',
      'imgurl': imageUrl ?? '',
      'msg': message ?? '',
    };
  }

  bool get isEventAvailable =>
      type == 'success' && imageUrl != null && imageUrl!.isNotEmpty;
}
