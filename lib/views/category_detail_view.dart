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
    // Instantiate the controller and load arguments
    final CategoryDetailController controller =
        Get.put(CategoryDetailController());
    final Category categoryDetails =
        Get.arguments as Category; // Data passed from CategoryListView

    // Extract the cdata to check for available types
    final cdata = categoryDetails.cdata;

    // Filter available types and lyrics based on the data provided
    final availableTypes = cdata.map((e) => e.type).toSet().toList();
    final availableLyrics = {for (var item in cdata) item.type: item.lyrics};

    // Check if there's any valid type to display tabs
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
            // Dynamic Tab Selector for available types
            TabBar(
              onTap: (index) {
                // Use the selected tab's type
                controller.changeType(availableTypes[index]);
              },
              tabs: availableTypes.map((type) => Tab(text: type)).toList(),
            ),
            const SizedBox(height: 10),
            // Use Flexible with loose fit to give TabBarView enough space
            Flexible(
              fit: FlexFit.loose,
              child: TabBarView(
                children: availableTypes.map((type) {
                  // Render corresponding lyrics in each tab
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
