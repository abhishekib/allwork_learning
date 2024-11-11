// lyrics_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';

class LyricsTab extends StatelessWidget {
  final List<dynamic> lyricsList;

  const LyricsTab({super.key, required this.lyricsList});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryDetailController>();

    return Obx(() {
      return ListView.builder(
        itemCount: lyricsList.length,
        itemBuilder: (context, index) {
          final lyrics = lyricsList[index];
          final isHighlighted = lyrics['type'] == controller.selectedType.value;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: isHighlighted ? Colors.yellowAccent : Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lyrics['arabic'] ?? '',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: isHighlighted
                            ? FontWeight.bold
                            : FontWeight.normal)),
                if (lyrics['translation'] != null)
                  Text(lyrics['translation'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: isHighlighted
                              ? FontWeight.bold
                              : FontWeight.normal)),
                if (lyrics['translitration'] != null)
                  Text(lyrics['translitration'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: isHighlighted
                              ? FontWeight.bold
                              : FontWeight.normal)),
              ],
            ),
          );
        },
      );
    });
  }
}
