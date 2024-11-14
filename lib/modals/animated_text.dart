class AnimatedText {
  final String heading;

  AnimatedText({required this.heading});

  factory AnimatedText.fromJson(Map<String, dynamic> json) {
    return AnimatedText(
      heading: json['heading'] ?? '',
    );
  }
}

class MessageModel {
  final List<AnimatedText> animatedText;

  MessageModel({required this.animatedText});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    var list = json['animatedtext'] as List;
    List<AnimatedText> animatedTextList =
        list.map((i) => AnimatedText.fromJson(i)).toList();
    return MessageModel(animatedText: animatedTextList);
  }
}
