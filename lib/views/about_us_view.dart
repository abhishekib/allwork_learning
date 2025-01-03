import 'package:flutter/material.dart';
import 'package:linkable/linkable.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/about_us_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';

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
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () {
              if (_controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              } else {
                return SingleChildScrollView(
                  child: Linkable(
                    text: _controller.aboutUsText.value,
                    textColor: Colors.white,
                    style: AppTextStyles.whiteBoldText,
                    linkColor: Colors.blue,
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
