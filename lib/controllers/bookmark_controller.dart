import 'dart:developer';

import 'package:allwork/services/db_services.dart';
import 'package:get/get.dart';

class BookmarkController extends GetxController {
  RxList bookmarks = [].obs;

  @override
  void onInit() {
    bookmarks(DbServices.instance.getSavedBookmarks());
    log(bookmarks.toString());
    super.onInit();
  }
}
