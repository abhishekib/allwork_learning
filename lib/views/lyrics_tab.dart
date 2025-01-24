import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/controllers/text_cleaner_controller.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LyricsTab extends StatefulWidget {
  final List<Lyrics> lyricsList;
  final String selectedLanguage;

  const LyricsTab(
      {super.key, required this.lyricsList, required this.selectedLanguage});

  @override
  LyricsTabState createState() => LyricsTabState();
}

class LyricsTabState extends State<LyricsTab> {
  final CategoryDetailController controller =
      Get.find<CategoryDetailController>();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final TextCleanerController _textCleanerController = TextCleanerController();
  final AudioController audioController = Get.find<AudioController>();

  double arabicFontSize = 18.0;
  double transliterationFontSize = 16.0;
  double translationFontSize = 16.0;

  int _currentHighlightedIndex = 0;
  bool _isUserInteraction = false;

  late String fontFamily;

  @override
  void initState() {
    super.initState();
    controller.onReset();
    _loadFontSizes();

    fontFamily = widget.selectedLanguage == 'English' ? 'Roboto' : 'Gopika';
    debugPrint("LyricsTab initialized with ${widget.lyricsList.length} items");

    // Listen to the current audio time from the controller
    ever(audioController.currentTime, (currentTimeValue) {
      if (_isUserInteraction) {
        // Skip the scrolling if it was caused by user interaction
        _isUserInteraction = false;
        return;
      }

      int newIndex = _findLyricsIndex(currentTimeValue);

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
      }
    });
  }

  // Load font sizes from SharedPreferences
  Future<void> _loadFontSizes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      arabicFontSize = prefs.getDouble('arabicFontSize') ?? 18.0;
      transliterationFontSize =
          prefs.getDouble('transliterationFontSize') ?? 16.0;
      translationFontSize = prefs.getDouble('translationFontSize') ?? 16.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemCount: widget.lyricsList.length,
      itemBuilder: (context, index) {
        final lyrics = widget.lyricsList[index];
        final isCurrentHighlighted = index == _currentHighlightedIndex;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (isCurrentHighlighted &&
                      widget.lyricsList[index].time.isNotEmpty)
                  ? const Color.fromARGB(255, 184, 229, 255)
                  : Colors.white,
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildLyricsContent(
                    lyrics,
                    controller.showArabic.value,
                    controller.showTransliteration.value,
                    controller.showTranslation.value),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildLyricsContent(Lyrics lyrics, bool showArabic,
      bool showTransliteration, bool showTranslation) {
    List<Widget> contentWidgets = [];
    switch (controller.selectedType.value.toLowerCase()) {
      case "arabic":
      case "અરબી":
        contentWidgets.addAll([
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildArabicText(lyrics, showArabic),
          ),
          const SizedBox(height: 8),
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildTransliterationText(lyrics, showTransliteration),
          ),
          const SizedBox(height: 8),
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildTranslationText(lyrics, showTranslation),
          ),
        ]);
        break;
      case "transliteration":
      case "તરજુમા":
        contentWidgets.addAll([
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildTransliterationText(lyrics, showTransliteration),
          ),
          const SizedBox(height: 8),
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildArabicText(lyrics, showArabic),
          ),
          const SizedBox(height: 8),
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildTranslationText(lyrics, showTranslation),
          ),
        ]);
        break;
      case "translation":
      case "ગુજરાતી":
        contentWidgets.addAll([
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildTranslationText(lyrics, showTranslation),
          ),
          const SizedBox(height: 8),
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildArabicText(lyrics, showArabic),
          ),
          const SizedBox(height: 8),
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildTransliterationText(lyrics, showTransliteration),
          ),
        ]);
        break;
      default:
        contentWidgets.addAll([
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildArabicText(lyrics, showArabic),
          ),
          const SizedBox(height: 8),
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildTransliterationText(lyrics, showTransliteration),
          ),
          const SizedBox(height: 8),
          GestureDetector(
        onTap: () => _seekToLyricsTime(lyrics.time),
        child: _buildTranslationText(lyrics, showTranslation),
          ),
        ]);
    }
    contentWidgets.add(const SizedBox(height: 10));
    return contentWidgets;
  }

  Widget _buildArabicText(Lyrics lyrics, bool showArabic) {
    final isArabicHighlighted =
        controller.selectedType.value.toLowerCase() == "arabic" ||
            controller.selectedType.value == "અરબી";

    if (lyrics.arabic.isEmpty || lyrics.arabic == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.arabic.isNotEmpty && showArabic,
      child: Text(
        _textCleanerController.cleanText(lyrics.arabic),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: isArabicHighlighted ? arabicFontSize + 6 : arabicFontSize,
            fontWeight:
                isArabicHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isArabicHighlighted ? Colors.black87 : Colors.black54,
            fontFamily: "MUHAMMADI"),
      ),
    );
  }

  Widget _buildTransliterationText(Lyrics lyrics, bool showTransliteration) {
    final isTransliterationHighlighted =
        controller.selectedType.value.toLowerCase() == "transliteration" ||
            controller.selectedType.value == "તરજુમા";
    if (lyrics.translitration.isEmpty || lyrics.translitration == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.translitration.isNotEmpty && showTransliteration,
      child: Text(
        _textCleanerController.cleanText(lyrics.translitration),
        style: TextStyle(
            fontSize: isTransliterationHighlighted
                ? transliterationFontSize + 4
                : transliterationFontSize,
            fontWeight: isTransliterationHighlighted
                ? FontWeight.bold
                : FontWeight.normal,
            color:
                isTransliterationHighlighted ? Colors.black87 : Colors.black54,
            fontFamily: fontFamily),
      ),
    );
  }

  void _seekToLyricsTime(String time) {
    Duration? seekPosition = _parseTimestamp(time);
    if (seekPosition != null) {
      audioController.seekTo(seekPosition);
      _isUserInteraction = true;
    }
  }

  Widget _buildTranslationText(Lyrics lyrics, bool showTranslation) {
    final isTranslationHighlighted =
        controller.selectedType.value.toLowerCase() == "translation" ||
            controller.selectedType.value == "ગુજરાતી";

    if (lyrics.translation.isEmpty || lyrics.translation == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }
    return Visibility(
      visible: lyrics.translation.isNotEmpty && showTranslation,
      child: Text(
        _textCleanerController.cleanText(lyrics.translation),
        style: TextStyle(
            fontSize: isTranslationHighlighted
                ? translationFontSize + 4
                : translationFontSize,
            fontWeight:
                isTranslationHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isTranslationHighlighted ? Colors.black87 : Colors.black54,
            fontFamily: fontFamily),
      ),
    );
  }

  int _findLyricsIndex(Duration currentPosition) {
    for (int i = 0; i < widget.lyricsList.length; i++) {
      final lyrics = widget.lyricsList[i];
      Duration? timeInMilliseconds = _parseTimestamp(lyrics.time);

      if (timeInMilliseconds == null) {
        continue; // Skip this loop iteration if timestamp is invalid
      }

      Duration nextTimeInMilliseconds = i < widget.lyricsList.length - 1
          ? _parseTimestamp(widget.lyricsList[i + 1].time) ??
              Duration(days: 100000) // Use a very large duration if null
          : Duration(days: 100000); // Use a fallback large duration

      // Highlighting logic as before
      if (currentPosition >= timeInMilliseconds &&
          currentPosition < nextTimeInMilliseconds) {
        return i;
      }
    }
    return -1;
  }

  Duration? _parseTimestamp(String time) {
    try {
      // Strip off the square brackets if present
      if (time.startsWith('[') && time.endsWith(']')) {
        time = time.substring(1, time.length - 1);
      }

      // Split into minutes and seconds.milliseconds
      var parts = time.split(':');
      if (parts.length == 2) {
        int minutes = int.tryParse(parts[0]) ?? 0;
        var secondsParts = parts[1].split('.');
        int seconds = int.tryParse(secondsParts[0]) ?? 0;
        int milliseconds = 0;

        // Check if there are milliseconds
        if (secondsParts.length > 1) {
          milliseconds = int.tryParse(secondsParts[1].padRight(3, '0')) ??
              0; // Pad to ensure milliseconds are correctly interpreted
        }

        return Duration(
            minutes: minutes, seconds: seconds, milliseconds: milliseconds);
      }
    } catch (e) {
      debugPrint('Error parsing timestamp: $e');
    }
    return null; // Return null if parsing fails
  }
}
