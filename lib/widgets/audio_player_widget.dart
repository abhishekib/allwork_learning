import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isCompleted = false;
  bool hasError = false; // New state to track loading errors
  Duration currentTime = Duration.zero;
  Duration totalTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
      hasError = false; // Clear any previous error state

      _audioPlayer.durationStream.listen((duration) {
        if (duration != null && mounted) {
          setState(() {
            totalTime = duration;
          });
        }
      });

      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            currentTime = Duration(
              seconds: min(position.inSeconds, totalTime.inSeconds),
            );
          });
        }
      });

      _audioPlayer.playerStateStream.listen((playerState) {
        if (mounted) {
          if (playerState.processingState == ProcessingState.completed) {
            setState(() {
              currentTime = Duration.zero;
              isPlaying = false;
              isCompleted = true;
            });
          } else {
            setState(() {
              isPlaying = playerState.playing;
              if (playerState.processingState != ProcessingState.completed) {
                isCompleted = false;
              }
            });
          }
        }
      });
    } catch (e) {
      // Set error state if loading fails
      setState(() {
        hasError = true;
      });
      if (kDebugMode) {
        print("Error loading audio: $e");
      }
    }
  }

  Future<void> _retryLoadingAudio() async {
    setState(() {
      hasError = false;
      currentTime = Duration.zero;
      isPlaying = false;
      isCompleted = false;
    });
    await _setupAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Show the retry button if there's an error loading the audio
          if (hasError)
            Column(
              children: [
                const Text(
                  "Failed to load audio. Please try again.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _retryLoadingAudio,
                  child: const Text("Retry"),
                ),
              ],
            )
          else
            Column(
              children: [
                // Playback Progress Slider
                Row(
                  children: [
                    Text(
                      _formatDuration(currentTime),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Expanded(
                      child: Slider(
                        value: currentTime.inSeconds.toDouble(),
                        min: 0,
                        max: totalTime.inSeconds.toDouble(),
                        onChanged: (value) async {
                          await _audioPlayer
                              .seek(Duration(seconds: value.toInt()));
                          if (value == 0) {
                            setState(() {
                              isPlaying = false;
                            });
                          }
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white54,
                      ),
                    ),
                    Text(
                      _formatDuration(totalTime),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        _audioPlayer
                            .setVolume(_audioPlayer.volume == 0 ? 1 : 0);
                      },
                      icon: Icon(
                        _audioPlayer.volume == 0
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (isPlaying) {
                          await _audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          if (isCompleted) {
                            await _audioPlayer.seek(Duration.zero);
                            setState(() {
                              isCompleted = false;
                            });
                          }
                          await _audioPlayer.play();
                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    // Settings Button (Placeholder)
                    IconButton(
                      onPressed: () {
                        // Handle settings action
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Helper function to format Duration to mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
