import 'dart:io';

import 'package:allwork/entities/animated_text_entities.dart';
import 'package:allwork/modals/animated_text.dart';

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


//method to convert api response coming from server as MessageModel to MessageModelEntity for DB
  static MessageModelEntity convertToMessageModelEntity(
      MessageModel messageModel) {
//convert the List<AnimatedText>  inside MessageModel to List<AnimatedTextEntity>
    List<AnimatedTextEntity> animatedTextEntries = messageModel.animatedText
        .map((animatedText) => AnimatedTextEntity(animatedText.heading))
        .toList();

    return MessageModelEntity(animatedText: animatedTextEntries);
  }


//method to convert MessageModelEntity from DB to MessageModel for Controllers
  static MessageModel convertToMessageModel(
      MessageModelEntity messageModelEntity) {
    //convert the List<AnimatedTextEntity>  inside MessageModelEntity to List<AnimatedText>
    List<AnimatedText> animatedTexts = messageModelEntity.animatedText
        .map((animatedTextEntity) =>
            AnimatedText(heading: animatedTextEntity.heading))
        .toList();

    return MessageModel(animatedText: animatedTexts);
  }
}
