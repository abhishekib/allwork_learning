import 'dart:developer';

import 'package:allwork/providers/audio_provider.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  //final AudioPlayer _audioPlayer = AudioPlayer();
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
  RxDouble downloadProgress = 0.0.obs;
  CancelToken cancelToken = CancelToken();

  AudioPlayer get audioplayer => _audioPlayer;
  final AudioProvider _audioProvider = AudioProvider();

  Future<void> downloadAudio(
      String url, String categoryName, String categoryType) async {
    try {
      if (DbServices.instance.hasAudioDownload(url)) {
        final existingPath = DbServices.instance.getAudioDownloadPath(url);
        if (existingPath != null) {
          downloaded.value = true;
          audioUrl.value = existingPath;
          await setupAudio(existingPath);
          return;
        }
      }
      isDownloading.value = true;
      downloadProgress.value = 0.0;
      cancelToken = CancelToken();

      final savedPath = await _audioProvider.downloadAudio(
        url: url,
        categoryName: categoryName,
        categoryType: categoryType,
        onProgress: (progress) {
          downloadProgress.value = progress;
        },
        cancelToken: cancelToken,
      );

      if (savedPath != null) {
        downloaded.value = true;
        audioUrl.value = savedPath;
        await setupAudio(savedPath);
      }
    } catch (e) {
      if (e is RealmException &&
          e.message.contains('RLM_ERR_OBJECT_ALREADY_EXISTS')) {
        final existingPath = DbServices.instance.getAudioDownloadPath(url);
        if (existingPath != null) {
          downloaded.value = true;
          audioUrl.value = existingPath;
          await setupAudio(existingPath);
        }
      } else {
        Get.snackbar('Error', 'Download failed: ${e.toString()}');
      }
    } finally {
      isDownloading.value = false;
    }
  }

  void cancelDownload() {
    cancelToken.cancel();
    isDownloading.value = false;
    downloadProgress.value = 0.0;
  }

  Future<void> setupAudio(String audioUrl) async {
    log("Setup audio called with url: $audioUrl");
    try {
      if (await Helpers.hasActiveInternetConnection()) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
      }

      // Load playback speed before setting the source to ensure it applies correctlFy
      await loadPlaybackSpeed();

      //check if audio is already downloaded or not
      String? audioDownloadPath =
          DbServices.instance.getAudioDownloadPath(audioUrl);
      log("Audio download path: $audioDownloadPath");

      if (audioDownloadPath != null) {
        log("Audio already downloaded in path: $audioDownloadPath");
        downloaded.value = true;
        await _audioPlayer.setFilePath(audioDownloadPath);
        //await _audioPlayer.setSource(DeviceFileSource(audioDownloadPath));
      } else {
        log("audio url: $audioUrl");
        await _audioPlayer.setUrl(audioUrl);
        //await _audioPlayer.setSource(UrlSource(audioUrl));
      }

      await Future.delayed(const Duration(milliseconds: 500));

      //final duration = await _audioPlayer.getDuration();
      final duration = _audioPlayer.duration;
      if (duration != null) {
        totalTime.value = duration;
      }

      // _audioPlayer.onDurationChanged.listen((duration) {
      //   totalTime.value = duration;
      // });

      _audioPlayer.durationStream.listen((event) {
        totalTime.value = event ?? Duration.zero;
      });

      // _audioPlayer.onPositionChanged.listen((position) {
      //   currentTime.value = Duration(
      //     seconds: math.min(position.inSeconds, totalTime.value.inSeconds),
      //   );
      // });

      _audioPlayer.positionStream.listen((event) {
        currentTime.value = event;
      });

      // _audioPlayer.onPlayerComplete.listen((event) {
      //   currentTime.value = Duration.zero;
      //   isPlaying.value = false;
      //   isCompleted.value = true;
      // });

//on player complete left

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
      log("Pausing audio");
      _audioPlayer.pause();
    } else {
      //await _audioPlayer.resume();
      log("Playing audio");
      _audioPlayer.play();
    }
    isPlaying.value = !isPlaying.value;
    log("Is playing: ${isPlaying.value}");
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
    //_audioPlayer.setPlaybackRate(speed);
    _audioPlayer.setSpeed(speed); // Apply new speed immediately
  }

  Future<void> loadPlaybackSpeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double speed = prefs.getDouble('playbackSpeedKey') ?? 1.0;
    playbackSpeed.value = speed; // Set the loaded speed
    //_audioPlayer.setPlaybackRate(speed); // Apply the speed
    _audioPlayer.setSpeed(speed);
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

    log("Retrying loading audio");
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

    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    //await setupAudio(audioUrl.value);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
