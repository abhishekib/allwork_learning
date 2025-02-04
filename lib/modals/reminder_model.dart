class ReminderModel {
  final int id;
  final String title;
  final String scheduledTimeZone;
  final DateTime scheduledDateTime;

  ReminderModel(this.id, this.title, this.scheduledTimeZone, this.scheduledDateTime);
}
