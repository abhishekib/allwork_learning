import 'package:allwork/modals/contentData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ContentData contentData = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(contentData.type),
      ),
      body: Column(
        children: [
          Text(contentData
              .type), // Display type (Arabic/Transliteration/Translation)
          TextButton(
            onPressed: () {
              // Implement the actual audio player with contentData.audiourl
            },
            child: Text('Play Audio'),
          ),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Arabic'),
                    Tab(text: 'Transliteration'),
                    Tab(text: 'Translation'),
                  ],
                ),
                SizedBox(
                  height: 200, // Adjust this height based on your content
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: contentData.lyrics.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(contentData.lyrics[index].arabic),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: contentData.lyrics.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title:
                                Text(contentData.lyrics[index].translitration),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: contentData.lyrics.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(contentData.lyrics[index].translation),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
