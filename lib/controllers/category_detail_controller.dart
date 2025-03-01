import 'dart:developer';
import 'package:allwork/modals/category.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/services/local_notifications.dart';
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

  void scheduleNotification(Category category, DateTime dateTime, String title) {
    //log("Scheduling notification for: $date with title: $title");
    LocalNotifications.showScheduleNotification(category: category,
        dateTime: dateTime, payload: "payload");
    // LocalNotifications.showPeriodicNotifications(
    //     title: title, body: "Body", payload: "payload");
  }

  void bookmarkCategoryListDetail(Category category, int lyricsType, int index) {
    log("Write bookmark");
    DbServices.instance.writeBookmark(category, lyricsType, index);
  }
}
