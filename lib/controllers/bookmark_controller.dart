import 'dart:developer';

import 'package:allwork/entities/bookmark_data_entity.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/helpers.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:get/get.dart';

class BookmarkController extends GetxController {
  RxList bookmarks = [].obs;

  @override
  void onInit() {
    bookmarks(DbServices.instance.getSavedBookmarks());
    super.onInit();
  }

  void openBookmark(int index) {
    BookmarkDataEntity? bookmarkData =
        DbServices.instance.getBookmarkData(bookmarks[index]);

    Category category = BookmarkDataHelpers.toCategory(bookmarkData!.category!);

    log(category.toString());
    log('tab number ${bookmarkData.lyricsType.toString()}');
    Get.to(
      () => const CategoryDetailView(),
      arguments: {
        'category': category,
        'language': 'English',
        'menuItem': '',
        'bookmarkedTab': bookmarkData.lyricsType
      },
    );
  }
}
