import 'dart:developer';

import 'package:allwork/controllers/text_cleaner_controller.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricsTab extends StatefulWidget {
  final List<Lyrics> lyricsList;

  const LyricsTab({super.key, required this.lyricsList});

  @override
  _LyricsTabState createState() => _LyricsTabState();
}

class _LyricsTabState extends State<LyricsTab> {
  final CategoryDetailController controller =
      Get.find<CategoryDetailController>();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final TextCleanerController _textCleanerController = TextCleanerController();

  int _currentHighlightedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.onReset();
    debugPrint("LyricsTab initialized with ${widget.lyricsList.length} items");

    // Listen to the current audio time from the controller
    ever(controller.currentTime, (currentTimeValue) {
      int newIndex = _findLyricsIndex(currentTimeValue.toInt());

      if (newIndex != -1 && newIndex != _currentHighlightedIndex) {
        if (mounted) {
          setState(() {
            _currentHighlightedIndex = newIndex;
          });
          _itemScrollController.scrollTo(
            index: _currentHighlightedIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

        debugPrint('New highlighted lyrics index: $_currentHighlightedIndex');

        // Scroll to the new highlighted lyrics
      }
    });
  }

  @override
  void dispose() {
    //controller.onClose();
    super.dispose();
  }

  int _findLyricsIndex(int currentPosition) {
    for (int i = 0; i < widget.lyricsList.length; i++) {
      final lyrics = widget.lyricsList[i];
      final timeInMilliseconds = _parseTimestamp(lyrics.time);
      /* log("MY DATA ${widget.lyricsList[i + 1].time} && ${widget.lyricsList[i + 1].time.isNum}"); */
      final nextTimeInMilliseconds = i < widget.lyricsList.length - 1
          ? _parseTimestamp(widget.lyricsList[i + 1].time)
          : 9223372036854775807; // Use this instead of double.infinity.toInt ==> this causes NaN or Infitity parsing error

      /* debugPrint(
          'Lyrics index $i: currentTime=$currentPosition ms, startTime=$timeInMilliseconds ms, nextStartTime=$nextTimeInMilliseconds ms'); */

      if (currentPosition >= timeInMilliseconds &&
          currentPosition < nextTimeInMilliseconds) {
        return i;
      }
    }
    return -1;
  }

  int _parseTimestamp(String time) {
    try {
      final cleanedTime = time.replaceAll('[', '').replaceAll(']', '');
      final parts = cleanedTime.split(':');
      if (parts.length == 2) {
        final minutes = int.tryParse(parts[0]) ?? 0;
        final secondsAndMilliseconds = parts[1].split('.');
        final seconds = int.tryParse(secondsAndMilliseconds[0]) ?? 0;
        final milliseconds = secondsAndMilliseconds.length > 1
            ? (double.parse('0.${secondsAndMilliseconds[1]}') * 1000).toInt()
            : 0;

        final parsedTime =
            (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;

        //debugPrint('Parsed timestamp "$time" to $parsedTime ms');

        return parsedTime;
      }
    } catch (e) {
      debugPrint('Error parsing timestamp: $e');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemCount: widget.lyricsList.length,
      itemBuilder: (context, index) {
        final lyrics = widget.lyricsList[index];
        // final isHighlighted = index == _currentHighlightedIndex;
        // log("lyrics time from api------->${lyrics.time}");

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  final isArabicHighlighted =
                      controller.selectedType.value.toLowerCase() == "arabic" ||
                          controller.selectedType.value == "અરબી";
                  return Visibility(
                    visible: lyrics.arabic.isNotEmpty,
                    child: Text(
                      _textCleanerController.cleanText(lyrics.arabic),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: isArabicHighlighted ? 30 : 18,
                        fontWeight: isArabicHighlighted
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isArabicHighlighted
                            ? Colors.black87
                            : Colors.black54,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Obx(() {
                  final isTransliterationHighlighted =
                      controller.selectedType.value.toLowerCase() ==
                              "transliteration" ||
                          controller.selectedType.value == "તરજુમા";
                  return Visibility(
                    visible: lyrics.translitration.isNotEmpty,
                    child: Text(
                      _textCleanerController.cleanText(lyrics.translitration),
                      style: TextStyle(
                        fontSize: isTransliterationHighlighted ? 20 : 16,
                        fontWeight: isTransliterationHighlighted
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isTransliterationHighlighted
                            ? Colors.black87
                            : Colors.black54,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Obx(() {
                  final isTranslationHighlighted =
                      controller.selectedType.value.toLowerCase() ==
                              "translation" ||
                          controller.selectedType.value == "ગુજરાતી";
                  return Visibility(
                    visible: lyrics.translation.isNotEmpty,
                    child: Text(
                      _textCleanerController.cleanText(lyrics.translation),
                      style: TextStyle(
                        fontSize: isTranslationHighlighted ? 20 : 16,
                        fontWeight: FontWeight.bold,
                        color: isTranslationHighlighted
                            ? Colors.black87
                            : Colors.black54,
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
