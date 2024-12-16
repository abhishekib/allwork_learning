import 'package:realm/realm.dart';

part 'prayer_time_entity.realm.dart';

@RealmModel()
class _PrayerTimeEntity {
  late String fajr;
  late String sunrise;
  late String dhuhr;
  late String sunset;
  late String maghrib;
}
