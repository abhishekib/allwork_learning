class Lyrics {
  final String time;
  final String arabic;
  final String transliteration;
  final String translation;

  Lyrics({
    required this.time,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(
      time: json['time'] ?? '',
      arabic: json['arabic'] ?? '',
      transliteration: json['translitration'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}
