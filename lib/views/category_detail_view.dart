import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/category_detail_controller.dart';
import 'package:allwork/views/lyrics_tab.dart';

class CategoryDetailView extends StatelessWidget {
  const CategoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryDetailController controller =
        Get.put(CategoryDetailController());
    final Category categoryDetails = Get.arguments as Category;

    final cdata = categoryDetails.cdata;

    final availableTypes = cdata
        .where((e) => e.lyrics.isNotEmpty)
        .map((e) => e.type)
        .toSet()
        .toList();
    final availableLyrics = {
      for (var item in cdata)
        if (item.lyrics.isNotEmpty) item.type: item.lyrics
    };

    if (availableTypes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(categoryDetails.title),
        ),
        body: const Center(child: Text("No data available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryDetails.title),
      ),
      body: DefaultTabController(
        length: availableTypes.length,
        child: Column(
          children: [
            TabBar(
              onTap: (index) {
                controller.changeType(availableTypes[index]);
              },
              tabs: availableTypes.map((type) => Tab(text: type)).toList(),
            ),
            const SizedBox(height: 10),
            Flexible(
              fit: FlexFit.loose,
              child: TabBarView(
                children: availableTypes.map((type) {
                  final List<Lyrics> lyricsList = availableLyrics[type] ?? [];
                  return LyricsTab(lyricsList: lyricsList);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
