import 'package:realm/realm.dart';
part 'reminder_entity.realm.dart';

@RealmModel()
class _ReminderEntity {
  @PrimaryKey()
  late int id;

  late String title;
  late DateTime createdAt;
  late String scheduledTimeZone;
  late DateTime scheduledAt;
}
