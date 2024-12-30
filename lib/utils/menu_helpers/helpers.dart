import 'dart:io';

import 'package:allwork/entities/menu_entities/animated_text_entities.dart';
import 'package:allwork/entities/menu_entities/daily_date_entity.dart';
import 'package:allwork/entities/menu_entities/menu_list_entity.dart';
import 'package:allwork/entities/menu_entities/menu_list_gujrati_entity.dart';
import 'package:allwork/entities/menu_entities/prayer_time_entity.dart';
import 'package:allwork/modals/animated_text.dart';
import 'package:allwork/modals/daily_date.dart';
import 'package:allwork/modals/menu_list.dart';
import 'package:allwork/modals/prayer_time_model.dart';

//class for helper methods
class Helpers {
  static Future<bool> hasActiveInternetConnection() async {
    try {
      // Try to lookup a common website
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet connection is active
      }
    } on SocketException catch (_) {
      return false; // No internet connection
    }
    return false;
  }

//method to convert api response as MessageModel to MessageModelEntity for DB
  static MessageModelEntity convertToMessageModelEntity(
      MessageModel messageModel) {
//convert the List<AnimatedText>  inside MessageModel to List<AnimatedTextEntity>
    List<AnimatedTextEntity> animatedTextEntries = messageModel.animatedText
        .map((animatedText) => AnimatedTextEntity(animatedText.heading))
        .toList();

    return MessageModelEntity(animatedText: animatedTextEntries);
  }

//method to convert MessageModelEntity from DB to MessageModel for controllers
  static MessageModel convertToMessageModel(
      MessageModelEntity messageModelEntity) {
    //convert the List<AnimatedTextEntity>  inside MessageModelEntity to List<AnimatedText>
    List<AnimatedText> animatedTexts = messageModelEntity.animatedText
        .map((animatedTextEntity) =>
            AnimatedText(heading: animatedTextEntity.heading))
        .toList();

    return MessageModel(animatedText: animatedTexts);
  }

  //method to convert api response as DailyDate to DailyDateEntity for DB
  static DailyDateEntity convertToDailyDateEntity(DailyDate dailyDate) {
    return DailyDateEntity(dailyDate.hijriDate!, dailyDate.event ?? '',
        dailyDate.eventColor ?? '');
  }

  //method to convert DailyDateEntity from DB to DailyDate for controllers
  static DailyDate convertToDailyDate(DailyDateEntity dailyDateEntity) {
    return DailyDate(
        hijriDate: dailyDateEntity.hijriDate,
        event: dailyDateEntity.event,
        eventColor: dailyDateEntity.eventColor);
  }

//method to convert api response PrayerTimeModel to PrayerTimeEntity to save in DB
  static PrayerTimeEntity convertToPrayerTimeEntity(
      PrayerTimeModel prayerTimeModel) {
    return PrayerTimeEntity(prayerTimeModel.fajr, prayerTimeModel.sunrise,
        prayerTimeModel.dhuhr, prayerTimeModel.sunset, prayerTimeModel.maghrib);
  }

//method to convert PrayerTimeEntity to PrayerTimeModel for controllers
  static PrayerTimeModel convertToPrayerTimeModel(
      PrayerTimeEntity prayerTimeEntity) {
    return PrayerTimeModel(
        fajr: prayerTimeEntity.fajr,
        sunrise: prayerTimeEntity.sunrise,
        dhuhr: prayerTimeEntity.dhuhr,
        sunset: prayerTimeEntity.sunset,
        maghrib: prayerTimeEntity.maghrib);
  }

  // method to convert api response MenuListModel to MenuListEntity to save in DB
  static MenuListEntity convertToMenuListEntity(
      MenuList menuList) {
    return MenuListEntity(items: menuList.items);
  }

  static MenuListGujratiEntity convertToMenuListGujratiEntity(
      MenuList menuList) {
    return MenuListGujratiEntity(items: menuList.items);
  }

  // method to convert MenuListEntity to MenuList for controllers
  static MenuList convertToMenuList(
      MenuListEntity menuListEntity) {
    return MenuList(items: menuListEntity.items);
  }

  static MenuList convertToMenuListGujrati(
      MenuListGujratiEntity menuListGujratiEntity) {
    return MenuList(items: menuListGujratiEntity.items);
  }



}
