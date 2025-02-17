import 'dart:developer';
import 'package:allwork/controllers/bookmark_controller.dart';
import 'package:allwork/controllers/favourite_controller.dart';
import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/services/local_notification_services.dart';
import 'package:allwork/views/login_view.dart';
import 'package:day_picker/model/day_in_week.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

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

  final LoginController _loginController = Get.put(LoginController());

  List<String> selectedDaysForReminder = [];

  final List<DayInWeek> days = [
    DayInWeek("Mo", dayKey: "monday"),
    DayInWeek("Tu", dayKey: "tuesday"),
    DayInWeek("We", dayKey: "wednesday"),
    DayInWeek("Th", dayKey: "thursday"),
    DayInWeek("Fr", dayKey: "friday"),
    DayInWeek("Sa", dayKey: "saturday"),
    DayInWeek("Su", dayKey: "sunday"),
  ];
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

  void scheduleNotification(
      Category category, DateTime dateTime, String title) {
    //log("Scheduling notification for: $date with title: $title");
    LocalNotificationServices.showScheduleNotification(
        category: category, dateTime: dateTime);

    // LocalNotifications.showPeriodicNotifications(
    //     title: title, body: "Body", payload: "payload");
  }

  void bookmarkLyric(Category category, int lyricsType, int index) {
    log("Write bookmark");
    DbServices.instance.writeBookmark(category, lyricsType, index);
  }

  void removeBookmark(Category category) {
    log("remove bookmark");
    DbServices.instance.deleteBookmark(category.title);
    Get.find<BookmarkController>().onInit();
  }

  void copyAllLyricsToClipboard(BuildContext context,
      Map<String, List<Lyrics>> availableLyrics, String categoryTitle) {
    final allLyrics =
        availableLyrics.values.expand((lyricsList) => lyricsList).toList();

    Set<Lyrics> uniqueLyricsSet = {};

    for (var lyrics in allLyrics) {
      uniqueLyricsSet.add(lyrics);
    }

    String combinedLyrics =
        '${TextCleanerService.cleanText(categoryTitle)}\n\n';

    for (var lyrics in uniqueLyricsSet) {
      combinedLyrics += '${TextCleanerService.cleanText(lyrics.arabic)}\n';
      combinedLyrics +=
          '${TextCleanerService.cleanText(lyrics.translitration)}\n\n';
      combinedLyrics += '${TextCleanerService.cleanText(lyrics.translation)}\n';
    }

    Clipboard.setData(ClipboardData(text: combinedLyrics));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All lyrics copied to clipboard!")),
    );
  }

  void showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Required"),
          content: const Text("Please log in to add this item to favorites."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Get.to(() => LoginView()); // Navigate to login screen
              },
              child: const Text("Login"),
            ),
          ],
        );
      },
    );
  }

  void addToFavourite(
      BuildContext context, Category categoryDetails, String menuItem) async {
    try {
      final favouriteController = Get.find<FavouriteController>();

      int itemId = categoryDetails.id;
      log("$itemId");

      await favouriteController.addToFavourite(menuItem, itemId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to favorites!")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding to favorites: $e")),
        );
      }
      log("$e");
    }
  }

  void handleAddToFavourite(
      BuildContext context, Category categoryDetails, String menuItem) {
    if (_loginController.isLoggedIn.value) {
      addToFavourite(context, categoryDetails, menuItem);
    } else {
      showLoginPrompt(context);
    }
  }

  void setSelectedTimeForReminders(TimeOfDay timeOfDay, Category categoryDetails) {
    DateTime baseDateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, timeOfDay.hour, timeOfDay.minute);

//schedule notifications for the selected days
    for (String day in selectedDaysForReminder) {
      //get the exact dates and time when the reminders will be set
      DateTime nextDay = _getNextDay(day, baseDateTime);
     LocalNotificationServices.showScheduleNotification(
          category:categoryDetails, dateTime: nextDay);
    }
  }

//method to get the next Date of the week of the given day
  DateTime _getNextDay(String day, DateTime baseDateTime) {
    DateTime now = DateTime.timestamp();
    int daysUntilSameDay = 0;

    switch (day) {
      case "monday":
        daysUntilSameDay = DateTime.monday - now.weekday;
        break;
      case "tuesday":
        daysUntilSameDay = DateTime.tuesday - now.weekday;
        break;
      case "wednesday":
        daysUntilSameDay = DateTime.wednesday - now.weekday;
        break;
      case "thursday":
        daysUntilSameDay = DateTime.thursday - now.weekday;
        break;
      case "friday":
        daysUntilSameDay = DateTime.friday - now.weekday;
        break;
      case "saturday":
        daysUntilSameDay = DateTime.saturday - now.weekday;
        break;
      case "sunday":
        daysUntilSameDay = DateTime.sunday - now.weekday;
        break;
      default:
        log("Error day value");
        return now;
    }

    if (daysUntilSameDay <= 0) {
      daysUntilSameDay += 7;
    }

    return now.add(Duration(days: daysUntilSameDay));
  }

  // final String? initialAudioUrl = isAudioDownloaded
  //     ? cdata[0].offlineAudioPath!
  //     : cdata[0].audiourl.isNotEmpty
  //         ? cdata[0].audiourl
  //         : null;

  //   currentContentDataId = cdata![0].id ?? 0;

  //   currentAudioUrl = initialAudioUrl;

  //   log("initial Audio Url $currentAudioUrl");

  //   _tabController.addListener(() {
  //     final selectedIndex = _tabController.index;
  //     log("selected index $selectedIndex");
  //     final String? newAudioUrl = cdata[selectedIndex].offlineAudioPath != null
  //         ? cdata[selectedIndex].offlineAudioPath!
  //         : cdata[selectedIndex].audiourl.isNotEmpty
  //             ? cdata[selectedIndex].audiourl
  //             : null;

  //     if (newAudioUrl != currentAudioUrl && newAudioUrl!.isNotEmpty) {
  //       setState(() {
  //         currentAudioUrl = newAudioUrl;
  //       });
  //       Get.find<CategoryDetailController>().initializeAudio(newAudioUrl);
  //     }
  //   });
  //   log("---You are in CategoryDetailView---");
  // }

  // void _shareAllLyrics(BuildContext context,
  //     Map<String, List<Lyrics>> availableLyrics, String categoryTitle) {
  //   final allLyrics =
  //       availableLyrics.values.expand((lyricsList) => lyricsList).toList();

  //   Set<Lyrics> uniqueLyricsSet = {};

  //   for (var lyrics in allLyrics) {
  //     uniqueLyricsSet.add(lyrics);
  //   }

  //   String combinedLyrics =
  //       '${TextCleanerService.cleanText(categoryTitle)}\n\n';

  //   for (var lyrics in uniqueLyricsSet) {
  //     combinedLyrics += '${TextCleanerService.cleanText(lyrics.arabic)}\n';
  //     combinedLyrics +=
  //         '${TextCleanerService.cleanText(lyrics.translitration)}\n\n';
  //     combinedLyrics +=
  //         '${TextCleanerService.cleanText(lyrics.translation)}\n\n';
  //   }

  //   Share.share(combinedLyrics, subject: categoryTitle);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Sharing lyrics...")),
  //   );
  // }
}
