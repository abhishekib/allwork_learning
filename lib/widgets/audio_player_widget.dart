import 'dart:developer';

import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/providers/audio_provider.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayerWidget extends StatefulWidget {
  
  String audioUrl;
  final ValueChanged<Duration> onPositionChanged;
  final AudioController controller;
  String categoryName;
  String categoryType;

  AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.categoryName,
    required this.categoryType,
    required this.onPositionChanged,
    required this.controller,
  }){log("Audio url passed here is : $audioUrl");}

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

const String playbackSpeedKey = 'playback_speed';

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;

  final AudioProvider audioProvider = AudioProvider(ApiConstants.token);

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.controller.audioplayer;
    // if (widget.downloaded) {
    //   widget.controller.downloaded.value = true;
    // }

log("initializig audio player widget with audio url ${widget.audioUrl}");
    widget.controller.setupAudio(widget.audioUrl);
    widget.controller.loadViewPreference();
    widget.controller.loadPlaybackSpeed();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audioUrl != oldWidget.audioUrl) {
      log("Did update widget called");
      widget.controller.setupAudio(widget.audioUrl);
    }
  }

  @override
  void dispose() {
    widget.controller.audioUrl.value = '';
    // widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: Obx(() => widget.controller.isCompactView.value
          ? _buildCompactView()
          : _buildNormalView()),
    );
  }

  Widget _buildNormalView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.controller.isLoading.value)
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.backgroundBlue,
            ),
          )
        else if (widget.controller.hasError.value)
          Column(
            children: [
              const Text(
                "Failed to load audio. Please try again.",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    widget.controller.retryLoadingAudio(widget.audioUrl),
                child: const Text("Retry"),
              ),
            ],
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.controller
                        .formatDuration(widget.controller.currentTime.value),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Slider(
                      value: widget.controller.currentTime.value.inSeconds
                          .toDouble(),
                      min: 0,
                      max: widget.controller.totalTime.value.inSeconds
                          .toDouble(),
                      onChanged: (value) async {
                        await _audioPlayer
                            .seek(Duration(seconds: value.toInt()));
                        if (value == 0) {
                          widget.controller.isPlaying.value = false;
                        }
                      },
                      activeColor: AppColors.backgroundBlue,
                      inactiveColor: AppColors.backgroundBlue,
                    ),
                  ),
                  Text(
                    widget.controller.formatDuration(
                        widget.controller.totalTime.value -
                            widget.controller.currentTime.value),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      widget.controller.volume.value =
                          widget.controller.volume.value == 0.0 ? 1.0 : 0.0;
                      _audioPlayer.setVolume(widget.controller.volume.value);
                    },
                    icon: Icon(
                      widget.controller.volume.value == 0
                          ? Icons.volume_off
                          : Icons.volume_up,
                      color: AppColors.backgroundBlue,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (widget.controller.isPlaying.value) {
                        await _audioPlayer.pause();
                        widget.controller.isPlaying.value = false;
                      } else {
                        if (widget.controller.isCompleted.value) {
                          await _audioPlayer.seek(Duration.zero);
                          widget.controller.isCompleted.value = false;
                        }
                        await _audioPlayer.resume();
                        widget.controller.isPlaying.value = true;
                      }
                    },
                    icon: Icon(
                      widget.controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: AppColors.backgroundBlue,
                      size: 40,
                    ),
                  ),
                  PopupMenuButton<double>(
                    icon: Container(
                      height: 25,
                      width: 35,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.backgroundBlue),
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.backgroundBlue),
                      child: Center(
                        child: Text(
                            '${widget.controller.playbackSpeed.value.toStringAsFixed(2)}x',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    onSelected: (value) {
                      widget.controller.playbackSpeed.value = value;

                      _audioPlayer.setPlaybackRate(
                          widget.controller.playbackSpeed.value);
                      widget.controller.savePlaybackSpeed(
                          widget.controller.playbackSpeed.value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0.25,
                        child: Text('0.25x'),
                      ),
                      const PopupMenuItem(
                        value: 0.5,
                        child: Text('0.5x'),
                      ),
                      const PopupMenuItem(
                        value: 0.75,
                        child: Text('0.75x'),
                      ),
                      const PopupMenuItem(
                        value: 1.0,
                        child: Text('1.0x'),
                      ),
                      const PopupMenuItem(
                        value: 1.25,
                        child: Text('1.25x'),
                      ),
                      const PopupMenuItem(
                        value: 1.5,
                        child: Text('1.5x'),
                      ),
                      const PopupMenuItem(
                        value: 1.75,
                        child: Text('1.75x'),
                      ),
                      const PopupMenuItem(
                        value: 2.0,
                        child: Text('2.0x'),
                      ),
                    ],
                  ),
                  widget.controller.downloaded.value
                      ? const SizedBox.shrink()
                      : widget.controller.isDownloading.value
                          ? const CircularProgressIndicator(color: AppColors.backgroundBlue)
                          : IconButton(
                              onPressed: () {
                                if (!widget.controller.downloaded.value) {
                                  log("Changing the state: Starting download");
                                  widget.controller.isDownloading.value = true;

                                  log("Let us download the audio");

                                  audioProvider
                                      .downloadAudio(
                                          widget.audioUrl, widget.categoryName, widget.categoryType)
                                      .then((savedPath) {
                                    log("Download complete");

                                    widget.controller.downloaded.value = true;
                                    widget.controller.isDownloading.value =
                                        false;
                                    widget.audioUrl = savedPath!;
                                  }).catchError((error) {
                                    widget.controller.isDownloading.value =
                                        false;

                                    log("Download failed: $error");
                                  });
                                } else {
                                  log("Audio is already downloaded");
                                }
                              },
                              icon: const Icon(Icons.download),
                            ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCompactView() {
    return Row(
      children: [
        Text(
          widget.controller.formatDuration(widget.controller.currentTime.value,
              showHours: widget.controller.currentTime.value.inHours > 0),
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        Expanded(
          child: Slider(
            value: widget.controller.currentTime.value.inSeconds.toDouble(),
            min: 0,
            max: widget.controller.totalTime.value.inSeconds.toDouble(),
            onChanged: (value) async {
              await _audioPlayer.seek(Duration(seconds: value.toInt()));
              if (value == 0) {
                widget.controller.isPlaying.value = false;
              }
            },
            activeColor: AppColors.backgroundBlue,
            inactiveColor: Colors.grey,
          ),
        ),
        Text(
          widget.controller.formatDuration(
              widget.controller.totalTime.value -
                  widget.controller.currentTime.value,
              showHours: widget.controller.totalTime.value.inHours > 0),
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        widget.controller.isLoading.value == true
            ? CircularProgressIndicator(
                color: AppColors.backgroundBlue,
              )
            : IconButton(
                onPressed: () async {
                  widget.controller.playPause();
                },
                icon: Icon(
                  widget.controller.isPlaying.value
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: AppColors.backgroundBlue,
                  size: 30,
                ),
              ),
        IconButton(
          onPressed: () async {
            widget.controller.muteUnmute();
          },
          icon: Icon(
            widget.controller.volume.value == 0
                ? Icons.volume_off
                : Icons.volume_up,
            color: AppColors.backgroundBlue,
          ),
        ),
        PopupMenuButton<double>(
          icon: Container(
            height: 25,
            width: 35,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.backgroundBlue),
                borderRadius: BorderRadius.circular(5),
                color: AppColors.backgroundBlue),
            child: Center(
              child: Text(
                  '${widget.controller.playbackSpeed.value.toStringAsFixed(2)}x',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          onSelected: (value) {
            widget.controller.playbackSpeed.value = value;

            _audioPlayer.setPlaybackRate(widget.controller.playbackSpeed.value);
            widget.controller
                .savePlaybackSpeed(widget.controller.playbackSpeed.value);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 0.25,
              child: Text('0.25x'),
            ),
            const PopupMenuItem(
              value: 0.5,
              child: Text('0.5x'),
            ),
            const PopupMenuItem(
              value: 0.75,
              child: Text('0.75x'),
            ),
            const PopupMenuItem(
              value: 1.0,
              child: Text('1.0x'),
            ),
            const PopupMenuItem(
              value: 1.25,
              child: Text('1.25x'),
            ),
            const PopupMenuItem(
              value: 1.5,
              child: Text('1.5x'),
            ),
            const PopupMenuItem(
              value: 1.75,
              child: Text('1.75x'),
            ),
            const PopupMenuItem(
              value: 2.0,
              child: Text('2.0x'),
            ),
          ],
        ),
        widget.controller.downloaded.value
            ? const SizedBox.shrink()
            : widget.controller.isDownloading.value
                ? const CircularProgressIndicator(color: AppColors.backgroundBlue)
                : IconButton(
                    onPressed: () {
                      if (!widget.controller.downloaded.value) {
                        log("Changing the state: Starting download");
                        widget.controller.isDownloading.value = true;

                        log("Let us download the audio");

                        audioProvider
                            .downloadAudio(widget.audioUrl, widget.categoryName, widget.categoryType)
                            .then((savedPath) {
                          widget.controller.downloaded.value = true;
                          widget.controller.isDownloading.value = false;
                          widget.audioUrl = savedPath!;

                          log("Download complete");
                        }).catchError((error) {
                          widget.controller.isDownloading.value = false;

                          log("Download failed: $error");
                        });
                      } else {
                        log("Audio is already downloaded");
                      }
                    },
                    icon: const Icon(Icons.download),
                  ),
      ],
    );
  }
}
