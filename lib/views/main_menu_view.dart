import 'package:allwork/utils/colors.dart';
import 'package:allwork/views/menu_list_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/marquee_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/animated_text_controller.dart';

class MainMenuView extends StatelessWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final animatedTextController = Get.put(AnimatedTextController());

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        body: Column(
          children: [
            // Custom "AppBar" with Marquee
            Obx(() {
              if (animatedTextController.isLoading.value) {
                return Container(
                  color: AppColors.backgroundBlue,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              } else {
                final marqueeTexts = animatedTextController.animatedTextList
                    .map((text) => text)
                    .toList();
                return MarqueeTextWidget(
                  marqueeTexts: marqueeTexts,
                );
              }
            }),
            // Rest of the body with MenuListView
            Expanded(
              child: MenuListView(),
            ),
          ],
        ),
      ),
    );
  }
}
