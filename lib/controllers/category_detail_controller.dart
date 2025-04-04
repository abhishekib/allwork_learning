import 'dart:developer';

import 'package:allwork/controllers/bookmark_controller.dart';
import 'package:allwork/controllers/deep_linking_controller.dart';
import 'package:allwork/controllers/favourite_controller.dart';
import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/services/local_notification_services.dart';
import 'package:allwork/views/login_view.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

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

  var copyArabic = false.obs;
  var copyTransliteration = false.obs;
  var copyTranslation = false.obs;

  final Rx<Duration> duration = Duration(hours: 0, minutes: 0).obs;

  final LoginController _loginController = Get.put(LoginController());
  final DeepLinkingController _deepLinkingController =
      Get.put(DeepLinkingController());

  List<String> selectedDaysForReminder = [];

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

  void toggleCopyOption(String option) {
    switch (option) {
      case 'Arabic':
        copyArabic.toggle();
        break;
      case 'Transliteration':
        copyTransliteration.toggle();
        break;
      case 'Translation':
        copyTranslation.toggle();
        break;
    }
  }

  void copySelectedLyricsToClipboard(BuildContext context,
      Map<String, List<Lyrics>> availableLyrics, String categoryTitle) {
    String combinedLyrics =
        '*${TextCleanerService.cleanText(categoryTitle)}*\n\n';
    Set<Lyrics> uniqueLyricsSet = {};

    for (var lyricsList in availableLyrics.values) {
      for (var lyrics in lyricsList) {
        uniqueLyricsSet.add(lyrics);
      }
    }

    for (var lyrics in uniqueLyricsSet) {
      if (lyrics.english != null &&
          lyrics.english!.trim() != '&nbsp' &&
          lyrics.english!.trim() != '') {
        combinedLyrics += '\n';
        combinedLyrics += '\n';
        combinedLyrics +=
            '* ${TextCleanerService.cleanText(lyrics.english!)} *\n';
      }
      if (copyArabic.isTrue &&
          lyrics.arabic.isNotEmpty &&
          lyrics.arabic != " ") {
        combinedLyrics += '${TextCleanerService.cleanText(lyrics.arabic)}\n';
      }
      if (copyTransliteration.isTrue &&
          lyrics.translitration != null &&
          lyrics.translitration!.isNotEmpty &&
          lyrics.translitration != " ") {
        combinedLyrics +=
            '${TextCleanerService.cleanText(lyrics.translitration).toUpperCase()}\n';
      }
      if (copyTranslation.isTrue &&
          lyrics.translation != " " &&
          lyrics.translation!.isNotEmpty) {
        combinedLyrics +=
            '${TextCleanerService.cleanText(lyrics.translation)}\n';
      }
    }
    combinedLyrics += '\n\n';
    combinedLyrics +=
        'Copied from: *MAFATI Ul JINAN* \n  https://mafatihuljinan.org/app';
    Clipboard.setData(ClipboardData(text: combinedLyrics));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected lyrics copied to clipboard!")));
  }

  // Method to toggle visibility
  void toggleArabicVisibility() => showArabic.value = !showArabic.value;
  void toggleTransliterationVisibility() =>
      showTransliteration.value = !showTransliteration.value;
  void toggleTranslationVisibility() =>
      showTranslation.value = !showTranslation.value;

  // Method to play or pause the audio
  void playPauseAudio() {
    //if (_audioPlayer.state == PlayerState.playing) {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      log("Audio paused");
    }
    //}
    else {
      _audioPlayer.play();
      //_audioPlayer.resume();
      log("Audio resumed");
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
    } else {
      log("No valid audio URL found in category data");
      isLoading.value = false;
    }
  }

  void changeType(String type) {
    selectedType.value = type;
    log("Changed selected type to: $type");
  }

  void bookmarkLyric(Category category, int lyricsType, int index) {
    log("Write bookmark");
    DbServices.instance.writeBookmark(category, lyricsType, index);
  }

  void removeBookmark(Category category, bool fromBookmark) {
    log("remove bookmark");
    DbServices.instance.deleteBookmark(category.title);
    if (fromBookmark) {
      Get.find<BookmarkController>().onInit();
    }
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

  void copyAmaalDataToClipboard(
      BuildContext context, String data, String title) {
    data = TextCleanerService.cleanText("$title \n\n ${data}");

    Clipboard.setData(ClipboardData(text: data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data copied to clipboard!")),
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

  void addToFavourite(BuildContext context, Category categoryDetails,
      String menuItem, bool isFavourite) async {
    try {
      final favouriteController = Get.find<FavouriteController>();

      int itemId = categoryDetails.id;
      log("$itemId");

      favouriteController.addToFavourite(menuItem, itemId);

      if (context.mounted) {
        if (!isFavourite) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Added to favorites!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Removed from favorites!")),
          );
        }
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

  void handleAddToFavourite(BuildContext context, Category categoryDetails,
      String menuItem, bool isFavourite) {
    if (_loginController.isLoggedIn.value) {
      addToFavourite(context, categoryDetails, menuItem, isFavourite);
    } else {
      showLoginPrompt(context);
    }
  }

  void scheduleNotification(Category category, Duration timeOfDay) {
    //log("Scheduling notification for: $date with title: $title");
    if (selectedDaysForReminder.isEmpty) {
      Get.dialog(AlertDialog(
        title: const Text("Error"),
        content: const Text("Please select at least one day for the reminder"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("OK"),
          ),
        ],
      ));
      return;
    }

//schedule notifications for the selected days
    for (String day in selectedDaysForReminder) {
      //get the exact dates and time when the reminders will be set
      DateTime nextDay = _getNextDay(day, timeOfDay);
      print("next day $nextDay");
      nextDay.add(timeOfDay);
      LocalNotificationServices.showScheduleNotification(
          category: category, dateTime: nextDay);
    }
  }

  String formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

//method to get the next Date of the week of the given day
  DateTime _getNextDay(String day, Duration timeOfDay) {
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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

    return now
        .add(Duration(days: daysUntilSameDay, minutes: timeOfDay.inMinutes));
  }

  void tapDeepLink(String url) {
    _deepLinkingController.handleDeepLink(url);
  }
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