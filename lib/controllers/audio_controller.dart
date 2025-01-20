import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:shared_preferences/shared_preferences.dart';

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxBool isCompleted = false.obs;
  Rx<Duration> totalTime = Duration.zero.obs;
  Rx<Duration> currentTime = Duration.zero.obs;
  RxDouble playbackSpeed = 1.0.obs;
  RxBool isCompactView = true.obs;
  String audioUrl;
  RxDouble volume = 1.0.obs;

  var isDownloading = false.obs;

  AudioController(this.audioUrl);

  AudioPlayer get audioplayer => _audioPlayer;

  Future<void> setupAudio() async {
    try {
      isLoading.value = true;

      // Load playback speed before setting the source to ensure it applies correctly
      await loadPlaybackSpeed();

      await _audioPlayer.setSource(UrlSource(audioUrl));

      await Future.delayed(const Duration(milliseconds: 500));

      final duration = await _audioPlayer.getDuration();
      if (duration != null) {
        totalTime.value = duration;
      }

      _audioPlayer.onDurationChanged.listen((duration) {
        totalTime.value = duration;
      });

      _audioPlayer.onPositionChanged.listen((position) {
        currentTime.value = Duration(
          seconds: math.min(position.inSeconds, totalTime.value.inSeconds),
        );
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        currentTime.value = Duration.zero;
        isPlaying.value = false;
        isCompleted.value = true;
      });

      isLoading.value = false;
      hasError.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      if (kDebugMode) {
        print("Error loading audio: $e");
      }
    }
  }

  Future<void> savePlaybackSpeed(double speed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('playbackSpeedKey', speed);
    playbackSpeed.value = speed; // Update the observable playback speed
    _audioPlayer.setPlaybackRate(speed); // Apply new speed immediately
  }

  Future<void> loadPlaybackSpeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double speed = prefs.getDouble('playbackSpeedKey') ?? 1.0;
    playbackSpeed.value = speed; // Set the loaded speed
    _audioPlayer.setPlaybackRate(speed); // Apply the speed
  }

  Future<void> loadViewPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Load the view preference and update the observable
    isCompactView.value = prefs.getBool('isCompactView') ?? true;
  }

  Future<void> retryLoadingAudio() async {
    hasError.value = false;
    currentTime.value = Duration.zero;
    isPlaying.value = false;
    isCompleted.value = false;

    await setupAudio();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void onInit() {
    super.onInit();
    setupAudio(); // Load audio when controller is initialized
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
