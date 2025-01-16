import 'package:allwork/controllers/bookmark_controller.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BookmarkView extends StatelessWidget {
  BookmarkView({super.key});

  var controller = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "BookMark Screen",
            style: AppTextStyles.whiteBoldTitleText,
          ),
        ),
        body: Center(
          child: controller.bookmarks.isEmpty
              ? Text("No bookmarks saved", style: AppTextStyles.whiteBoldText)
              : ListView.builder(
                  itemCount: controller.bookmarks.length,
                  itemBuilder: (context, index) {
                    return ListTile(onTap: () {
                      controller.openBookmark(index);
                    },
                      title: Text(controller.bookmarks[index],
                          style: AppTextStyles.whiteBoldText),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
