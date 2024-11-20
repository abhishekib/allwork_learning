class PrayerTimeModel {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String sunset;
  final String maghrib;

  PrayerTimeModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.sunset,
    required this.maghrib,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      fajr: json['Fajr'] ?? '',
      sunrise: json['Sunrise'] ?? '',
      dhuhr: json['Dhuhr'] ?? '',
      sunset: json['Sunset'] ?? '',
      maghrib: json['Maghrib'] ?? '',
    );
  }
}
