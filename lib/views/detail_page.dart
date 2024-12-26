import 'package:allwork/controllers/text_cleaner_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String category;
  final String subcategory;
  final String data;

  const DetailPage({
    super.key,
    required this.category,
    required this.subcategory,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    TextCleanerController textCleanerController = TextCleanerController();
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            subcategory,
            style: AppTextStyles.whiteBoldTitleText,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Category: $category",
                //   style: const TextStyle(
                //       fontSize: 16, fontWeight: FontWeight.bold),
                // ),
                const SizedBox(height: 8),
                // Text(
                //   "Subcategory: $subcategory",
                //   style: const TextStyle(fontSize: 16),
                // ),
                const SizedBox(height: 16),
                Text(
                  textCleanerController.cleanText(data),
                  style: AppTextStyles.whiteBoldText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
