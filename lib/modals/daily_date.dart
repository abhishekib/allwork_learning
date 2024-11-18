class DailyDate {
  String? hijriDate;
  String? event;
  String? eventColor;

  DailyDate({this.hijriDate, this.event, this.eventColor});

  factory DailyDate.fromJson(Map<String, dynamic> json) {
    return DailyDate(
      hijriDate: json['hijri_date'],
      event: json['event'],
      eventColor: json['event_color'],
    );
  }
}
