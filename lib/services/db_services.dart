import 'dart:developer';

import 'package:allwork/entities/about_us_entity.dart';
import 'package:allwork/entities/audio_download_mapping_entity.dart';
import 'package:allwork/entities/bookmark_reminder_data_entity.dart';
import 'package:allwork/entities/bookmark_entity.dart';
import 'package:allwork/entities/menu_detail_entity.dart';
import 'package:allwork/entities/menu_entities/animated_text_entities.dart';
import 'package:allwork/entities/menu_entities/daily_date_entity.dart';
import 'package:allwork/entities/menu_entities/menu_list_entity.dart';
import 'package:allwork/entities/menu_entities/menu_list_gujrati_entity.dart';
import 'package:allwork/entities/menu_entities/prayer_time_entity.dart';
import 'package:allwork/entities/reminder_entity.dart';
import 'package:allwork/modals/about_us_response.dart';
import 'package:allwork/modals/animated_text.dart';
import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/daily_date.dart';
import 'package:allwork/modals/menu_list.dart';
import 'package:allwork/modals/prayer_time_model.dart';
import 'package:allwork/modals/reminder_model.dart';
import 'package:allwork/utils/helpers.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbServices {
  static final DbServices _instance = DbServices._internal();

  static DbServices get instance => _instance;

  late Realm realm;

  DbServices._internal() {
    final config = Configuration.local([
      AnimatedTextEntity.schema,
      MessageModelEntity.schema,
      DailyDateEntity.schema,
      PrayerTimeEntity.schema,
      MenuListEntity.schema,
      MenuListGujratiEntity.schema,
      MenuDetailEntity.schema,
      ApiResponseEntity.schema,
      KeyValueEntity.schema,
      BookmarkEntity.schema,
      BookmarkDataEntity.schema,
      CategoryEntity.schema,
      ContentDataEntity.schema,
      LyricsEntity.schema,
      ReminderEntity.schema,
      ReminderDataEntity.schema,
      AudioDownloadMapping.schema,
      AboutUsEntity.schema
    ]);
    realm = Realm(config);
  }

  Future<void> writeAboutUs(AboutUsResponse aboutUsResponse) async {
    realm.write(() {
      // Delete all existing `AboutUsEntity` objects
      realm.deleteAll<AboutUsEntity>();
      // Add the new object
      return realm.add(AboutUsEntity(aboutUsResponse.data));
    });
    log("written about us in db");
  }

  AboutUsResponse getAboutUs() {
    return AboutUsResponse(data: realm.all<AboutUsEntity>().first.data);
  }

//save the message model in db
  Future<void> writeMessageModel(MessageModel messageModel) async {
    realm.write(() {
      // Delete all existing `MessageModelEntity` objects
      realm.deleteAll<MessageModelEntity>();
      // Add the new object
      return realm.add(Helpers.convertToMessageModelEntity(messageModel));
    });
    log("written marquee text in db");
  }

//get the message model from db
  List<AnimatedText> getAnimatedMessageText() {
    return Helpers.convertToMessageModel(realm.all<MessageModelEntity>().first)
        .animatedText;
  }

//save the DailyDate model in db
  Future<void> writeDailyDate(DailyDate dailyDate) async {
    realm.write(() {
      // Delete all existing `DailyDateEntity` objects
      realm.deleteAll<DailyDateEntity>();
      // Add the new object
      return realm.add(Helpers.convertToDailyDateEntity(dailyDate));
    });
    log("written daily date in db");
  }

  //get the daily date from db
  DailyDate getDailyDate() {
    return Helpers.convertToDailyDate(realm.all<DailyDateEntity>().first);
  }

//save the PrayerTime model in db
  Future<void> writePrayerTimeModel(PrayerTimeModel prayerTimeModel) async {
    realm.write(() {
      // Delete all existing `PrayerTimeEntity` objects
      realm.deleteAll<PrayerTimeEntity>();
      // Add the new object
      return realm.add(Helpers.convertToPrayerTimeEntity(prayerTimeModel));
    });
    log("written prayer time model in db");
  }

//get the PrayerTime model from db
  PrayerTimeModel getPrayerTimeModel() {
    return Helpers.convertToPrayerTimeModel(
        realm.all<PrayerTimeEntity>().first);
  }

//save the MenuList model in db
  Future<void> writeMenuList(MenuList menuList) async {
    realm.write(() {
      // Delete all existing `PrayerTimeEntity` objects
      realm.deleteAll<MenuListEntity>();
      // Add the new object
      return realm.add(Helpers.convertToMenuListEntity(menuList));
    });
    log("written menu list db");
  }

//get the MenuList model from db
  MenuList getMenuList() {
    return Helpers.convertToMenuList(realm.all<MenuListEntity>().first);
  }

//save the Gujrati MenuList model in db
  Future<void> writeGujratiMenuList(MenuList menuList) async {
    realm.write(() {
      // Delete all existing `PrayerTimeEntity` objects
      realm.deleteAll<MenuListGujratiEntity>();
      // Add the new object
      return realm.add(Helpers.convertToMenuListGujratiEntity(menuList));
    });
    log("written menu list db");
  }

//get the Gujrati MenuList model from db
  MenuList getGujratiMenuList() {
    return Helpers.convertToMenuListGujrati(
        realm.all<MenuListGujratiEntity>().first);
  }

  Future<void> writeApiResponseHandler(
      String endpoint, ApiResponseHandler apiResponseHandler) async {
    MenuDetailEntity newMenuDetailEntity =
        MenuDetailsHelpers.toMenuDetailEntity(endpoint, apiResponseHandler);

    // newMenuDetailEntity.apiResponseEntity!.data.asMap().forEach((index, value) {
    //   log("$index : $value");
    // });

    realm.write(() {
      var existingMenuDetailEntity = realm.find<MenuDetailEntity>(endpoint);

      if (existingMenuDetailEntity == null) {
        //log("addinge the endpoint as it does not exist : $endpoint");
        realm.add(newMenuDetailEntity);
      } else {
        //log("deleting the old menu detail entity");
        realm.delete<MenuDetailEntity>(existingMenuDetailEntity);
        //log("Adding the new menu detail entity");
        realm.add(newMenuDetailEntity);
      }
    });
  }

  bool endpointExists(String endpoint) {
    MenuDetailEntity? menuDetailEntity = realm.find<MenuDetailEntity>(endpoint);
    if (menuDetailEntity != null) {
      return true;
    }
    return false;
  }

  ApiResponseHandler? getApiResponseHandler(String endpoint) {
    MenuDetailEntity? menuDetailEntity = realm.find<MenuDetailEntity>(endpoint);
    final apiResponseEntity = menuDetailEntity?.apiResponseEntity;
    if (apiResponseEntity != null) {
      return MenuDetailsHelpers.convertToApiResponseHandler(apiResponseEntity);
    }
    return null;
  }

  Future<void> writeBookmark(
      Category category, int lyricsType, int index) async {
    //if object is already present delete it and then update it
    if (getBookmarkData(category.title) != null) {
      log("Bookmark with this title already exists");
      deleteBookmark(category.title);
      log("Deleted bookmark first ");
    }

    realm.write(() {
      // Add the new object
      realm.add(BookmarkEntity(category.title));
      realm.add(BookmarkDataHelpers.toBookmarkDataEntity(
          category, lyricsType, index));
    });
    log("written bookmark in db");
  }

  List<String> getSavedBookmarks() {
    return realm.all<BookmarkEntity>().map((e) => e.title).toList();
  }

  BookmarkDataEntity? getBookmarkData(String title) {
    log(title);
    BookmarkDataEntity? bookmarkDataEntity =
        realm.find<BookmarkDataEntity>(title);

    return bookmarkDataEntity;
  }

  Future<void> deleteBookmark(String title) async {
    log("title: $title");
    realm.write(() {
      realm.delete<BookmarkEntity>(
          realm.all<BookmarkEntity>().query("title == '$title'").first);
      realm.delete<BookmarkDataEntity>(getBookmarkData(title)!);
    });
  }

  bool isBookmarked(String title) {
    return realm.find<BookmarkDataEntity>(title) != null;
  }

  Future<void> writeReminder(Category category, String scheduledTimeZone,
      DateTime scheduledDateTime) async {
    ReminderDataEntity? reminderDataEntity =
        realm.find<ReminderDataEntity>(category.title);

    realm.write(() {
      if (reminderDataEntity != null) {
        realm.delete<ReminderDataEntity>(reminderDataEntity);
      }
      // Add the new object
      log(getNextReminderId().toString());
      realm.add(ReminderEntity((getNextReminderId()), category.title,
          DateTime.now(), scheduledTimeZone, scheduledDateTime));
      realm.add(ReminderDataHelpers.toReminderDataEntity(category));
    });
    log("written reminder in db");
  }

  ReminderDataEntity? getReminderData(String title) {
    log(title);
    ReminderDataEntity? reminderDataEntity =
        realm.find<ReminderDataEntity>(title);
    return reminderDataEntity;
  }

  List<ReminderModel> getReminders() {
    return realm
        .all<ReminderEntity>()
        .map((e) =>
            ReminderModel(e.id, e.title, e.scheduledTimeZone, e.scheduledAt))
        .toList();
  }

  int getNextReminderId() {
    final lastReminder = realm.all<ReminderEntity>().isEmpty
        ? 0
        : realm.all<ReminderEntity>().last.id;
    return lastReminder + 1;
  }

  Future<void> deleteReminder(int id) async {
    realm.write(() {
      ReminderEntity? reminderEntity = realm.find<ReminderEntity>(id);

      if (reminderEntity != null) {
        if (getReminderTitleCount(reminderEntity.title) == 1) {
          realm.delete<ReminderDataEntity>(
              getReminderData(reminderEntity.title)!);
        }
        realm.delete<ReminderEntity>(reminderEntity);
      }
    });
  }

  int getReminderTitleCount(String title) {
    return realm.all<ReminderEntity>().query("title == '$title'").length;
  }

  Future<void> writeAudioDownloadPath(
      String audioUrl, String audioDownloadPath) async {
    realm.write(() {
      realm.add(AudioDownloadMapping(audioUrl, audioDownloadPath));
    });
  }

  String? getAudioDownloadPath(String audioUrl) {
    try {
      return realm
          .all<AudioDownloadMapping>()
          .query("audioUrl == '$audioUrl'")
          .first
          .audioDownloadPath;
    } catch (e) {
      return null;
    }
  }
}
