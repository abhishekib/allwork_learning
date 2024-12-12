import 'dart:developer';
import 'package:allwork/controllers/text_cleaner_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:allwork/modals/favourite_model.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/settings_page_view.dart';
import 'package:allwork/widgets/audio_player_widget.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:allwork/views/lyrics_tab.dart';
import 'package:allwork/controllers/favourite_controller.dart';

class CategoryDetailView extends StatefulWidget {
  const CategoryDetailView({super.key});

  @override
  _CategoryDetailViewState createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<CategoryDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? currentAudioUrl;
  final TextCleanerController _textCleanerController = TextCleanerController();
  late Category categoryDetails;
  late List<String> availableTypes;
  late Map<String, List<Lyrics>> availableLyrics;
  String selectedLanguage = 'English';
  late String menuItem;

  @override
  void initState() {
    super.initState();
    Get.put(FavouriteController());
    final dynamic data = Get.arguments;
    if (data is Map<String, dynamic>) {
      categoryDetails = data['category'] as Category;
      selectedLanguage = data['language'] as String;
      menuItem = data['menuItem'] as String;
    } else if (data is FavouriteModel) {
      categoryDetails = Category(
        category: "",
        id: 0,
        title: data.title,
        isFav: "",
        cdata: data.cdata,
      );
    } else {
      categoryDetails = Category(
        category: '',
        id: 0,
        title: 'No data',
        isFav: 'No',
        cdata: [],
      );
    }

    final cdata = categoryDetails.cdata;

    availableTypes = cdata
        .where((e) => e.lyrics.isNotEmpty)
        .map((e) => e.type)
        .toSet()
        .toList();

    availableLyrics = {
      for (var item in cdata)
        if (item.lyrics.isNotEmpty) item.type: item.lyrics
    };

    _tabController = TabController(length: availableTypes.length, vsync: this);

    final String? initialAudioUrl =
        cdata.isNotEmpty && cdata[0].audiourl.isNotEmpty
            ? cdata[0].audiourl
            : null;

    currentAudioUrl = initialAudioUrl;

    _tabController.addListener(() {
      final selectedIndex = _tabController.index;
      final String? newAudioUrl = cdata[selectedIndex].audiourl.isNotEmpty
          ? cdata[selectedIndex].audiourl
          : null;

      if (newAudioUrl != currentAudioUrl) {
        setState(() {
          currentAudioUrl = newAudioUrl;
        });
        Get.find<CategoryDetailController>().initializeAudio(newAudioUrl ?? "");
      }
    });
    log("---You are in CategoryDetailView---");
  }

  void addToFavourite() async {
    try {
      final favouriteController = Get.find<FavouriteController>();

      int itemId = categoryDetails.id;
      log("$itemId");

      await favouriteController.addToFavourite(menuItem, itemId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to favorites!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding to favorites: $e")),
      );
      log("$e");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontFamily = selectedLanguage == 'English' ? 'Roboto' : 'Gopika';

    final CategoryDetailController controller =
        Get.put(CategoryDetailController());

    if (availableTypes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _textCleanerController.cleanText(categoryDetails.title),
            style: TextStyle(
              fontFamily: fontFamily,
            ),
          ),
        ),
        body: const Center(child: Text("No data available")),
      );
    }

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            _textCleanerController.cleanText(categoryDetails.title),
            style: AppTextStyles.customStyle(
              fontFamily: fontFamily,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.up,
          distance: 50,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.black.withOpacity(0.5),
            blur: 5,
          ),
          children: [
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.share),
              onPressed: () {
                // Implement share functionality
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.copy),
              onPressed: () {
                // Call the copy functionality from LyricsTab
                _copyAllLyricsToClipboard(
                    context, availableLyrics, categoryDetails.title);
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.favorite),
              onPressed: () {
                addToFavourite();
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.access_alarm),
              onPressed: () {
                // Implement favorite functionality
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.settings),
              onPressed: () {
                Get.to(SettingsPage());
              },
            ),
          ],
        ),
        body: DefaultTabController(
          length: availableTypes.length,
          child: Column(
            children: [
              if (currentAudioUrl != null && currentAudioUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AudioPlayerWidget(
                    audioUrl: currentAudioUrl!,
                    onPositionChanged: (currentPosition) {
                      controller.currentTime.value =
                          currentPosition.inMilliseconds.toDouble();
                    },
                  ),
                ),
              const SizedBox(height: 10),
              TabBar(
                isScrollable: true,
                automaticIndicatorColorAdjustment: true,
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                labelStyle: AppTextStyles.whiteBoldText,
                unselectedLabelStyle: TextStyle(color: Colors.white70),
                indicatorColor: Colors.white,
                onTap: (index) {
                  controller.changeType(availableTypes[index]);
                },
                tabs: availableTypes.map((type) => Tab(text: type)).toList(),
              ),
              const SizedBox(height: 10),
              Flexible(
                fit: FlexFit.loose,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: availableTypes.map((type) {
                    final List<Lyrics> lyricsList = availableLyrics[type] ?? [];
                    return LyricsTab(
                        lyricsList: lyricsList,
                        selectedLanguage: selectedLanguage);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyAllLyricsToClipboard(BuildContext context,
      Map<String, List<Lyrics>> availableLyrics, String categoryTitle) {
    final allLyrics =
        availableLyrics.values.expand((lyricsList) => lyricsList).toList();

    Set<Lyrics> uniqueLyricsSet = {};

    for (var lyrics in allLyrics) {
      uniqueLyricsSet.add(lyrics);
    }

    String combinedLyrics =
        '${_textCleanerController.cleanText(categoryTitle)}\n\n';

    for (var lyrics in uniqueLyricsSet) {
      combinedLyrics += '${_textCleanerController.cleanText(lyrics.arabic)}\n';
      combinedLyrics +=
          '${_textCleanerController.cleanText(lyrics.translitration)}\n\n';
      combinedLyrics +=
          '${_textCleanerController.cleanText(lyrics.translation)}\n';
    }

    Clipboard.setData(ClipboardData(text: combinedLyrics));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All lyrics copied to clipboard!")),
    );
  }
}
