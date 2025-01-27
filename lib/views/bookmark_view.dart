import 'package:allwork/controllers/bookmark_controller.dart';
import 'package:allwork/controllers/category_list_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/utils/colors.dart';
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
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    itemCount: controller.bookmarks.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9.5),
                            ),
                            child: ListTile(
                              onTap: () {
                                controller.openBookmark(index);
                              },
                              title: Text(controller.bookmarks[index],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.customStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.backgroundBlue,
                                  )),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.bookmark_border,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      onTap: () {
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10)
                        ],
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
