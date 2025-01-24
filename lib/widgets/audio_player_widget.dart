import 'dart:developer';
import 'dart:math' as math;
import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/providers/audio_provider.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerWidget extends StatefulWidget {
  final bool downloaded;
  String audioUrl;
  final ValueChanged<Duration> onPositionChanged;
  final int cDataId;
  final AudioController controller;

  AudioPlayerWidget({
    super.key,
    required this.downloaded,
    required this.audioUrl,
    required this.onPositionChanged,
    required this.cDataId,
    required this.controller,
  });

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

const String playbackSpeedKey = 'playback_speed';

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  // bool isPlaying = false;
  // bool isCompleted = false;
  // bool isDownloading = false;
  // bool hasError = false;
  // bool isLoading = true;
  // Duration currentTime = Duration.zero;
  // Duration totalTime = Duration.zero;
  // double volume = 1.0;
  // double playbackSpeed = 1.0;
  // bool isCompactView = true;
  bool downloaded = false;

  final AudioProvider audioProvider = AudioProvider(ApiConstants.token);
  // late AudioController widget.controller;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.controller.audioplayer;
    if (widget.downloaded) {
      downloaded = true;
    }

    widget.controller.setupAudio(widget.audioUrl);
    widget.controller.loadViewPreference();
    widget.controller.loadPlaybackSpeed();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audioUrl != oldWidget.audioUrl) {
      widget.controller.setupAudio(widget.audioUrl);
    }
  }

  // Future<void> _loadPlaybackSpeed() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     playbackSpeed = prefs.getDouble(playbackSpeedKey) ?? 1.0;
  //   });
  //   _audioPlayer.setPlaybackRate(playbackSpeed); // Apply saved speed
  // }

  // Future<void> _savePlaybackSpeed(double speed) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setDouble(playbackSpeedKey, speed);
  // }

  // Future<void> _setupAudio() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     await _audioPlayer.setSource(UrlSource(widget.audioUrl));

  //     await Future.delayed(const Duration(milliseconds: 500));

  //     final duration = await _audioPlayer.getDuration();
  //     if (duration != null && mounted) {
  //       setState(() {
  //         totalTime = duration;
  //       });
  //     }

  //     _audioPlayer.onDurationChanged.listen((duration) {
  //       if (mounted) {
  //         setState(() {
  //           totalTime = duration;
  //         });
  //       }
  //     });

  //     _audioPlayer.onPositionChanged.listen((position) {
  //       if (mounted) {
  //         setState(() {
  //           currentTime = Duration(
  //             seconds: math.min(position.inSeconds, totalTime.inSeconds),
  //           );
  //         });

  //         widget.onPositionChanged(position);
  //       }
  //     });

  //     _audioPlayer.onPlayerComplete.listen((event) {
  //       if (mounted) {
  //         setState(() {
  //           currentTime = Duration.zero;
  //           isPlaying = false;
  //           isCompleted = true;
  //         });
  //       }
  //     });

  //     setState(() {
  //       isLoading = false;
  //       hasError = false;
  //     });
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //         hasError = true;
  //       });
  //     }
  //     if (kDebugMode) {
  //       print("Error loading audio: $e");
  //     }
  //   }
  // }

  // Future<void> _loadViewPreference() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     isCompactView = prefs.getBool('isCompactView') ?? true;
  //   });
  // }

  // Future<void> _retryLoadingAudio() async {
  //   if (!mounted) return;

  //   setState(() {
  //     hasError = false;
  //     currentTime = Duration.zero;
  //     isPlaying = false;
  //     isCompleted = false;
  //   });
  //   await _setupAudio();
  // }

  @override
  void dispose() {
    Get.delete<AudioController>();
    widget.controller.dispose();
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
                          if (mounted) {
                            setState(() {
                              widget.controller.isPlaying.value = false;
                            });
                          }
                        }
                      },
                      activeColor: AppColors.backgroundBlue,
                      inactiveColor: AppColors.backgroundBlue,
                    ),
                  ),
                  Text(
                    _formatDuration(widget.controller.totalTime.value -
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
                      setState(() {
                        widget.controller.volume.value =
                            widget.controller.volume.value == 0.0 ? 1.0 : 0.0;
                        _audioPlayer.setVolume(widget.controller.volume.value);
                      });
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
                        if (mounted) {
                          setState(() {
                            widget.controller.isPlaying.value = false;
                          });
                        }
                      } else {
                        if (widget.controller.isCompleted.value) {
                          await _audioPlayer.seek(Duration.zero);
                          if (mounted) {
                            setState(() {
                              widget.controller.isCompleted.value = false;
                            });
                          }
                        }
                        await _audioPlayer.resume();
                        if (mounted) {
                          setState(() {
                            widget.controller.isPlaying.value = true;
                          });
                        }
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
                      setState(() {
                        widget.controller.playbackSpeed.value = value;
                      });
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
                  downloaded
                      ? const SizedBox.shrink()
                      : widget.controller.isDownloading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : IconButton(
                              onPressed: () {
                                if (!downloaded) {
                                  setState(() {
                                    log("Changing the state: Starting download");
                                    widget.controller.isDownloading.value =
                                        true;
                                  });
                                  log("Let us download the audio");

                                  audioProvider
                                      .downloadAudio(
                                          widget.audioUrl, widget.cDataId)
                                      .then((savedPath) {
                                    setState(() {
                                      downloaded = true;
                                      widget.controller.isDownloading.value =
                                          false;
                                      widget.audioUrl = savedPath!;
                                    });
                                    log("Download complete");
                                  }).catchError((error) {
                                    setState(() {
                                      widget.controller.isDownloading.value =
                                          false;
                                    });
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
          _formatDuration(widget.controller.currentTime.value),
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
                setState(() {
                  widget.controller.isPlaying.value = false;
                });
              }
            },
            activeColor: AppColors.backgroundBlue,
            inactiveColor: Colors.grey,
          ),
        ),
        Text(
          _formatDuration(widget.controller.totalTime.value),
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        IconButton(
          onPressed: () async {
            if (widget.controller.isPlaying.value) {
              await _audioPlayer.pause();
              setState(() {
                widget.controller.isPlaying.value = false;
              });
            } else {
              await _audioPlayer.resume();
              setState(() {
                widget.controller.isPlaying.value = true;
              });
            }
          },
          icon: Icon(
            widget.controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
            color: AppColors.backgroundBlue,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              widget.controller.volume.value =
                  widget.controller.volume.value == 0 ? 1.0 : 0.0;
              _audioPlayer.setVolume(widget.controller.volume.value);
            });
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
            setState(() {
              widget.controller.playbackSpeed.value = value;
            });
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
        downloaded
            ? const SizedBox.shrink()
            : widget.controller.isDownloading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : IconButton(
                    onPressed: () {
                      if (!downloaded) {
                        setState(() {
                          log("Changing the state: Starting download");
                          widget.controller.isDownloading.value = true;
                        });
                        log("Let us download the audio");

                        audioProvider
                            .downloadAudio(widget.audioUrl, widget.cDataId)
                            .then((savedPath) {
                          setState(() {
                            downloaded = true;
                            widget.controller.isDownloading.value = false;
                            widget.audioUrl = savedPath!;
                          });
                          log("Download complete");
                        }).catchError((error) {
                          setState(() {
                            widget.controller.isDownloading.value = false;
                          });
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
