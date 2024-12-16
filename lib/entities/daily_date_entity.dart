
import 'package:realm/realm.dart';

part 'daily_date_entity.realm.dart';

@RealmModel()
class _DailyDateEntity {
  late String hijriDate;
  late String event;
  late String eventColor;
}