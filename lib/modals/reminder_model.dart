import 'package:flutter/material.dart';

class ReminderModel {
  final int id;
  final String title;
  final DateTime scheduledDateTime;

  ReminderModel(this.id, this.title, this.scheduledDateTime);
}
