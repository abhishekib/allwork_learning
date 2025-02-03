import 'dart:core';
import 'dart:developer';
import 'package:allwork/modals/category.dart';
import 'package:allwork/services/db_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Handles local notifications functionality for the application.
class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static int i = 1;
  // Channel IDs for different notification types
  static const String _simpleChannelId = 'simple_channel';
  static const String _scheduledChannelId = 'scheduled_channel';

  /// Initializes the local notifications plugin and requests necessary permissions.
  static Future<void> init() async {
    // Initialize timezone data first
    tz.initializeTimeZones();

    log(await FlutterTimezone.getLocalTimezone());

    String timeZone = await FlutterTimezone.getLocalTimezone();
    if (timeZone == 'Asia/Calcutta') {
      timeZone = 'Asia/Kolkata';
    }
    tz.setLocalLocation(tz.getLocation(timeZone)); // Set your local time zone

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    // Request Android notification permissions
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();

    // Initialize with callback for handling notification taps
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification clicked with payload: ${response.payload}');
      },
    );
  }

  /// Shows an immediate notification
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _simpleChannelId,
        'Simple Notifications',
        channelDescription: 'Channel for immediate notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      ),
    );

    await _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Schedules a notification to be shown after a specific delay
  static Future<void> showScheduleNotification({
    required Category category,
    required DateTime dateTime,
    required String payload,
  }) async {
    // Cancel any existing scheduled notifications first
    //await _notificationsPlugin.cancel(1);

    final notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        _scheduledChannelId,
        'Scheduled Notifications',
        channelDescription: 'Channel for scheduled notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        // Add these to ensure the notification shows up
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
      ),
    );

    // Calculate the schedule time
    final scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

    try {
      await _notificationsPlugin.zonedSchedule(
        i,
        category.title,
        "reminder for ${category.title}",
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      log("Notification scheduled for: $scheduledTime");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(
          'totalNotifications', (prefs.getInt('totalNotifications') ?? 0) + 1);

      DbServices.instance
          .writeReminder(category, tz.local.toString(), scheduledTime);

      // final pendingNotifications =
      //     await _notificationsPlugin.pendingNotificationRequests();
      // log("Pending notifications count: ${pendingNotifications.length}");
    } catch (e) {
      log("Error scheduling notification: $e");
    }
  }
}

/// Handles platform-specific method channel calls
class PlatformChannel {
  static const MethodChannel _channel =
      MethodChannel('com.mafatihuljinan/settings');

  static Future<void> openAppSettings() async {
    try {
      await _channel.invokeMethod('openAppSettings');
    } on PlatformException catch (e) {
      log('Failed to open app settings: ${e.message}');
    }
  }
}
