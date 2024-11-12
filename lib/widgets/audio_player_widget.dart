import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({
    Key? key,
    required this.audioUrl,
  }) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isCompleted = false;
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
      print("Error loading audio: $e");
    }
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
                    await _audioPlayer.seek(Duration(seconds: value.toInt()));
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  _audioPlayer.setVolume(_audioPlayer.volume == 0 ? 1 : 0);
                },
                icon: Icon(
                  _audioPlayer.volume == 0 ? Icons.volume_off : Icons.volume_up,
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
