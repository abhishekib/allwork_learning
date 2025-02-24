import 'dart:developer';

import 'package:allwork/entities/bookmark_reminder_deep_link_data_entity.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/services/db_services.dart';
import 'package:allwork/utils/helpers.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:get/get.dart';

class BookmarkController extends GetxController {
  RxList bookmarks = [].obs;

  @override
  void onInit() {
    log("on init bookmark controller called");
    bookmarks(DbServices.instance.getSavedBookmarks());
    super.onInit();
  }

  void openBookmark(int index) {
    BookmarkDataEntity? bookmarkData =
        DbServices.instance.getBookmarkData(bookmarks[index]);

    Category category = CategoryHelpers.toCategory(bookmarkData!.category!);
    
    Get.to(
      () => const CategoryDetailView(),
      arguments: {
        'fromBookmark': true,
        'category': category,
        'language': 'English',
        'menuItem': category.category,
        'bookmarkedTab': bookmarkData.lyricsType,
        'lyricsIndex': bookmarkData.lyricsIndex,
      },
    );
  }

  void removeBookmark(int index) {
    //DbServices.instance.deleteBookmark(bookmarks[index]);
    bookmarks.removeAt(index);
    Get.snackbar("Deleted", "Deleted the bookmark");
  }

  int getBookmarkedLyric(String title) {
    if (bookmarks.contains(title)) {
      return bookmarks.indexOf(title);
    } else {
      return -1;
    }
  }

  int getBookmarkedTab(String title) {
    if (bookmarks.contains(title)) {
      BookmarkDataEntity? bookmarkData = DbServices.instance
          .getBookmarkData(bookmarks[bookmarks.indexOf(title)]);

      return bookmarkData!.lyricsType;
    } else {
      return -1;
    }
  }
}
