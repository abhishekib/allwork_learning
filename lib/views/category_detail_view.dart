import 'dart:developer';
import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/entities/bookmark_reminder_data_entity.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:allwork/modals/favourite_model.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/login_view.dart';
import 'package:allwork/views/settings_page_view.dart';
import 'package:allwork/widgets/audio_player_widget.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:day_picker/day_picker.dart';
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
  // final AudioController _audioController = Get.find<AudioController>();
  final AudioController _audioController = Get.put(AudioController());

  late final CategoryDetailController controller;
  late Category categoryDetails;
  late List<String> availableTypes;
  late int currentContentDataId;
  late Map<String, List<Lyrics>> availableLyrics;
  String selectedLanguage = 'English';
  String menuItem = '';
  bool isBookmarked = false;
  bool fromBookmark = false;
  int bookmarkedTab = 0;
  int bookmarkedLyricsIndex = -1;
  @override
  void initState() {
    super.initState();
    Get.put(FavouriteController());

    controller = Get.put(CategoryDetailController());

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
    } else {
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

    if (fromBookmark) {
      log("bookmarkedTab $bookmarkedTab");
      //_tabController.animateTo(bookmarkedTab);
      log("availableTypes length ${availableTypes.length}");
      _tabController.index = bookmarkedTab;
      controller.changeType(availableTypes[bookmarkedTab]);

      currentAudioUrl = cdata[bookmarkedTab].audiourl;
      currentContentDataId = bookmarkedTab;
    } else {
      currentAudioUrl = cdata[0].audiourl;
      currentContentDataId = 0;
    }

    _tabController.addListener(() {
      final selectedIndex = _tabController.index;
      log("Tab changed to $selectedIndex");
      final String newAudioUrl = cdata[selectedIndex].audiourl;
      
      log("New audio url is $newAudioUrl");
      log("boolean values ${newAudioUrl.isNotEmpty.toString()}");
      // if (newAudioUrl != currentAudioUrl && newAudioUrl.isNotEmpty) {
      //   log("Setting state");
      setState(() {
        currentAudioUrl = newAudioUrl;
      });
      controller.initializeAudio(newAudioUrl);
    });
    //});

    // log("Let's check the audio offline path ${cdata[0].offlineAudioPath}");

    // if (cdata!.isNotEmpty &&
    //     cdata[0].offlineAudioPath != null &&
    //     cdata[0].offlineAudioPath!.isNotEmpty) {
    //   isAudioDownloaded = true;
    //   log("Audio is already downloaded");
    //   log("Audio path is ${cdata[0].offlineAudioPath}");
    // }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontFamily = selectedLanguage == 'English' ? 'Roboto' : 'Gopika';

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

    log("Re build Screen");
    log("Current audio url is ${currentAudioUrl?.isNotEmpty}");
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              TextCleanerService.cleanText(categoryDetails.title),
              style: AppTextStyles.customStyle(
                fontFamily: fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                controller.copyAllLyricsToClipboard(
                    context, availableLyrics, categoryDetails.title);
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () => controller.handleAddToFavourite(
                  context, categoryDetails, menuItem),
              child: const Icon(Icons.favorite),
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.access_alarm),
              onPressed: () async {
                // Implement favorite functionality
                // BottomPicker.dateTime(
                //   pickerTitle: Text(
                //     'Set the event exact time and date',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 15,
                //       color: Colors.black,
                //     ),
                //   ),
                //   onSubmit: (date) {
                //     log(date.toString());
                //     controller.scheduleNotification(categoryDetails, date,
                //         TextCleanerService.cleanText(categoryDetails.title));
                //   },
                //   onClose: () {
                //     Navigator.pop(context);
                //   },
                //   minDateTime: DateTime.now().add(Duration(minutes: 1)),
                //   initialDateTime: DateTime.now().add(Duration(minutes: 1)),
                //   buttonSingleColor: Colors.pink,
                // ).show(context);

                BottomPicker(
                  onSubmit: (value) async {
                    log("Days set for the event");

                    TimeOfDay? selectedTime24Hour = await Future.delayed(
                        Duration(milliseconds: 300), () async {
                      return await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    });

                    log("dialogue closed");
                    if (selectedTime24Hour != null) {
                      controller
                          .setSelectedTimeForReminders(selectedTime24Hour, categoryDetails);
                    }
                  },
                  pickerTitle: Text(
                    'Set the Days for the event',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  items: [
                    //const Placeholder());
                    SelectWeekDays(
                      onSelect: (List<String> values) {
                        log("Days List: $values");
                        controller.selectedDaysForReminder = values;
                      },
                      days: controller.days,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      backgroundColor: Colors.white,
                      selectedDayTextColor: Colors.black,
                      selectedDaysFillColor: Colors.white,
                      unselectedDaysFillColor: AppColors.backgroundBlue,
                      selectedDaysBorderColor: AppColors.backgroundBlue,
                      unselectedDaysBorderColor: AppColors.backgroundBlue,
                      unSelectedDayTextColor: Colors.white,
                    )
                  ],
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
                        menuItem: menuItem,
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
}
