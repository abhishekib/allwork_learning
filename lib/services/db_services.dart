import 'dart:developer';

import 'package:allwork/entities/animated_text_entities.dart';
import 'package:allwork/modals/animated_text.dart';
import 'package:allwork/utils/helpers.dart';
import 'package:realm/realm.dart';

class DbServices {
  static final DbServices _instance = DbServices._internal();

  static DbServices get instance => _instance;

  late Realm realm;

  DbServices._internal() {
    final config = Configuration.local(
        [AnimatedTextEntity.schema, MessageModelEntity.schema]);
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
    log("written in db");
  }

  List<AnimatedText> getAnimatedMessageText() {
    return Helpers.convertToMessageModel(realm.all<MessageModelEntity>().first).animatedText;
  }
}
