class ContentData {
  final int? id;
  final String type;
  final String audiourl;
  final String? offlineAudioPath;
  final List<Lyrics> lyrics;

  ContentData({
    this.id,
    required this.type,
    required this.audiourl,
    this.offlineAudioPath,
    required this.lyrics,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    List<dynamic> lyricsList = [];
    if (json.containsKey('lyrics') && json['lyrics'] != null) {
      lyricsList = json['lyrics'] as List;
    }
    return ContentData(
      type: json['type'] ?? '',
      audiourl: json['audiourl'] ?? '',
      lyrics: lyricsList.map((data) => Lyrics.fromJson(data)).toList(),
    );
  }

  @override
  String toString() {
    return "type $type, audiourl $audiourl, lyrics $lyrics";
  }
}

class Lyrics {
  final String time;
  final String arabic;
  final String translitration;
  final String translation;
  String? english;

  Lyrics({
    required this.time,
    required this.arabic,
    required this.translitration,
    required this.translation,
    this.english,
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
      english: json['english'] ?? '',
    );
  }

  // Implement equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Lyrics &&
        other.arabic == arabic &&
        other.translitration == translitration &&
        other.translation == translation;
  }

  @override
  String toString() {
    return "time: $time, arabic $arabic, transliteration $translitration, translation $translation";
  }

  // Implement hashCode
  @override
  int get hashCode =>
      arabic.hashCode ^ translitration.hashCode ^ translation.hashCode;
}
