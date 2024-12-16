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

  Future<void> writeAnimatedMessageText(MessageModel messageModel) async {
    realm.write(() {
      return realm.add(Helpers.convertToMessageModelEntity(messageModel));
    });
    log("written in db");
  }
}
