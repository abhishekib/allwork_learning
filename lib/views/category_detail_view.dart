import 'package:allwork/modals/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:allwork/views/audio_player_widget.dart';
import 'package:allwork/views/lyrics_tab.dart';

class CategoryDetailView extends StatelessWidget {
  const CategoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller and load arguments
    final CategoryDetailController controller =
        Get.put(CategoryDetailController());
    final Category categoryDetails =
        Get.arguments as Category; // Data passed from CategoryListView

    if (categoryDetails.cdata.isNotEmpty) {
      controller.initializeAudio(categoryDetails.cdata[0].audiourl);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryDetails.title),
      ),
      body: Obx(() {
        // Show loading spinner while data is being loaded
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (categoryDetails.cdata.isEmpty) {
          return const Center(child: Text("No data available"));
        } else {
          final lyricsList = categoryDetails.cdata[0].lyrics;
          final audioUrl = categoryDetails.cdata[0].audiourl;
          return Column(
            children: [
              // Audio Player
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AudioPlayerWidget(
                        audioUrl: audioUrl, controller: controller),
                    const SizedBox(height: 20),
                    Text(
                        "Duration: ${controller.currentTime.value} / ${controller.totalTime.value}"),
                    Slider(
                      min: 0,
                      max: controller.totalTime.value.toDouble(),
                      value: controller.currentTime.value.toDouble(),
                      onChanged: (value) {
                        controller.seekTo(value);
                      },
                    ),
                  ],
                ),
              ),

              // Tab Selector for "Arabic", "Transliteration", and "Translation"
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      onTap: (index) {
                        String type = 'Arabic';
                        if (index == 1) type = 'Transliteration';
                        if (index == 2) type = 'Translation';
                        controller.changeType(type); // Change selected type
                      },
                      tabs: const [
                        Tab(text: "Arabic"),
                        Tab(text: "Transliteration"),
                        Tab(text: "Translation"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 250,
                      child: TabBarView(
                        children: [
                          LyricsTab(lyricsList: lyricsList),
                          LyricsTab(lyricsList: lyricsList),
                          LyricsTab(lyricsList: lyricsList),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
