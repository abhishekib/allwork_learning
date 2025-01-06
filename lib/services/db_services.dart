import 'dart:developer';

import 'package:allwork/entities/menu_detail_entity.dart';
import 'package:allwork/entities/menu_entities/animated_text_entities.dart';
import 'package:allwork/entities/menu_entities/daily_date_entity.dart';
import 'package:allwork/entities/menu_entities/menu_list_entity.dart';
import 'package:allwork/entities/menu_entities/menu_list_gujrati_entity.dart';
import 'package:allwork/entities/menu_entities/prayer_time_entity.dart';
import 'package:allwork/modals/animated_text.dart';
import 'package:allwork/modals/daily_date.dart';
import 'package:allwork/modals/menu_list.dart';
import 'package:allwork/modals/prayer_time_model.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:realm/realm.dart';

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
      MenuDetailEntityNested.schema,
      CategoryGroupEntity.schema,
      CategoryEntity.schema,
      ContentDataEntity.schema,
      LyricsEntity.schema
    ]);
    realm = Realm(config);
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

//write the CategoryResponse model in db
  /*
  Future<void> writeCategoryResponse(
      String endpoint, CategoryResponse categoryResponse) async {
    // Convert CategoryResponse to MenuDetailEntity before the transaction
    MenuDetailEntity newMenuDetailEntity =
        MenuDetailsHelpers.toMenuDetailEntity(endpoint, categoryResponse);

    realm.write(() {
      // Find the existing MenuDetailEntity
      var existingMenuDetail = realm.find<MenuDetailEntity>(endpoint);

      if (existingMenuDetail == null) {
        // Add the new document if it does not exist
        log("addinge the endpoint as it does not exist : $endpoint");
        realm.add(newMenuDetailEntity);
      } else {
        // Collect all objects for deletion safely
        log("updating the endpoint as it exists : $endpoint");
        final categoryGroupsToDelete =
            existingMenuDetail.categoryGroups.toList();
        final categoryEntitiesToDelete = categoryGroupsToDelete
            .expand((group) => group.categoryEntities)
            .toList();
        final contentDataToDelete = categoryEntitiesToDelete
            .expand((category) => category.cdataEntities)
            .toList();
        final lyricsToDelete = contentDataToDelete
            .expand((contentData) => contentData.lyricsEntities)
            .toList();

        // Delete in bulk without iterating over the managed lists
        realm.deleteMany(lyricsToDelete);
        realm.deleteMany(contentDataToDelete);
        realm.deleteMany(categoryEntitiesToDelete);
        realm.deleteMany(categoryGroupsToDelete);

        // Clear the existing categoryGroups list
        existingMenuDetail.categoryGroups.clear();

        // Add new data
        existingMenuDetail.categoryGroups
            .addAll(newMenuDetailEntity.categoryGroups);
      }
    });

    log("Written $endpoint model in DB");
  }
*/
//get the CategoryResponse model from db
/*
  CategoryResponse? getCategoryResponse(String endpoint) {
    var existingMenuDetail = realm.find<MenuDetailEntity>(endpoint);

    if (existingMenuDetail != null) {
      return MenuDetailsHelpers.toCategoryResponse(existingMenuDetail);
    }
    return null;
  }
*/
  // Future<void> writeCategoryResponse2(
  //     String endpoint, CategoryResponse2 categoryResponse2) async {
  //   MenuDetailEntityNested newMenuDetailEntityNested =
  //       MenuDetailsHelpers.toMenuDetailEntityNested(
  //           endpoint, categoryResponse2);

  //   realm.write(() {
  //     // Find the existing MenuDetailEntityNested
  //     var existingMenuDetailNested =
  //         realm.find<MenuDetailEntityNested>(endpoint);
  //     if (existingMenuDetailNested == null) {
  //       // Add the new document if it does not exist
  //       log("addinge the endpoint as it does not exist : $endpoint");
  //       realm.add(newMenuDetailEntityNested);
  //     } else {
  //       log("Ziyarat already exists");
  //     }
  //   });
  // }

  // CategoryResponse2 getCategoryResponse2() {
  //   return MenuDetailsHelpers.toCategoryResponse2(
  //       realm.all<MenuDetailEntityNested>().first);
  // }
  
  void saveOfflineCategoryDataAudio(String savePath, int contentDataId) {
    final contentData = realm.find<ContentDataEntity>(contentDataId);

    if (contentData != null) {
      realm.write(() {
        contentData.offlineAudioUrl ??= savePath;
      });
    } else {
      log("Cannot write the audio path because no such content exists");
    }
  }
}
