import 'dart:developer';
import 'package:allwork/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:timezone/timezone.dart';

class CategoryDetailController extends GetxController {
  // Audio Player Instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Observables for time tracking
  var currentTime = 0.0.obs;
  var totalTime = 0.0.obs;

  // Observables for managing the state
  var isLoading = true.obs;
  var selectedType = 'Arabic'.obs;

  var lyricsList = <Map<String, dynamic>>[].obs;

  // Observables for visibility toggles
  var showArabic = true.obs;
  var showTransliteration = true.obs;
  var showTranslation = true.obs;

  get audioPlayer => _audioPlayer;

  @override
  void onInit() {
    super.onInit();
    log("CategoryDetailController initialized");
  }

  void onReset() {
    currentTime = 0.0.obs;
    totalTime = 0.0.obs;
  }

  @override
  void onClose() {
    super.onClose();
    _audioPlayer.dispose();
    currentTime.close();
    totalTime.close();
    log("Audio player disposed");
  }

  // Method to toggle visibility
  void toggleArabicVisibility() => showArabic.value = !showArabic.value;
  void toggleTransliterationVisibility() =>
      showTransliteration.value = !showTransliteration.value;
  void toggleTranslationVisibility() =>
      showTranslation.value = !showTranslation.value;

  // Method to play or pause the audio
  void playPauseAudio() {
    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.pause();
      log("Audio paused");
    } else {
      _audioPlayer.resume();
      log("Audio resumed");
    }
  }

  // Method to seek to a specific position in the audio
  void seekTo(double position) {
    _audioPlayer.seek(Duration(seconds: position.toInt()));
    log("Audio seeked to position: ${position.toInt()} seconds");
  }

  // Method to initialize and load the audio from URL
  Future<void> initializeAudio(String audioUrl) async {
    try {
      if (audioUrl.isEmpty) return;

      log("Attempting to load audio from URL: $audioUrl");
      await _audioPlayer.stop();
      await _audioPlayer.setSource(UrlSource(audioUrl));

      log("Audio successfully loaded");

      _audioPlayer.onDurationChanged.listen((duration) {
        log("Audio duration changed: ${duration.inMilliseconds} ms");
        totalTime.value = duration.inSeconds.toDouble();
      });

      _audioPlayer.onPositionChanged.listen((position) {
        log("Current audio position: ${position.inMilliseconds} ms");
        currentTime.value = position.inSeconds.toDouble();
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        log("Audio playback completed");
        currentTime.value = 0.0;
        isLoading.value = false;
      });

      isLoading.value = false;
    } catch (e) {
      // Handle any errors here
      log('Error initializing audio: $e');
      isLoading.value = false;
    }
  }

  void loadCategoryData(List<dynamic> cdata) {
    isLoading(true);

    log("Loading category data...");

    lyricsList.value =
        cdata.map((item) => item as Map<String, dynamic>).toList();

    log("Loaded ${lyricsList.length} lyrics items");

    // Initialize the audio with the first available audio URL
    if (cdata.isNotEmpty && cdata[0]['audiourl'] != null) {
      log("Initializing audio with URL: ${cdata[0]['audiourl']}");
      initializeAudio(cdata[0]['audiourl']);
    } else {
      log("No valid audio URL found in category data");
      isLoading.value = false;
    }
  }

  void changeType(String type) {
    selectedType.value = type;
    log("Changed selected type to: $type");
  }

  Future<void> scheduleNotification(DateTime date, String title) async {
    log("Scheduling notification for: $date with title: $title");

    final DateTime scheduledDateTime =
        DateTime.now().add(Duration(seconds: 10)); // 10 seconds later

    final TZDateTime timezoneScheduledDateTime = TZDateTime.local(
        scheduledDateTime.year,
        scheduledDateTime.month,
        scheduledDateTime.day,
        scheduledDateTime.hour,
        scheduledDateTime.minute);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'general_notifications', // Channel ID (used to reference the notification channel)
      'General Notifications', // Channel Name (used to display the channel name in the system)
      channelDescription:
          'Notifications for reminders', // Channel description (helpful for understanding the purpose of this channel)
      importance: Importance
          .high, // Set the importance level of the notification (options: low, default, high)
      priority: Priority
          .high, // Set the priority of the notification (options: low, default, high)
      ticker:
          'ticker', // Optional: Ticker text (this text is shown briefly when the notification is delivered)
      playSound:
          true, // Optional: To play a sound when the notification is triggered
      largeIcon: DrawableResourceAndroidBitmap(
          'app_icon'), // Optional: Add a large icon to the notification
      // Other customizations (e.g., vibration pattern, lights) can be set here as well
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Scheduling a notification to be triggered in 10 seconds
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // notification ID
      'Scheduled Notification', // Title
      'This notification was scheduled!', // Body
      timezoneScheduledDateTime, // Time to show the notification
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.inexact,
    );

    log('Notification scheduled at: ${scheduledDateTime.toString()}');
  }
}
