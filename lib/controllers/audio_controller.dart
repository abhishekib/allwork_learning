import 'dart:developer';

import 'package:allwork/services/db_services.dart';
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
  RxDouble volume = 1.0.obs;
  var audioUrl = ''.obs;
  var isDownloading = false.obs;
  var downloaded = false.obs;

  AudioPlayer get audioplayer => _audioPlayer;

  Future<void> setupAudio(String audioUrl) async {
    log("Setup audio called with url: $audioUrl");
    try {
      isLoading.value = true;

      // Load playback speed before setting the source to ensure it applies correctly
      await loadPlaybackSpeed();

      //check if audio is already downloaded or not
      String? audioDownloadPath =
          DbServices.instance.getAudioDownloadPath(audioUrl);
      log("Audio download path: $audioDownloadPath");

      
      if (audioDownloadPath != null) {
        log("Audio already downloaded in path: $audioDownloadPath");
        downloaded.value = true;
        await _audioPlayer.setSource(DeviceFileSource(audioDownloadPath));
      } else {
        await _audioPlayer.setSource(UrlSource(audioUrl));
      }

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

  Future<void> playPause() async {
    if (isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    isPlaying.value = !isPlaying.value;
  }

  Future<void> muteUnmute() async {
    if (volume.value > 0) {
      await _audioPlayer.setVolume(0);
    } else {
      await _audioPlayer.setVolume(1);
    }
    volume.value = 1 - volume.value;
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

  Future<void> retryLoadingAudio(String audioUrl) async {
    hasError.value = false;
    currentTime.value = Duration.zero;
    isPlaying.value = false;
    isCompleted.value = false;

    await setupAudio(audioUrl);
  }

  // String formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "$minutes:$seconds";
  // }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
    currentTime.value = position;
  }

  String formatDuration(Duration duration, {bool showHours = true}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return showHours ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await setupAudio(audioUrl.value);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
