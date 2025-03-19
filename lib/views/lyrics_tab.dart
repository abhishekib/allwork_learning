import 'dart:developer';

import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:allwork/controllers/settings_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:allwork/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricsTab extends StatefulWidget {
  final List<Lyrics> lyricsList;
  final String selectedLanguage;
  final Category categoryDetails;
  final int tabIndex;
  final String menuItem;
  bool isBookmarked;
  final bool fromBookmark;
  int? bookmarkedLyricsIndex;
  int? bookmarkedTab;

  LyricsTab({
    super.key,
    required this.lyricsList,
    required this.selectedLanguage,
    required this.categoryDetails,
    //tabIndex to keep track of the tab the lyrics list is in
    required this.tabIndex,
    //menuItem to keep track of the menu item
    required this.menuItem,
    //isBookmarked - whether the lyrics is bookmarked or not
    required this.isBookmarked,
    //fromBookmark - whether the navigation is coming from bookmark or not
    required this.fromBookmark,
    //bookmarkedTab to keep the bookmarked tab
    this.bookmarkedTab,
    //lyrics index for bookmark lyric
    this.bookmarkedLyricsIndex,
  }) {
    log("Lyrics Tab created for tab index $tabIndex");

    log("bookmarked lyric number: $bookmarkedLyricsIndex");
  }

  @override
  LyricsTabState createState() => LyricsTabState();
}

class LyricsTabState extends State<LyricsTab> {
  final CategoryDetailController controller =
      Get.find<CategoryDetailController>();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final AudioController audioController = Get.find<AudioController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  int _currentHighlightedIndex = 0;
  bool _isUserInteraction = false;

  late String fontFamily;

  @override
  void initState() {
    super.initState();
    controller.onReset();

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
  

  @override
  Widget build(BuildContext context) {
    log("bookmark coming in lyrics tab widget ${widget.fromBookmark}");
    return ScrollablePositionedList.builder(
      initialScrollIndex:
          widget.fromBookmark ? widget.bookmarkedLyricsIndex! : 0,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemCount: widget.lyricsList.length,
      itemBuilder: (context, index) {
        final lyrics = widget.lyricsList[index];
        final isCurrentHighlighted = index == _currentHighlightedIndex;
        if ((lyrics.arabic == "&nbsp;" &&
                lyrics.translation == "&nbsp;" &&
                lyrics.translitration == "&nbsp;") ||
            (lyrics.arabic == "" &&
                lyrics.translation == "" &&
                lyrics.translitration == "")) {
          return Visibility(visible: false, child: Container());
        }
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
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            _getBookmarkWidget(
                widget.lyricsList.indexOf(lyrics), widget.tabIndex)
          ]),
          _buildEnglishText(lyrics),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildArabicText(lyrics, showArabic),
          ),
          // const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildTransliterationText(lyrics, showTransliteration),
          ),
          // const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildTranslationText(lyrics, showTranslation),
            // const SizedBox(height: 8),
          ),
        ]);
        break;
      case "transliteration":
      case "તરજુમા":
        contentWidgets.addAll([
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            _getBookmarkWidget(
                widget.lyricsList.indexOf(lyrics), widget.tabIndex)
          ]),
          _buildEnglishText(lyrics),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildTransliterationText(lyrics, showTransliteration),
          ),
          // const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildArabicText(lyrics, showArabic),
          ),
          // const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildTranslationText(lyrics, showTranslation),
            // const SizedBox(height: 8),
          ),
        ]);
        break;
      case "translation":
      case "ગુજરાતી":
        contentWidgets.addAll([
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            _getBookmarkWidget(
                widget.lyricsList.indexOf(lyrics), widget.tabIndex)
          ]),
          _buildEnglishText(lyrics),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildTranslationText(lyrics, showTranslation),
          ),
          // const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildArabicText(lyrics, showArabic),
          ),
          // const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildTransliterationText(lyrics, showTransliteration),
            // const SizedBox(height: 8),
          ),
        ]);
        break;
      default:
        contentWidgets.addAll([
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            _getBookmarkWidget(widget.lyricsList.indexOf(lyrics), 0)
          ]),
          _buildEnglishText(lyrics),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildArabicText(lyrics, showArabic),
          ),
          // const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildTransliterationText(lyrics, showTransliteration),
          ),
          // const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seekToLyricsTime(lyrics.time),
            child: _buildTranslationText(lyrics, showTranslation),
            // const SizedBox(height: 8),
          )
        ]);
    }
    contentWidgets.add(const SizedBox(height: 10));
    return contentWidgets;
  }

  Widget _buildEnglishText(Lyrics lyrics) {
    log("--------------widget.menuItem : ${widget.menuItem}-------------");

    if (lyrics.english != null &&
        (lyrics.english!.isEmpty || lyrics.english?.trim() == "&nbsp;")) {
      return Visibility(visible: false, child: SizedBox.shrink());
    }
    log("lyrics.english : ${lyrics.english}");
    return Visibility(
      //visible: lyrics.english != null && lyrics.english!.isNotEmpty,
      child: Html(
        data: lyrics.english ?? '',
        onLinkTap: (String? url, _, __) async {
          if (url != null) {
            final uri = Uri.parse(url);
            try {
              controller.tapDeepLink(url);
            } catch (e) {
              debugPrint('Could not launch $url: $e');
            }
          }
        },
        style: {
          "html": Style(
            // alignment: Alignment.lef,
            fontSize: FontSize(20),
            textAlign: widget.menuItem == "સુરાહ" ||
                    widget.menuItem == "Surah" ||
                    widget.menuItem == "Juzz / Siparah" ||
                    widget.menuItem == "surah-english" ||
                    widget.menuItem == "surah-gujarati"
                ? TextAlign.right
                : TextAlign.left,
            direction: widget.menuItem == "સુરાહ" || widget.menuItem == "Surah"
                ? TextDirection.rtl
                : TextDirection.ltr,
            color: Colors.red,
            fontWeight: FontWeight.bold,
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
        onLinkTap: (String? url, _, __) async {
          if (url != null) {
            final uri = Uri.parse(url);
            try {
              controller.tapDeepLink(url);
            } catch (e) {
              debugPrint('Could not launch $url: $e');
            }
          }
        },
        style: {
          "html": Style(
            fontSize: FontSize(isArabicHighlighted
                ? settingsController.arabicFontSize.value + 6
                : settingsController.arabicFontSize.value),
            fontWeight:
                isArabicHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isArabicHighlighted ? Colors.black87 : Colors.black54,
            textAlign: TextAlign.start,
            direction: TextDirection.rtl,
            fontFamily: "MUHAMMADI",
            wordSpacing: 10,
            textOverflow: TextOverflow.visible,
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
        onLinkTap: (String? url, _, __) async {
          if (url != null) {
            final uri = Uri.parse(url);
            try {
              controller.tapDeepLink(url);
            } catch (e) {
              debugPrint('Could not launch $url: $e');
            }
          }
        },
        style: {
          "html": Style(
            fontSize: FontSize(isTransliterationHighlighted
                ? settingsController.transliterationFontSize.value + 4
                : settingsController.transliterationFontSize.value),
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

    if (lyrics.translation.isEmpty || lyrics.translation.trim() == "&nbsp;") {
      return Visibility(visible: false, child: SizedBox.shrink());
    }

    return Visibility(
      visible: lyrics.translation.isNotEmpty && showTranslation,
      child: Html(
        data: lyrics.translation,
        onLinkTap: (String? url, _, __) async {
          if (url != null) {
            final uri = Uri.parse(url);
            try {
              controller.tapDeepLink(url);
            } catch (e) {
              debugPrint('Could not launch $url: $e');
            }
          }
        },
        style: {
          "html": Style(
            fontSize: FontSize(isTranslationHighlighted
                ? settingsController.translationFontSize.value + 4
                : settingsController.translationFontSize.value),
            fontWeight:
                isTranslationHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isTranslationHighlighted ? Colors.black87 : Colors.black54,
            fontFamily: fontFamily,
          ),
        },
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
    return null;
  }

  Widget _getBookmarkWidget(int index, int lyricType) {
    // log("Lyric index : $index");
    // log("Tab number : $lyricType");
    // log("Tab number coming from bookmark : ${widget.bookmarkedTab}");
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: widget.isBookmarked &&
                index == widget.bookmarkedLyricsIndex &&
                lyricType == widget.bookmarkedTab
            ? Colors.red
            : AppColors.backgroundBlue,
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        child: Icon(
          Icons.bookmark_border,
          color: Colors.white,
          size: 16,
        ),
        onTap: () {
          if (index == widget.bookmarkedLyricsIndex &&
              lyricType == widget.bookmarkedTab) {
            controller.removeBookmark(
                widget.categoryDetails, widget.fromBookmark);
            setState(() {
              widget.bookmarkedLyricsIndex = -1;
              widget.bookmarkedTab = -1;
              widget.isBookmarked = false;
              log("On bookmarked lyric");
            });
          } else {
            controller.bookmarkLyric(widget.categoryDetails, lyricType, index);
            setState(() {
              widget.bookmarkedLyricsIndex = index;
              widget.isBookmarked = true;
              widget.bookmarkedTab = lyricType;
              log("on not bookmarked lyric");
            });
          }

          // log(category.toString());
        },
      ),
    );
  }
}
