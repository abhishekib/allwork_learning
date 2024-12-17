import 'dart:developer';

import 'package:allwork/modals/animated_text.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:allwork/utils/constants.dart';
import '../providers/animated_text_provider.dart';

class AnimatedTextController extends GetxController {
  final isLoading = false.obs;
  final animatedTextList =
      <String>[].obs; // Change to List<String> for cleaned text

  final AnimatedTextProvider _animatedTextProvider =
      AnimatedTextProvider(ApiConstants.dailyDuaToken);

  @override
  onInit() async {
    super.onInit();
    bool hasInternet = await Helpers.hasActiveInternetConnection();
    if (hasInternet) {
      fetchTextDataFromApi();
      log('Internet connection is active');
    } else {
      fetchTextDataFromDB();
      log('No internet connection');
    }
  }

  Future<void> fetchTextDataFromApi() async {
    try {
      isLoading(true);
      List<AnimatedText> fetchedList =
          await _animatedTextProvider.fetchTextData();

      // Clean up HTML tags from the fetched data
      List<String> cleanedTextList = fetchedList
          .map((animatedText) => removeHtmlTags(animatedText.heading))
          .toList();

      animatedTextList.value = cleanedTextList;
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTextDataFromDB() async {
    try {
      isLoading(true);
      List<AnimatedText> fetchedList =
          DbServices.instance.getAnimatedMessageText();

      List<String> cleanedTextList = fetchedList
          .map((animatedText) => removeHtmlTags(animatedText.heading))
          .toList();

      animatedTextList.value = cleanedTextList;
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }

  // Function to remove HTML tags
  String removeHtmlTags(String htmlText) {
    final RegExp exp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '');
  }
}
