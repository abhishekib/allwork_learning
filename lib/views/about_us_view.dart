import 'package:allwork/controllers/about_us_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsView extends StatelessWidget {
  AboutUsView({super.key});
  final AboutUsController _controller = Get.put(AboutUsController());
  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          title: Text(
            'About Us',
            style: AppTextStyles.whiteBoldTitleText,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () {
              if (_controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  child: Text(
                    _controller.aboutUsText.value, // Display the cleaned text
                    style: AppTextStyles.whiteBoldText,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
