import 'dart:developer';
import 'dart:io';

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
  final RxMap<String, bool> downloadedStatus = <String, bool>{}.obs;
  final RxMap<String, double> downloadProgress = <String, double>{}.obs;
  CancelToken cancelToken = CancelToken();

  AudioPlayer get audioplayer => _audioPlayer;
  final AudioProvider _audioProvider = AudioProvider();

  bool isDownloaded(String url) {
    return downloadedStatus[url] ?? false;
  }

  double getProgress(String url) {
    return downloadProgress[url] ?? 0.0;
  }

  Future<void> downloadAudio(
    String url,
    String categoryName,
    String categoryType,
  ) async {
    try {
      final fileName = url.split('/').last;
      final existingMapping =
          DbServices.instance.getAudioDownloadMapping(fileName);
      if (existingMapping != null) {
        // File exists - register this URL if not already present
        if (!existingMapping.sourceUrls.contains(url)) {
          DbServices.instance.addSourceUrlToMapping(fileName, url);
        }

        downloadedStatus[url] = true;
        audioUrl.value = existingMapping.audioDownloadPath;
        await setupAudio(existingMapping.audioDownloadPath);
        return;
      }
      /* if (DbServices.instance.hasAudioDownload(url)) {
        final existingPath = DbServices.instance.getAudioDownloadPath(url);
        if (existingPath != null) {
          downloaded.value = true;
          audioUrl.value = existingPath;
          await setupAudio(existingPath);
          return;
        }
      } */
      isDownloading.value = true;
      downloadProgress[url] = 0.0;
      cancelToken = CancelToken();

      final savedPath = await _audioProvider.downloadAudio(
        url: url,
        categoryName: categoryName,
        categoryType: categoryType,
        onProgress: (progress) {
          downloadProgress[url] = progress;
        },
        cancelToken: cancelToken,
      );

      if (savedPath != null) {
        await DbServices.instance.writeAudioDownloadPath(
          url,
          savedPath,
          categoryName,
          categoryType,
        );
        downloadedStatus[url] = true;
        audioUrl.value = savedPath;
        await setupAudio(savedPath);
      }
    } catch (e) {
      if (e is RealmException &&
          e.message.contains('RLM_ERR_OBJECT_ALREADY_EXISTS')) {
        final existingPath = DbServices.instance.getAudioDownloadPath(url);
        if (existingPath != null) {
          downloadedStatus[url] = true;
          audioUrl.value = existingPath;
          await setupAudio(existingPath);
        }
      } else {
        Get.snackbar('Error', 'Download failed: ${e.toString()}');
      }
    } finally {
      isDownloading.value = false;
      downloadProgress.remove(url);
    }
  }

/*   void cancelDownload() {
    cancelToken.cancel();
    isDownloading.value = false;
    downloadProgress.value = 0.0;
  } */

  Future<void> setupAudio(String audioUrl) async {
    log("Setup audio called with url: $audioUrl");
    try {
      isLoading.value = true;

      // Load playback speed first
      await loadPlaybackSpeed();

      // Check if this specific URL is downloaded
      final isDownloaded = downloadedStatus[audioUrl] ?? false;
      final audioName = audioUrl.split('/').last;
      String? audioDownloadPath;

      if (isDownloaded) {
        // Get path from database
        audioDownloadPath = DbServices.instance.getAudioDownloadPath(audioName);
        log("Audio already downloaded in path: $audioDownloadPath");
      }

      // Set audio source based on download status
      if (isDownloaded && audioDownloadPath != null) {
        await _audioPlayer.setFilePath(audioDownloadPath);
        downloadedStatus[audioUrl] = true; // Ensure status is set
      } else {
        // Check if file exists but URL wasn't marked as downloaded
        final existingFile =
            DbServices.instance.getAudioDownloadMapping(audioName);
        if (existingFile != null) {
          await _audioPlayer.setFilePath(existingFile.audioDownloadPath);
          downloadedStatus[audioUrl] = true; // Update status
        } else {
          // Fallback to streaming
          log("Playing audio from URL: $audioUrl");
          await _audioPlayer.setUrl(audioUrl);
          downloadedStatus[audioUrl] = false;
        }
      }

      // Wait for audio to initialize
      await Future.delayed(const Duration(milliseconds: 500));

      // Get duration
      final duration = _audioPlayer.duration;
      if (duration != null) {
        totalTime.value = duration;
      }

      // Setup listeners
      _audioPlayer.durationStream.listen((event) {
        totalTime.value = event ?? Duration.zero;
      });

      _audioPlayer.positionStream.listen((event) {
        currentTime.value = event;
      });

      isLoading.value = false;
      hasError.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      log("Error loading audio: $e");

      // Fallback to URL if file playback fails
      if (downloadedStatus[audioUrl] == true) {
        log("Attempting fallback to streaming");
        downloadedStatus[audioUrl] = false;
        await _audioPlayer.setUrl(audioUrl);
      }
    }
  }

  Future<void> playPause() async {
    if (isPlaying.value) {
      log("Pausing audio");
      await _audioPlayer.pause();
      isPlaying.value = false;
    } else {
      log("Playing audio");
      // Verify we have a valid source before playing
      if ((downloadedStatus[audioUrl.value] == true &&
          !(await File(DbServices.instance
                  .getAudioDownloadPath(audioUrl.value.split('/').last)!)
              .exists()))) {
        // Handle case where file was deleted externally
        downloadedStatus[audioUrl.value] = false;
        await setupAudio(audioUrl.value);
      }
      await _audioPlayer.play();
      isPlaying.value = true;
    }
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
