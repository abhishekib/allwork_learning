import 'dart:developer';

import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:allwork/controllers/favourite_controller.dart';
import 'package:allwork/controllers/settings_controller.dart';
import 'package:allwork/entities/bookmark_reminder_deep_link_data_entity.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:allwork/modals/favourite_model.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/lyrics_tab.dart';
import 'package:allwork/views/settings_page_view.dart';
import 'package:allwork/widgets/audio_player_widget.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/marquee_appbar.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:share_plus/share_plus.dart';

class CategoryDetailView extends StatefulWidget {
  const CategoryDetailView({super.key});

  @override
  CategoryDetailViewState createState() => CategoryDetailViewState();
}

class CategoryDetailViewState extends State<CategoryDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isAudioDownloaded = false;
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
    Get.put(SettingsController());
    controller = Get.put(CategoryDetailController());

    final dynamic data = Get.arguments;

    if (data is Map<String, dynamic>) {
      log("Data coming in the format of map");
      categoryDetails = data['category'] as Category;
      selectedLanguage = data['language'] as String;
      menuItem = data['menuItem'] as String;
      // if (menuItem.isEmpty) {
      //   menuItem = categoryDetails.category;
      // }
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
      log("Data coming in the format of favourite model");
      menuItem = data.menuItem ?? '';
      categoryDetails = Category(
        category: "",
        id: int.parse(data.id),
        title: data.title,
        isFav: "Yes",
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
      log("Data coming in unknown format");
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

      _audioController.audioUrl.value = cdata[bookmarkedTab].audiourl;
      currentContentDataId = bookmarkedTab;
    } else {
      _audioController.audioUrl.value = cdata[0].audiourl;
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
      if (newAudioUrl != _audioController.audioUrl.value) {
        _audioController.audioUrl.value = newAudioUrl;
        _audioController.setupAudio(_audioController.audioUrl.value);
      }
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


    MediaQueryData mediaQuery = MediaQuery.of(context);
    String title = TextCleanerService.cleanText(categoryDetails.title);

    if (availableTypes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title:(mediaQuery.size.width < 600 && title.length > 30)
              ? MarqueeTextWidget(
                  marqueeTexts: [title],
                  style: AppTextStyles.customStyle(
                    fontFamily: fontFamily,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              :  FittedBox(
                child: Text(
                            title,
                            style: TextStyle(
                fontFamily: fontFamily,
                            ),
                          ),
              ),
        ),
        body: const Center(child: Text("No data available")),
      );
    }

    log("Re build Screen");
    log("Current audio url is ${_audioController.audioUrl.value?.isNotEmpty}");


    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          title: (mediaQuery.size.width < 600 && title.length > 30)
              ? MarqueeTextWidget(
                  marqueeTexts: [title],
                  style: AppTextStyles.customStyle(
                    fontFamily: fontFamily,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
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
                final shareText =
                    "${categoryDetails.link!}\n\nCopied from: *MAFATI Ul JINAN*  https://mafatihuljinan.org/app";
                Share.share(shareText);
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.copy),
              onPressed: () {
                // Call the copy functionality from LyricsTab
                // controller.copyAllLyricsToClipboard(
                //     context, availableLyrics, categoryDetails.title);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                      title: Text('Select Lyrics Parts to Copy'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Obx(() => CheckboxListTile(
                                  activeColor: AppColors.backgroundBlue,
                                  title: Text(
                                    'Arabic',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  value: controller.copyArabic.value,
                                  onChanged: (bool? value) {
                                    controller.copyArabic(value!);
                                  },
                                )),
                            Obx(() => CheckboxListTile(
                                  activeColor: AppColors.backgroundBlue,
                                  title: Text(
                                    'Transliteration',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  value: controller.copyTransliteration.value,
                                  onChanged: (bool? value) {
                                    controller.copyTransliteration(value!);
                                  },
                                )),
                            Obx(() => CheckboxListTile(
                                  activeColor: AppColors.backgroundBlue,
                                  title: Text(
                                    'Translation',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  value: controller.copyTranslation.value,
                                  onChanged: (bool? value) {
                                    controller.copyTranslation(value!);
                                  },
                                )),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Text('Cancel',
                              style: TextStyle(
                                color: AppColors.backgroundBlue,
                                fontSize: 18,
                              )),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                AppColors.backgroundBlue),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            'Copy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.copySelectedLyricsToClipboard(context,
                                availableLyrics, categoryDetails.title);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            FloatingActionButton.small(
                heroTag: null,
                onPressed: () {
                  controller.handleAddToFavourite(context, categoryDetails,
                      menuItem, categoryDetails.isFav == "Yes" ? true : false);
                  setState(() {
                    categoryDetails.isFav =
                        categoryDetails.isFav == "Yes" ? "No" : "Yes";
                  });
                },
                child: Icon(Icons.favorite,
                    color: categoryDetails.isFav == "Yes"
                        ? Colors.red
                        : Colors.purple)),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.access_alarm),
              onPressed: () async {
                showModalBottomSheet(
                    backgroundColor: Colors.white,
                    constraints: BoxConstraints.tight(Size.fromHeight(
                        MediaQuery.of(context).size.height * 0.40)),
                    context: context,
                    builder: (context) => Column(
                          children: [
                            if (Theme.of(context).platform ==
                                TargetPlatform.iOS)
                              CupertinoTimerPicker(
                                backgroundColor: CupertinoColors.white,
                                mode: CupertinoTimerPickerMode.hm,
                                onTimerDurationChanged: (value) {
                                  log("Time selected: $value");
                                  controller.duration.value = value;
                                },
                              )
                            else
                              // Default Material time picker for Android and other platforms
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Obx(
                                    () {
                                      return TextButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              controller.formatTime(
                                                  controller.duration.value),
                                              style: TextStyle(fontSize: 60),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.timer,
                                              size: 50,
                                              color: AppColors.backgroundBlue,
                                            )
                                          ],
                                        ),
                                        onPressed: () async {
                                          final TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: controller
                                                    .duration.value.inHours,
                                                minute: controller.duration
                                                        .value.inMinutes %
                                                    60),
                                            builder: (context, child) {
                                              return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        alwaysUse24HourFormat:
                                                            true),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (pickedTime != null) {
                                            log("Time selected: ${pickedTime.format(context)}");
                                            controller.duration.value =
                                                Duration(
                                                    hours: pickedTime.hour,
                                                    minutes: pickedTime.minute);
                                          }
                                        },
                                      );
                                    },
                                  )),
                            //SizedBox(height: 20),
                            // Select Week Days with improved UI
                            SelectWeekDays(
                              onSelect: (List<String> values) {
                                log("Days List: $values");
                                controller.selectedDaysForReminder = values;
                              },
                              width: 320,
                              days: ApiConstants.days,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              backgroundColor: Colors.white,
                              selectedDayTextColor: Colors.white,
                              selectedDaysFillColor: AppColors.backgroundBlue,
                              unselectedDaysFillColor: Colors.white,
                              selectedDaysBorderColor: AppColors.backgroundBlue,
                              unselectedDaysBorderColor:
                                  AppColors.backgroundBlue,
                              unSelectedDayTextColor: AppColors.backgroundBlue,
                            ),

                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    AppColors.backgroundBlue),
                              ),
                              onPressed: () {
                                Get.back();
                                Get.snackbar(
                                    "Reminder", "Reminder set up successfully");
                                controller.scheduleNotification(
                                    categoryDetails, controller.duration.value);
                              },
                              child: const Text(
                                "Set Reminder",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ));
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.settings),
              onPressed: () {
                Get.to(() => SettingsPage());
              },
            ),
          ],
        ),
        body: DefaultTabController(
          length: availableTypes.length,
          child: Column(
            children: [
              Obx(() => _audioController.audioUrl.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AudioPlayerWidget(
                        categoryName: categoryDetails.title,
                        categoryType:
                            categoryDetails.cdata![_tabController.index].type,
                        controller: _audioController,
                        audioUrl: _audioController.audioUrl.value,
                        onPositionChanged: (currentPosition) {
                          _audioController.currentTime.value;
                        },
                      ),
                    )
                  : SizedBox.shrink()),
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
              Visibility(
                visible: categoryDetails.nextPostTitle?.isNotEmpty ?? false,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context, // Ensure you pass the context
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('Clicked'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28.0, left: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          categoryDetails.nextPostTitle ?? '',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
