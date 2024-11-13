import 'package:allwork/modals/content_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';

class LyricsTab extends StatelessWidget {
  final List<Lyrics> lyricsList; // Updated to use List<Lyrics>

  const LyricsTab({super.key, required this.lyricsList});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryDetailController>();

    return ListView.builder(
      shrinkWrap: true, // Ensures ListView takes up minimal space
      physics: const AlwaysScrollableScrollPhysics(), // Always allow scrolling
      itemCount: lyricsList.length,
      itemBuilder: (context, index) {
        final lyrics = lyricsList[index];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final isArabicHighlighted = 
                    controller.selectedType.value == "arabic";
                return Visibility(
                  visible: lyrics.arabic.isNotEmpty,
                  child: Text(
                    lyrics.arabic,
                    style: TextStyle(
                      fontSize: isArabicHighlighted ? 22 : 18,
                      fontWeight: isArabicHighlighted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color:
                          isArabicHighlighted ? Colors.black87 : Colors.black54,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Obx(() {
                final isTransliterationHighlighted =
                    controller.selectedType.value == "transliteration";
                return Visibility(
                  visible: lyrics.translitration.isNotEmpty,
                  child: Text(
                    lyrics.translitration,
                    style: TextStyle(
                      fontSize: isTransliterationHighlighted ? 20 : 16,
                      fontWeight: isTransliterationHighlighted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isTransliterationHighlighted
                          ? Colors.black87
                          : Colors.black54,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Obx(() {
                final isTranslationHighlighted =
                    controller.selectedType.value == "translation";
                return Visibility(
                  visible: lyrics.translation.isNotEmpty,
                  child: Text(
                    lyrics.translation,
                    style: TextStyle(
                      fontSize: isTranslationHighlighted ? 20 : 16,
                      fontWeight: isTranslationHighlighted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isTranslationHighlighted
                          ? Colors.black87
                          : Colors.black54,
                    ),
                  ),
                );
              }),
              const Divider(height: 16, thickness: 1),
            ],
          ),
        );
      },
    );
  }
}
