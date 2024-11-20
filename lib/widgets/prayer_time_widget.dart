import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/prayer_time_controller.dart';

class PrayerTime {
  final String timeName;
  final String time;
  final String imagePath;

  PrayerTime(
      {required this.timeName, required this.time, required this.imagePath});
}

class PrayerTimeWidget extends StatelessWidget {
  final PrayerTimeController controller = Get.put(PrayerTimeController());

  PrayerTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.prayerTimeModel.value == null) {
        return const Center(child: Text("No prayer times available"));
      } else {
        final prayerTimes = [
          PrayerTime(
            timeName: 'Fajr',
            time: controller.prayerTimeModel.value!.fajr
                .replaceAll('(GMT)', '')
                .trim(),
            imagePath: 'assets/icons/Fajr.png',
          ),
          PrayerTime(
            timeName: 'Sunrise',
            time: controller.prayerTimeModel.value!.sunrise
                .replaceAll('(GMT)', '')
                .trim(),
            imagePath: 'assets/icons/image_5.png',
          ),
          PrayerTime(
            timeName: 'Dhuhr',
            time: controller.prayerTimeModel.value!.dhuhr
                .replaceAll('(GMT)', '')
                .trim(),
            imagePath: 'assets/icons/Dhuhr.png',
          ),
          PrayerTime(
            timeName: 'Sunset',
            time: controller.prayerTimeModel.value!.sunset
                .replaceAll('(GMT)', '')
                .trim(),
            imagePath: 'assets/icons/Maghrib.png',
          ),
          PrayerTime(
            timeName: 'Maghrib',
            time: controller.prayerTimeModel.value!.maghrib
                .replaceAll('(GMT)', '')
                .trim(),
            imagePath: 'assets/icons/image_7.png',
          ),
        ];

        return Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: prayerTimes.map((prayerTime) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          prayerTime.imagePath,
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(height: 8),
                        Text(prayerTime.timeName,
                            style: AppTextStyles.whiteText),
                        Text(
                          prayerTime.time,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }
    });
  }
}
