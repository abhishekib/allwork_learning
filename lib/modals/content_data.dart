import 'lyrics.dart';

class ContentData {
  final String type;
  final String audioUrl;
  final List<Lyrics> lyrics;
  final bool isLrc;

  ContentData({
    required this.type,
    required this.audioUrl,
    required this.lyrics,
    required this.isLrc,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      type: json['type'] ?? '',
      audioUrl: json['audiourl'] ?? '',
      lyrics: (json['lyrics'] as List)
          .map((lyric) => Lyrics.fromJson(lyric))
          .toList(),
      isLrc: json['islrc'] ?? false,
    );
  }
}
