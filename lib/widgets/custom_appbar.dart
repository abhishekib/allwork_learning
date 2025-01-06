import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Stack(
          children: [
            // Back arrow aligned to the left
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 38,
                ),
                onTap: () {
                  Get.back();
                },
              ),
            ),
            // Title aligned to the center
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: AppTextStyles.whiteBoldTitleText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
