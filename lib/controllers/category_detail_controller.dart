import 'dart:developer';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart'; // Updated import to use audioplayers

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

  get audioPlayer => _audioPlayer;

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _audioPlayer.dispose();
  }

  // Method to play or pause the audio
  void playPauseAudio() {
    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
  }

  // Method to seek to a specific position in the audio
  void seekTo(double position) {
    _audioPlayer.seek(Duration(seconds: position.toInt()));
  }

  // Method to initialize and load the audio from URL
  Future<void> initializeAudio(String audioUrl) async {
    try {
      await _audioPlayer.setSourceUrl(
          audioUrl); // Changed to setSourceUrl to load audio without autoplay

      _audioPlayer.onDurationChanged.listen((duration) {
        totalTime.value = duration.inSeconds.toDouble();
      });

      _audioPlayer.onPositionChanged.listen((position) {
        currentTime.value = position.inSeconds.toDouble();
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        currentTime.value = 0.0;
        isLoading.value = false;
      });
    } catch (e) {
      // Handle any errors here
      log('Error initializing audio: $e');
      isLoading.value = false;
    }
  }

  void loadCategoryData(List<dynamic> cdata) {
    isLoading(true); // Set loading state to true

    // Extract lyrics data from cdata and set it to lyricsList
    log("cat det cont----> started");
    lyricsList.value =
        cdata.map((item) => item as Map<String, dynamic>).toList();

    // Initialize the audio with the first available audio URL
    if (cdata.isNotEmpty && cdata[0]['audiourl'] != null) {
      initializeAudio(cdata[0]['audiourl']);
    }

    isLoading(false); // Set loading state to false once data is loaded
  }

  // Method to switch between types (Arabic, Transliteration, Translation)
  void changeType(String type) {
    selectedType.value = type;
  }
}
