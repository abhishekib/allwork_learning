import 'dart:developer';

import 'package:allwork/entities/animated_text_entities.dart';
import 'package:allwork/entities/daily_date_entity.dart';
import 'package:allwork/entities/prayer_time_entity.dart';
import 'package:allwork/modals/animated_text.dart';
import 'package:allwork/modals/daily_date.dart';
import 'package:allwork/modals/prayer_time_model.dart';
import 'package:allwork/utils/helpers.dart';
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
      DailyDateEntity.schema, PrayerTimeEntity.schema
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

//get the message model in db
  List<AnimatedText> getAnimatedMessageText() {
    return Helpers.convertToMessageModel(realm.all<MessageModelEntity>().first)
        .animatedText;
  }

//save the DailyDate model in db
  Future<void> writeDailyDate(DailyDate dailyDate) async {
    realm.write(() {
      // Delete all existing `MessageModelEntity` objects
      realm.deleteAll<DailyDateEntity>();
      // Add the new object
      return realm.add(Helpers.convertToDailyDateEntity(dailyDate));
    });
    log("written daily date in db");
  }

  //get the daily date in db
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
    log("written daily date in db");
  }

  PrayerTimeModel getPrayerTimeModel() {
    return Helpers.convertToPrayerTimeModel(
        realm.all<PrayerTimeEntity>().first);
  }
}
