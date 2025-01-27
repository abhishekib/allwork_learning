import 'package:allwork/controllers/category_list_controller.dart';
import 'package:allwork/controllers/text_cleaner_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:allwork/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LyricsTab extends StatefulWidget {
  final List<Lyrics> lyricsList;
  final String selectedLanguage;
  final Category categoryDetails;
  final int lyricsIndex;

  const LyricsTab(
      {super.key,
      required this.lyricsIndex,
      required this.lyricsList,
      required this.selectedLanguage,
      required this.categoryDetails});

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
      initialScrollIndex: widget.lyricsIndex,
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
          _buildArabicText(lyrics, showArabic),
          // const SizedBox(height: 8),
          _buildTransliterationText(lyrics, showTransliteration),
          // const SizedBox(height: 8),
          _buildTranslationText(lyrics, showTranslation),
          // const SizedBox(height: 8),
          _buildEnglishText(lyrics),
          _getBookmarkWidget(widget.lyricsList.indexOf(lyrics), 0)
        ]);
        break;
      case "transliteration":
      case "તરજુમા":
        contentWidgets.addAll([
          _buildTransliterationText(lyrics, showTransliteration),
          // const SizedBox(height: 8),
          _buildArabicText(lyrics, showArabic),
          // const SizedBox(height: 8),
          _buildTranslationText(lyrics, showTranslation),
          // const SizedBox(height: 8),
          _buildEnglishText(lyrics),
          _getBookmarkWidget(widget.lyricsList.indexOf(lyrics), 1)
        ]);
        break;
      case "translation":
      case "ગુજરાતી":
        contentWidgets.addAll([
          _buildTranslationText(lyrics, showTranslation),
          // const SizedBox(height: 8),
          _buildArabicText(lyrics, showArabic),
          // const SizedBox(height: 8),
          _buildTransliterationText(lyrics, showTransliteration),
          // const SizedBox(height: 8),
          _buildEnglishText(lyrics),
          _getBookmarkWidget(widget.lyricsList.indexOf(lyrics), 2)
        ]);
        break;
      default:
        contentWidgets.addAll([
          _buildArabicText(lyrics, showArabic),
          // const SizedBox(height: 8),
          _buildTransliterationText(lyrics, showTransliteration),
          // const SizedBox(height: 8),
          _buildTranslationText(lyrics, showTranslation),
          // const SizedBox(height: 8),
          _buildEnglishText(lyrics),
          _getBookmarkWidget(widget.lyricsList.indexOf(lyrics), 0)
        ]);
    }
    contentWidgets.add(const SizedBox(height: 10));
    return contentWidgets;
  }

  Widget _buildEnglishText(Lyrics lyrics) {
    if (lyrics.english != null &&
        (lyrics.english!.isEmpty || lyrics.english?.trim() == "&nbsp;")) {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.english != null && lyrics.english!.isNotEmpty,
      child: Html(
        data: lyrics.english ?? '',
        style: {
          "html": Style(
            alignment: Alignment.center,
            fontSize: FontSize(20),
            textAlign: TextAlign.center,
            direction: TextDirection.ltr,
            color: Colors.black54,
            // fontWeight: FontWeight.bold,
          ),
        },
      ),
    );
  }

  Widget _buildArabicText(Lyrics lyrics, bool showArabic) {
    final isArabicHighlighted =
        controller.selectedType.value.toLowerCase() == "arabic" ||
            controller.selectedType.value == "અરબી";

    if (lyrics.arabic.isEmpty || lyrics.arabic.trim() == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.arabic.isNotEmpty && showArabic,
      child: Html(
        data: lyrics.arabic,
        style: {
          "html": Style(
            fontSize: FontSize(
                isArabicHighlighted ? arabicFontSize + 6 : arabicFontSize),
            fontWeight:
                isArabicHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isArabicHighlighted ? Colors.black87 : Colors.black54,
            textAlign: TextAlign.start,
            direction: TextDirection.rtl,
            fontFamily: "MUHAMMADI",
          ),
        },
      ),
    );
  }

  Widget _buildTransliterationText(Lyrics lyrics, bool showTransliteration) {
    final isTransliterationHighlighted =
        controller.selectedType.value.toLowerCase() == "transliteration" ||
            controller.selectedType.value == "તરજુમા";

    if (lyrics.translitration.isEmpty ||
        lyrics.translitration.trim() == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.translitration.isNotEmpty && showTransliteration,
      child: Html(
        data: lyrics.translitration,
        style: {
          "html": Style(
            fontSize: FontSize(isTransliterationHighlighted
                ? transliterationFontSize + 4
                : transliterationFontSize),
            fontWeight: isTransliterationHighlighted
                ? FontWeight.bold
                : FontWeight.normal,
            color:
                isTransliterationHighlighted ? Colors.black87 : Colors.black54,
            fontFamily: fontFamily,
          ),
        },
      ),
    );
  }

  Widget _buildTranslationText(Lyrics lyrics, bool showTranslation) {
    final isTranslationHighlighted =
        controller.selectedType.value.toLowerCase() == "translation" ||
            controller.selectedType.value == "ગુજરાતી";

    if (lyrics.translation.isEmpty || lyrics.translation.trim() == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.translation.isNotEmpty && showTranslation,
      child: Html(
        data: lyrics.translation,
        style: {
          "html": Style(
            fontSize: FontSize(isTranslationHighlighted
                ? translationFontSize + 4
                : translationFontSize),
            fontWeight:
                isTranslationHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isTranslationHighlighted ? Colors.black87 : Colors.black54,
            fontFamily: fontFamily,
          ),
        },
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

      // Skip highlighting if the timestamp is empty or invalid
      if (timeInMilliseconds == null) {
        continue;
      }

      // Ensure time is valid before scrolling
      if (currentPosition >= timeInMilliseconds &&
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

  Widget _getBookmarkWidget(int index, int lyricType) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.backgroundBlue,
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        child: Icon(
          Icons.bookmark_border,
          color: Colors.white,
          size: 16,
        ),
        onTap: () {
          CategoryListController categoryListController =
              CategoryListController();
          categoryListController.saveCategoryListDetail(
              widget.categoryDetails, lyricType, index);
          Get.back();
          // log(category.toString());
        },
      ),
    );
  }
}
