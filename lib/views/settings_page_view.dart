import 'package:allwork/controllers/settings_controller.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();

    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: AppTextStyles.whiteBoldTitleText,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Adjust Arabic Font Size",
                  style: AppTextStyles.whiteBoldText,
                ),
                Obx(() {
                  return Slider(
                    min: 18.0,
                    max: 30.0,
                    divisions: 16,
                    value: settingsController.arabicFontSize.value,
                    onChanged: (value) {
                      settingsController.updateArabicFontSize(value);
                    },
                  );
                }),
                Obx(() {
                  return Text(
                    "حجم الخط العربي: ${settingsController.arabicFontSize.value.toStringAsFixed(1)}",
                    style: TextStyle(
                      fontSize: settingsController.arabicFontSize.value,
                      color: Colors.white,
                      fontFamily: "MUHAMMADI",
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  "Adjust Transliteration Font Size",
                  style: AppTextStyles.whiteBoldText,
                ),
                Obx(() {
                  return Slider(
                    min: 16.0,
                    max: 30.0,
                    divisions: 16,
                    value: settingsController.transliterationFontSize.value,
                    onChanged: (value) {
                      settingsController.updateTransliterationFontSize(value);
                    },
                  );
                }),
                Obx(() {
                  return Text(
                    "Transliteration Font Size: ${settingsController.transliterationFontSize.value.toStringAsFixed(1)}",
                    style: TextStyle(
                      fontSize:
                          settingsController.transliterationFontSize.value,
                      color: Colors.white,
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  "Adjust Translation Font Size",
                  style: AppTextStyles.whiteBoldText,
                ),
                Obx(() {
                  return Slider(
                    min: 16.0,
                    max: 30.0,
                    divisions: 16,
                    value: settingsController.translationFontSize.value,
                    onChanged: (value) {
                      settingsController.updateTranslationFontSize(value);
                    },
                  );
                }),
                Obx(() {
                  return Text(
                    "Translation Font Size: ${settingsController.translationFontSize.value.toStringAsFixed(1)}",
                    style: TextStyle(
                      fontSize: settingsController.translationFontSize.value,
                      color: Colors.white,
                    ),
                  );
                }),
                // const SizedBox(height: 20),
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //             content: Text('Settings saved successfully!')),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.white,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 50, vertical: 15),
                //     ),
                //     child: const Text(
                //       "Save", // You can optionally keep this button for feedback.
                //       style: TextStyle(
                //         color: AppColors.backgroundBlue,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
