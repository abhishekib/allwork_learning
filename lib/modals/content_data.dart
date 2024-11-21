class ContentData {
  final String type;
  final String audiourl;
  final List<Lyrics> lyrics;

  ContentData({
    required this.type,
    required this.audiourl,
    required this.lyrics,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      type: json['type'] ?? '',
      audiourl: json['audiourl'] ?? '',
      lyrics: (json['lyrics'] as List)
          .map((data) => Lyrics.fromJson(data))
          .toList(),
    );
  }
}

class Lyrics {
  final String time;
  final String arabic;
  final String translitration;
  final String translation;

  Lyrics({
    required this.time,
    required this.arabic,
    required this.translitration,
    required this.translation,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    // Check if the keys are in English or Gujarati
    bool isGujarati = json.containsKey('અરબી');

    return Lyrics(
      time: json['time'] ?? '',
      arabic: isGujarati ? json['અરબી'] ?? '' : json['arabic'] ?? '',
      translitration:
          isGujarati ? json['તરજુમા'] ?? '' : json['translitration'] ?? '',
      translation:
          isGujarati ? json['ગુજરાતી'] ?? '' : json['translation'] ?? '',
    );
  }
}
