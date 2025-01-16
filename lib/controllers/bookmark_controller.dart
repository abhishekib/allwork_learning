import 'dart:developer';

import 'package:allwork/modals/category.dart';
import 'package:allwork/services/db_services.dart';
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
    Category category = DbServices.instance.getBookmarkData(bookmarks[index]);
    log(category.toString());
    Get.to(
      () => const CategoryDetailView(),
      arguments: {
        'category': category,
        'language': 'English',
        'menuItem': '',
      },
    );
  }
}
