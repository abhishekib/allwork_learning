import 'dart:developer';

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
import 'package:allwork/widgets/prayer_time_widget.dart';
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
      MenuListGujratiEntity.schema
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
    return Helpers.convertToMenuListGujrati(realm.all<MenuListGujratiEntity>().first);
  }


}
