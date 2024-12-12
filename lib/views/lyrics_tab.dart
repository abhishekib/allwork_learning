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
  _LyricsTabState createState() => _LyricsTabState();
}

class _LyricsTabState extends State<LyricsTab> {
  final CategoryDetailController controller =
      Get.find<CategoryDetailController>();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final TextCleanerController _textCleanerController = TextCleanerController();

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
    ever(controller.currentTime, (currentTimeValue) {
      if (_isUserInteraction) {
        // Skip the scrolling if it was caused by user interaction
        _isUserInteraction = false;
        return;
      }

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
              color: isCurrentHighlighted ? Colors.white : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildLyricsContent(lyrics),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildLyricsContent(Lyrics lyrics) {
    List<Widget> contentWidgets = [];
    switch (controller.selectedType.value.toLowerCase()) {
      case "arabic":
      case "અરબી":
        contentWidgets.addAll([
          _buildArabicText(lyrics),
          const SizedBox(height: 8),
          _buildTransliterationText(lyrics),
          const SizedBox(height: 8),
          _buildTranslationText(lyrics),
        ]);
        break;
      case "translation":
        contentWidgets.addAll([
          _buildTranslationText(lyrics),
          const SizedBox(height: 8),
          _buildArabicText(lyrics),
          const SizedBox(height: 8),
          _buildTransliterationText(lyrics),
        ]);
        break;
      case "ગુજરાતી":
        contentWidgets.addAll([
          _buildTransliterationText(lyrics),
          const SizedBox(height: 8),
          _buildArabicText(lyrics),
          const SizedBox(height: 8),
          _buildTranslationText(lyrics),
        ]);
        break;
      case "transliteration":
        contentWidgets.addAll([
          _buildTransliterationText(lyrics),
          const SizedBox(height: 8),
          _buildArabicText(lyrics),
          const SizedBox(height: 8),
          _buildTranslationText(lyrics),
        ]);
        break;
      case "તરજુમા":
        contentWidgets.addAll([
          _buildTranslationText(lyrics),
          const SizedBox(height: 8),
          _buildArabicText(lyrics),
          const SizedBox(height: 8),
          _buildTransliterationText(lyrics),
        ]);
        break;

      default:
        contentWidgets.addAll([
          _buildArabicText(lyrics),
          const SizedBox(height: 8),
          _buildTransliterationText(lyrics),
          const SizedBox(height: 8),
          _buildTranslationText(lyrics),
        ]);
    }
    contentWidgets.add(const SizedBox(height: 10));
    return contentWidgets;
  }

  Widget _buildArabicText(Lyrics lyrics) {
    final isArabicHighlighted =
        controller.selectedType.value.toLowerCase() == "arabic" ||
            controller.selectedType.value == "અરબી";

    if (lyrics.arabic.isEmpty || lyrics.arabic == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.arabic.isNotEmpty,
      child: Text(
        _textCleanerController.cleanText(lyrics.arabic),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: isArabicHighlighted ? arabicFontSize + 6 : arabicFontSize,
          fontWeight: isArabicHighlighted ? FontWeight.bold : FontWeight.normal,
          color: isArabicHighlighted ? Colors.black87 : Colors.black54,
          fontFamily: "MUHAMMADI",
        ),
      ),
    );
  }

  Widget _buildTransliterationText(Lyrics lyrics) {
    final isTransliterationHighlighted =
        controller.selectedType.value.toLowerCase() == "transliteration" ||
            controller.selectedType.value == "ગુજરાતી";
    if (lyrics.translitration.isEmpty || lyrics.translitration == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.translitration.isNotEmpty,
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

  Widget _buildTranslationText(Lyrics lyrics) {
    final isTranslationHighlighted =
        controller.selectedType.value.toLowerCase() == "translation" ||
            controller.selectedType.value == "તરજુમા";

    if (lyrics.translation.isEmpty || lyrics.translation == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }
    return Visibility(
      visible: lyrics.translation.isNotEmpty,
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

  int _findLyricsIndex(int currentPosition) {
    for (int i = 0; i < widget.lyricsList.length; i++) {
      final lyrics = widget.lyricsList[i];
      final timeInMilliseconds = _parseTimestamp(lyrics.time);
      final nextTimeInMilliseconds = i < widget.lyricsList.length - 1
          ? _parseTimestamp(widget.lyricsList[i + 1].time)
          : 9223372036854775807;

      // Ensure time is valid before scrolling
      if (timeInMilliseconds != null &&
          currentPosition >= timeInMilliseconds &&
          currentPosition < nextTimeInMilliseconds!) {
        return i;
      }
    }
    return -1;
  }

  int? _parseTimestamp(String time) {
    try {
      if (!time.startsWith('[') || !time.endsWith(']')) {
        return null;
      }

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
        return parsedTime;
      }
    } catch (e) {
      debugPrint('Error parsing timestamp: $e');
    }
    return 0;
  }
}
