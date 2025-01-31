import 'dart:developer';
import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/entities/bookmark_data_entity.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:allwork/modals/favourite_model.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/login_view.dart';
import 'package:allwork/views/settings_page_view.dart';
import 'package:allwork/widgets/audio_player_widget.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:allwork/views/lyrics_tab.dart';
import 'package:allwork/controllers/favourite_controller.dart';
import 'package:share_plus/share_plus.dart';

class CategoryDetailView extends StatefulWidget {
  const CategoryDetailView({super.key});

  @override
  CategoryDetailViewState createState() => CategoryDetailViewState();
}

class CategoryDetailViewState extends State<CategoryDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? currentAudioUrl;
  bool isAudioDownloaded = false;
  final LoginController _loginController = Get.put(LoginController());
  // final AudioController _audioController = Get.find<AudioController>();
  final AudioController _audioController = Get.put(AudioController());

  late Category categoryDetails;
  late List<String> availableTypes;
  late int currentContentDataId;
  late Map<String, List<Lyrics>> availableLyrics;
  String selectedLanguage = 'English';
  late String menuItem;
  late bool isBookmarked;
  bool fromBookmark = false;
  int bookmarkedTab = 0;
  int bookmarkedLyricsIndex = -1;
  @override
  void initState() {
    super.initState();
    Get.put(FavouriteController());
    final dynamic data = Get.arguments;

    if (data is Map<String, dynamic>) {
      categoryDetails = data['category'] as Category;
      selectedLanguage = data['language'] as String;
      menuItem = data['menuItem'] as String;
      if (data['fromBookmark'] == true) {
        log("Navigating from bookmark");
        isBookmarked = true;
        bookmarkedTab = data['bookmarkedTab'];
        bookmarkedLyricsIndex = data['lyricsIndex'];
        fromBookmark = data['fromBookmark'];
      } else {
        if (DbServices.instance.isBookmarked(categoryDetails.title)) {
          isBookmarked = true;
          log("Is not navigating from bookmark but is bookmarked");
          BookmarkDataEntity bookmarkData =
          DbServices.instance.getBookmarkData(categoryDetails.title)!;
          bookmarkedTab = bookmarkData.lyricsType;
          bookmarkedLyricsIndex = bookmarkData.lyricsIndex;
        } else {
          log("No bookmarks present here");
          isBookmarked = false;
        }

        log(isBookmarked.toString());
      }
    } else if (data is FavouriteModel) {
      categoryDetails = Category(
        category: "",
        id: 0,
        title: data.title,
        isFav: "",
        cdata: data.cdata,
      );
    } else {
      log("From unknown");
      categoryDetails = Category(
        category: '',
        id: 0,
        title: 'No data',
        link: data.link.toString(),
        isFav: 'No',
        cdata: [],
      );
    }

    final cdata = categoryDetails.cdata;

    availableTypes = cdata!
        .where((e) => e.lyrics.isNotEmpty)
        .map((e) => e.type)
        .toSet()
        .toList();

    availableLyrics = {
      for (var item in cdata!)
        if (item.lyrics.isNotEmpty) item.type: item.lyrics
    };

    _tabController = TabController(length: availableTypes.length, vsync: this);


    log("Let's check the audio offline path ${cdata[0].offlineAudioPath}");

    if (cdata!.isNotEmpty && cdata[0].offlineAudioPath != null) {
      isAudioDownloaded = true;
      log("Audio is already downloaded");
    }

    final String? initialAudioUrl = isAudioDownloaded
        ? cdata[0].offlineAudioPath!
        : cdata[0].audiourl.isNotEmpty
            ? cdata[0].audiourl
            : null;

    currentContentDataId = cdata![0].id ?? 0;

    currentAudioUrl = initialAudioUrl;

    log("initial Audio Url $currentAudioUrl");

    _tabController.addListener(() {
      final selectedIndex = _tabController.index;
      final String? newAudioUrl = cdata![selectedIndex].offlineAudioPath != null
          ? cdata[selectedIndex].offlineAudioPath!
          : cdata[selectedIndex].audiourl.isNotEmpty
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to favorites!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding to favorites: $e")),
        );
      }
      log("$e");
    }
  }

  void _handleAddToFavourite() {
    if (_loginController.isLoggedIn.value) {
      addToFavourite();
    } else {
      _showLoginPrompt();
    }
  }

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Required"),
          content: const Text("Please log in to add this item to favorites."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Get.to(() => LoginView()); // Navigate to login screen
              },
              child: const Text("Login"),
            ),
          ],
        );
      },
    );
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
            TextCleanerService.cleanText(categoryDetails.title),
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
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            TextCleanerService.cleanText(categoryDetails.title),
            style: AppTextStyles.customStyle(
              fontFamily: fontFamily,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.settings, color: Colors.white),
              onSelected: (value) {
                // No action required here as state is managed by GetX
              },
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 1,
                  child: Obx(() => SwitchListTile(
                        title: const Text("Show Arabic"),
                        value: controller.showArabic.value,
                        onChanged: (value) {
                          controller.showArabic.value = value;
                          Navigator.pop(
                              context); // Close the menu after selection
                        },
                      )),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Obx(() => SwitchListTile(
                        title: const Text("Show Transliteration"),
                        value: controller.showTransliteration.value,
                        onChanged: (value) {
                          controller.showTransliteration.value = value;
                          Navigator.pop(
                              context); // Close the menu after selection
                        },
                      )),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Obx(() => SwitchListTile(
                        title: const Text("Show Translation"),
                        value: controller.showTranslation.value,
                        onChanged: (value) {
                          controller.showTranslation.value = value;
                          Navigator.pop(
                              context); // Close the menu after selection
                        },
                      )),
                ),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.fan,
          distance: 180,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.black.withOpacity(0.5),
            blur: 1,
          ),
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu),
            fabSize: ExpandableFabSize.small,
            shape: const CircleBorder(),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const Icon(Icons.close),
            fabSize: ExpandableFabSize.small,
            shape: const CircleBorder(),
          ),
          children: [
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.share),
              onPressed: () {
                Share.shareUri(Uri.parse(categoryDetails.link!));
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
              onPressed: _handleAddToFavourite,
              child: const Icon(Icons.favorite),
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.access_alarm),
              onPressed: () {
                // Implement favorite functionality
                BottomPicker.dateTime(
                  pickerTitle: Text(
                    'Set the event exact time and date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  onSubmit: (date) {
                    log(date.toString());
                    controller.scheduleNotification(
                        date, categoryDetails.title);
                  },
                  onClose: () {
                    Navigator.pop(context);
                  },
                  minDateTime: DateTime.now(),
                  initialDateTime: DateTime.now(),
                  buttonSingleColor: Colors.pink,
                ).show(context);
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
                    controller: _audioController,
                    downloaded: isAudioDownloaded,
                    audioUrl: currentAudioUrl!,
                    cDataId: currentContentDataId,
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
                // tabs: availableTypes.map((type) => Tab(text: type)).toList(),
                tabs: availableTypes.map((type) {
                  String tabLabel = type;
                  if (selectedLanguage == 'ગુજરાતી') {
                    switch (type.toLowerCase()) {
                      case 'arabic' || 'Arabic':
                        tabLabel = 'અરબી';
                        break;
                      case 'transliteration' || 'Transliteration':
                        tabLabel = 'ગુજરાતી';
                        break;
                      case 'translation' || 'Translation':
                        tabLabel = 'તરજુમા';
                        break;
                    }
                  }
                  return Tab(text: tabLabel);
                }).toList(),
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
                        isBookmarked: isBookmarked,
                        fromBookmark: fromBookmark,
                        bookmarkedTab: bookmarkedTab,
                        bookmarkedLyricsIndex: bookmarkedLyricsIndex,
                        lyricsList: lyricsList,
                        tabIndex: availableTypes.indexOf(type),
                        selectedLanguage: selectedLanguage,
                        categoryDetails: categoryDetails);
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
        '${TextCleanerService.cleanText(categoryTitle)}\n\n';

    for (var lyrics in uniqueLyricsSet) {
      combinedLyrics += '${TextCleanerService.cleanText(lyrics.arabic)}\n';
      combinedLyrics +=
          '${TextCleanerService.cleanText(lyrics.translitration)}\n\n';
      combinedLyrics += '${TextCleanerService.cleanText(lyrics.translation)}\n';
    }

    Clipboard.setData(ClipboardData(text: combinedLyrics));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All lyrics copied to clipboard!")),
    );
  }

  void _shareAllLyrics(BuildContext context,
      Map<String, List<Lyrics>> availableLyrics, String categoryTitle) {
    final allLyrics =
        availableLyrics.values.expand((lyricsList) => lyricsList).toList();

    Set<Lyrics> uniqueLyricsSet = {};

    for (var lyrics in allLyrics) {
      uniqueLyricsSet.add(lyrics);
    }

    String combinedLyrics =
        '${TextCleanerService.cleanText(categoryTitle)}\n\n';

    for (var lyrics in uniqueLyricsSet) {
      combinedLyrics += '${TextCleanerService.cleanText(lyrics.arabic)}\n';
      combinedLyrics +=
          '${TextCleanerService.cleanText(lyrics.translitration)}\n\n';
      combinedLyrics +=
          '${TextCleanerService.cleanText(lyrics.translation)}\n\n';
    }

    Share.share(combinedLyrics, subject: categoryTitle);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sharing lyrics...")),
    );
  }
}
