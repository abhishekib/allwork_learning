import 'dart:developer';

import 'package:allwork/modals/category.dart';
import 'package:allwork/providers/deep_linking_provider.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/menu_helpers/helpers.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:get/get.dart';

class DeepLinkingController extends GetxController {
  final DeepLinkingProvider _deepLinkingProvider =
      DeepLinkingProvider(ApiConstants.token);

  Future<void> handleDeepLink(String deepLink) async {
    if (await Helpers.hasActiveInternetConnection()) {
      getDeepLinkingResponse(deepLink);
    } else {
      log('No internet connection');
      getDeepLinkingEntity(deepLink);
    }
  }

  Future<void> getDeepLinkingResponse(String deeplink) async {
    final response = await _deepLinkingProvider.getDeepLinkingResponse(deeplink);

    Category category = Category.fromJson(response.data['data']);
    log(category.toString());

    Get.to(() => CategoryDetailView(), arguments: {
      'fromBookmark': false,
      'category': category,
      'language': 'English',
      'menuItem': '',
      //'bookmarkedTab': bookmarkData.lyricsType,
      //'lyricsIndex': bookmarkData.lyricsIndex,
    });
  }

  Future<void> getDeepLinkingEntity(String deeplink) async {
    Category? category = await DbServices.instance.getDeepLink(deeplink);

    if (category == null) {
      Get.snackbar("No data found", "No data found");
      return;
    }

    log(category.toString());

    Get.to(() => CategoryDetailView(), arguments: {
      'fromBookmark': false,
      'category': category,
      'language': 'English',
      'menuItem': '',
      //'bookmarkedTab': bookmarkData.lyricsType,
      //'lyricsIndex': bookmarkData.lyricsIndex,
    });
  }
}
