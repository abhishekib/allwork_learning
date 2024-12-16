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

  static MessageModelEntity convertToMessageModelEntity(
      MessageModel messageModel) {
    return MessageModelEntity(
        animatedText: messageModel.animatedText
            .map((animatedText) => AnimatedTextEntity(animatedText.heading)));
  }
}
